
package {{package}}.subsystems;

import edu.wpi.first.wpilibj.command.Subsystem;

/**
 *
 */
public class {{name}} extends Subsystem {

	{{#each sensors}}

	{{/each}}
	{{#each controllers}}
	private {{capFirst type}} {{name}} = new {{capFirst type}}({{port}});
	{{/each}}
    
    public {{name}}() {

    }

    public void initDefaultCommand() {
        // Set the default command for a subsystem here.
        //setDefaultCommand(new MySpecialCommand());
    }

    {{#each methods}}
	
	{{/each}}
}

