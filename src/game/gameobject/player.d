module player;

import std.stdio;

import gl3n.linalg;

import util.input;

import logicalGameState;

import IRenderable;
import renderObjectData;
import util.mathM;

import gameObject;
import map;

import util.values;

class Player : GameObject, IRenderable
{
	quat originalRot;
	float rotationX = 0.0f;
	float rotationY = 0.0f;

    public this(Transform trans)
	{
		super(trans);

        AddObjectToIterable(this, IterableObjectTypes.RENDERABLE);
		originalRot = transform.rotation;
	}

	//TODO move sensitivity nonlocal
	float sensitivity = 0.5f;

	Transform lastTrans;

    public override void Update(ref Map map)
    {
		lastTrans = transform;

        vec3 movement;
		
        if(InputStates.keyW)
        {
			movement = transform.rotation * vec3(0.0, 0.0, -1);
			movement.y = 0;
			transform.position += movement.normalized() * SPEED;
        }
        if(InputStates.keyS)
        {
			movement = transform.rotation * vec3(0.0, 0.0, 1);
			movement.y = 0;
			transform.position += movement.normalized() * SPEED;
        }
        if(InputStates.keyA)
        {
			movement = transform.rotation * vec3(-1, 0.0, 0.0);
			movement.y = 0;
			transform.position += movement.normalized() * SPEED;
        }
		if(InputStates.keyD)
        {
			movement = transform.rotation * vec3(1, 0.0, 0.0);
			movement.y = 0;
			transform.position += movement.normalized() * SPEED;
        }
	

		//TODO implement actual, not shitty jump mechanics 	
		if(InputStates.keySPACE)
		{
			transform.position.y += 0.2f;
		}
		else
		{
			vec3 hexPos = toHex(transform.position);
			if(!map.getBlock(cast(int)hexPos.x, cast(int)hexPos.y - 1, cast(int)hexPos.z))
			{
				transform.position.y -= 1;
			}
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

	mat4 cameraMatrix = mat4.identity();

	public override RenderData Render(double tickOffset)
	{
		Transform interpTrans = transform;
		interpTrans += (transform - lastTrans) * (tickOffset / PHYSICS_DT);
		
		vec3 dirVec = vec3(0,0,-1) * interpTrans.rotation;


		cameraMatrix = mat4.look_at(interpTrans.position + vec3(0, 1, 0), interpTrans.position + vec3(0, 1, 0) + dirVec, vec3(0, 1, 0));

		byte[] serialized = *cast(byte[mat4.sizeof]*)(&cameraMatrix);
		return RenderData(0, serialized);
	}
}	


