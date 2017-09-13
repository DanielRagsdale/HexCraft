module util.mathM;

import std.math;
import std.stdio;

import gl3n.linalg;

import util.values;

//TODO
real roll(quat q)
{
	return -1.0;
}

	import std.stdio;

@safe pure nothrow	
real pitch(quat q)
{
	return asin(2*(q.w*q.y - q.z*q.x));
}



//TODO investigate UFCS bug
real yaw(quat q)
{
	return atan2(2*(q.w*q.z+q.x*q.y),  1-2*(q.y*q.y + q.z*q.z));
}


public static float ClampAngle (float angle, float min, float max)
{
	if (angle < -360F)
	{
		angle += 360F;
		return ClampAngle(angle, min, max);
	}
	if (angle > 360F)
	{
		angle -= 360F;
		return ClampAngle(angle, min, max);
	}
		
	return clamp (angle, min, max);
}


vec3 toHex(vec3 rect)
{
	return rect * matrixToHex;
}

vec3 toSquare(vec3 hex)
{
	return hex * matrixToSquare;
}



