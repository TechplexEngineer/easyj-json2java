
inputfile = "input.json"
outputdir = "out"
templatedir = "tpl"
info = {
	team_number: 5122,
	pkgarr: ['org'],
	# package: this.pkgarr.join('.')
}
info.pkgarr.push('t'+info.team_number)
info.package = info.pkgarr.join('.')

fs = require("fs")
_ = require('lodash')

file = fs.readFileSync(inputfile)
data = JSON.parse(file)

# templates to iterate through
# this has the limitation that you can't have the same named classes in your project
files = [
	{
		template: 'Robot.java',
		parse: true,
		out:"out/src/"+info.pkgarr.join('/')+"/Robot.java",
		data: {
			'package': info.package,
			'autos': [
				{
					type:"Default",
					name:"Default Command",
					command:"DefaultAuto"
				},{	
					type:"Object",
					name:"Regular Command",
					command:"RegularAuto"
				}
			],
			subsystems: _.pluck(data.subsystems, "name")
		}
	},{
		template: 'JoystickAxisButton.java',
		parse: false,
		out:"out/src/edu/wpi/first/wpilibj/buttons/JoystickAxisButton.java",
	},{
		template: 'Xbox.java',
		parse: false,
		out:"out/src/edu/wpi/first/wpilibj/Xbox.java",
	},{
		template: 	'OI.java',
		parse: true,
		out: "out/src/"+info.pkgarr.join('/')+"/OI.java",
		data: {
			'package': info.package,
			"hids": data.hids, 
			old: [
				{
					"name": "d1",
					"port": "0",
					"type": "joystick"
				},
				{
					"name": "d2",
					"port": "1",
					"type": "xbox"
				},
				{
					"name": "d3",
					"port": "2",
					"type": "ps"
				}
			],
			'buttons': []
		}
	},{
		template: 	'Constants.java',
		parse:true,
		out: "out/src/"+info.pkgarr.join('/')+"/Constants.java",
		data: {
			'package': info.package,
		}
	},{
		template: 'build.properties',
		parse: true,
		out: 'out/build.properties',
		data: {
			'package': info.package,
		}
	},{
		template: '.classpath',
		parse: false,
		out:"out/.classpath",
	},{
		template: '.project',
		parse: false,
		out:"out/.project",
	},{
		template: 'build.xml',
		parse: false,
		out:"out/build.xml",
	}
]

# Drivetrain @todo combine with subsys loop below
if data.hasDrivetrain == "yes"
	dt = data.drivetrain
	subsys = _.where(data.subsystems, {"name": "Drivetrain"})
	if subsys.length != 1
		console.err("Multiply defined subystem:",dt.subsystem)
	actions = subsys[0].actions
	# console.log(actions)
	sen = _.where(data.sensors.analog, {"subsystem": dt.subsystem})
	sen = sen.concat(_.where(data.sensors.digital, {"subsystem": dt.subsystem}))

	files.push({
		template: 'Subsystem.java'
		parse: true,
		out: "out/src/"+info.pkgarr.join('/')+"/subsystems/"+dt.subsystem+".java",
		data: {
			package: info.package,
			name: dt.subsystem,
			sensors: sen,
			controllers: dt.controllers,
			methods: actions,
			solenoids: _.where(data.solenoids, {"subsystem": dt.subsystem})
		}
	});
# Other subsystems:
for sub in data.subsystems
	if sub.name isnt "Drivetrain"
		sen = _.where(data.sensors.analog, {"subsystem": sub.name})
		sen = sen.concat(_.where(data.sensors.digital, {"subsystem": sub.name}))
		files.push({
			template: 'Subsystem.java'
			parse: true,
			out: "out/src/"+info.pkgarr.join('/')+"/subsystems/"+sub.name+".java",
			data: {
				package: info.package,
				name: sub.name,
				sensors: sen,
				controllers: _.where(data.controllers, {"subsystem": sub.name}),
				solenoids: _.where(data.solenoids, {"subsystem": sub.name})
				methods: sub.actions,
			}
		})

# Commands
for cmd in data.commands
	# console.log(cmd)
	
	if cmd.type == 'cmd'
		files.push({
				template: 'Command.java'
				parse: true,
				out: "out/src/"+info.pkgarr.join('/')+"/commands/"+cmd.name+".java",
				data: {
					package: info.package,
					name: cmd.name,
					req: cmd.requires
				}
			})

# Auto Commands


h = require("Handlebars")
path = require("path")
mkdirp = require('mkdirp').sync;

h.registerHelper 'capFirst', (string) ->
    return string.charAt(0).toUpperCase() + string.slice(1);

render = (infile, data, outfile) ->
	template = fs.readFileSync(infile).toString()
	out = h.compile(template)(data)
	dir = path.dirname(outfile)
	mkdirp(dir)
	fs.writeFileSync(outfile, out)

# copyFile = (source, target, cb) ->
# 	cbCalled = false
# 	rd = fs.createReadStream(source)

# 	done = (err) ->
# 		if !cbCalled and cb
# 			cb err
# 			cbCalled = true
# 		return

# 	rd.on 'error', done
# 	wr = fs.createWriteStream(target)
# 	wr.on 'error', done
# 	wr.on 'close', (ex) ->
# 		done()
# 		return
# 	rd.pipe wr
# 	return

# render could be combined with this.
copyFile = (infile, outfile) ->
	out = fs.readFileSync(infile).toString()
	dir = path.dirname(outfile)
	mkdirp(dir)
	fs.writeFileSync(outfile, out)

console.log("Processing Files")

for item in files
	console.log(item.out)
	if item.parse
		render(path.join(templatedir, item.template), item.data, item.out)
	else
		copyFile(path.join(templatedir, item.template), item.out)

console.log("Done")