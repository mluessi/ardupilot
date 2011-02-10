
/*************************************************************
throttle control
****************************************************************/

// user input:
// -----------
void output_manual_throttle()
{
	rc_3.servo_out = (float)rc_3.control_in * angle_boost();
}

// Autopilot
// ---------
void output_auto_throttle()
{
	rc_3.servo_out 	= (float)nav_throttle * angle_boost();
	// make sure we never send a 0 throttle that will cut the motors
	rc_3.servo_out = max(rc_3.servo_out, 1);
}

void calc_nav_throttle()
{
	// limit error
	long error = constrain(altitude_error, -300, 300);
	
	if(altitude_sensor == BARO) {
		float t = pid_baro_throttle.kP();
		
		if(error > 0){
			//pid_baro_throttle.kP(.25);
		}else{
			pid_baro_throttle.kP(t/4.0);
		}
		// limit output of throttle control
		nav_throttle = throttle_cruise + constrain(nav_throttle, -20, 70);
		pid_baro_throttle.kP(t);
		
	} else {
		// SONAR
		nav_throttle = pid_sonar_throttle.get_pid(error, delta_ms_fast_loop, 1.0);
	
		// limit output of throttle control
		nav_throttle = throttle_cruise + constrain(nav_throttle, -60, 100);
	}
}

float angle_boost()
{
	// This is the furture replacement for the heavyweight trig functions in use now.
	//Matrix3f temp = dcm.get_dcm_matrix();
	//cos_pitch 	= sqrt(1 - (temp.c.x * temp.c.x));
	//cos_roll 		= dcm.c.z / cos_pitch;

	//static byte flipper;
	//float temp = 1 / (cos(dcm.roll) * cos(dcm.pitch));
	float temp = cos(dcm.roll) * cos(dcm.pitch);
	temp = 2.0 - constrain(temp, .7071, 1.0);
	return temp;
}


/*************************************************************
yaw control
****************************************************************/

void output_manual_yaw()
{
	if(rc_3.control_in == 0){
		clear_yaw_control();
	} else {
		// Yaw control
		if(rc_4.control_in == 0){
			//clear_yaw_control();
			output_yaw_with_hold(true); // hold yaw
		}else{
			output_yaw_with_hold(false); // rate control yaw
		}
	}
}

void auto_yaw()
{
	output_yaw_with_hold(true); // hold yaw
}

/*************************************************************
picth and roll control
****************************************************************/


/*// how hard to tilt towards the target
// -----------------------------------
void calc_nav_pid()
{
	// how hard to pitch to target
	
	nav_angle 	= pid_nav.get_pid(wp_distance * 100, dTnav, 1.0);
	nav_angle 	= constrain(nav_angle, -pitch_max, pitch_max);
}

// distribute the pitch angle based on our orientation
// ---------------------------------------------------
void calc_nav_pitch()
{
	// how hard to pitch to target

	long angle 	= wrap_360(nav_bearing - dcm.yaw_sensor);
	
	bool rev = false;
	float roll_out;
	
	if(angle > 18000){
		angle -= 18000;
		rev = true;
	}
	
	roll_out = abs(angle - 18000);
	roll_out = (9000.0 - roll_out) / 9000.0;
	roll_out = (rev) ? roll_out : -roll_out;

	nav_pitch = (float)nav_angle * roll_out;
}

// distribute the roll angle based on our orientation
// --------------------------------------------------
void calc_nav_roll()
{
	long angle 	= wrap_360(nav_bearing - dcm.yaw_sensor);

	bool rev = false;
	float roll_out;
	
	if(angle > 18000){
		angle -= 18000;
		rev = true;
	}
	
	roll_out = abs(angle - 9000);
	roll_out = (9000.0 - roll_out) / 9000.0;
	roll_out = (rev) ? -roll_out : roll_out;

	nav_roll = (float)nav_angle * roll_out;
}
*/










