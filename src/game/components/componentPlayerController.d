module componentPlayerController;

import std.stdio;
import std.math;
import std.algorithm;

import component;
import util.input;
import gl3n.linalg;

import gameObject;

import util.mathM;

class ComponentPlayerController : Component
{
	quat originalRot;
	float rotationX = 0.0f;
	float rotationY = 0.0f;


    public override void init(GameObject go, uint localID)
    {
        super.init(go, localID);

		originalRot = go.transform.rotation;
    }

	//TODO move sensitivity nonlocal
	float sensitivity = 0.5f;

    public override void Update()
    {
		//dirVec.x = dirVec.x * cos(-InputStates.mouseXRel * sensitivity) - dirVec.y * sin(-InputStates.mouseXRel * sensitivity);
		//dirVec.y = dirVec.x * sin(-InputStates.mouseXRel * sensitivity) + dirVec.y * cos(-InputStates.mouseXRel * sensitivity);

		//dirVec.z += sin(-InputStates.mouseYRel * sensitivity);

        vec3 movement;
		
        if(InputStates.keyW)
        {
			movement = gameObject.transform.rotation * vec3(0.0, 0.0, -0.1);
			movement.y = 0;
			transform.position += movement;
        }
        if(InputStates.keyS)
        {
			movement = gameObject.transform.rotation * vec3(0.0, 0.0, 0.1);
			movement.y = 0;
			transform.position += movement;
        }
        if(InputStates.keyA)
        {
			movement = gameObject.transform.rotation * vec3(-0.1, 0.0, 0.0);
			movement.y = 0;
			transform.position += movement;
        }
		if(InputStates.keyD)
        {
			movement = gameObject.transform.rotation * vec3(0.1, 0.0, 0.0);
			movement.y = 0;
			transform.position += movement;
        }
	

		//TODO implement actual, not shitty jump mechanics 	
		if(InputStates.keySPACE)
		{
			transform.position.y += 0.2f;
		}
		else
		{
			transform.position.y = (transform.position.y - 0.75) * 0.95f + 0.75f;
		}	

		rotationX -= InputStates.mouseXRel * sensitivity;
		rotationY -= InputStates.mouseYRel * sensitivity;

		rotationX = ClampAngle(rotationX, -360, 360);
		rotationY = ClampAngle(rotationY, -85, 85);

		transform.rotation = originalRot * quat.identity.rotatey(rotationX * (PI / 180)) * quat.identity.rotatex(rotationY * (PI / 180));
    }

	public static float ClampAngle (float angle, float min, float max)
	{
		if (angle < -360F)
			angle += 360F;
		if (angle > 360F)
			angle -= 360F;
		
		return clamp (angle, min, max);
	}
}
