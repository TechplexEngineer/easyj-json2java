package org.usfirst.frc5122.Fred2;

import edu.wpi.first.wpilibj.Joystick;

public class Xbox {
	private Joystick _joystick;
	Xbox(int port) {
		_joystick = new Joystick(port);
	}
	Xbox(Joystick js) {
		_joystick = js;
	}
	public boolean isA() {
		return getRawButton(1);
	}
	public boolean isB() {
		return getRawButton(2);
	}
	public boolean isX() {
		return getRawButton(3);
	}
	public boolean isY() {
		return getRawButton(4);
	}
	public boolean isLB() {
		return getRawButton(5);
	}
	public boolean isRB() {
		return getRawButton(6);
	}
	public boolean isBack() {
		return getRawButton(7);
	}
	public boolean isStart() {
		return getRawButton(8);
	}
	public boolean isLeftStick() {
		return getRawButton(9);
	}
	public boolean isRightStick() {
		return getRawButton(10);
	}
 
 
 
	public double getLeftStickX() {
		return getRawAxis(0);
	}
	public double getLeftStickY() {
		return getRawAxis(1);
	}
 
	public double getLeftTrigger() {
		return getRawAxis(2);
	}
	public double getRightTrigger() {
		return getRawAxis(3);
	}
 
	public double getRightStickX() {
		return getRawAxis(4);
	}
	public double getRightStickY() {
		return getRawAxis(5);
	}
 
	public boolean getRawButton(int button) {
		return _joystick.getRawButton(button);
	}
	public double getRawAxis(int axis) {
		return _joystick.getRawAxis(axis);
	}
 
}
