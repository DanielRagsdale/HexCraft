module player;
import std.stdio;

import gl3n.linalg;

import util.input;

import logicalGameState;

import IRenderable;
import IPhysical;

import renderObjectData;
import util.mathM;

import gameObject;
import transform;
import map;

import util.values;
import util.coordVectors;

class Player : GameObject, IRenderable, IPhysical
{
	quat originalRot;
	float rotationX = 0.0f;
	float rotationY = 0.0f;

    public this(Transform trans)
	{
		super(trans);

        AddObjectToIterable(this, IterableObjectTypes.RENDERABLE);
        AddObjectToIterable(this, IterableObjectTypes.PHYSICAL);
		originalRot = transform.rotation;
	}

	//TODO move sensitivity nonlocal
	float sensitivity = 0.5f;

	Transform lastTrans;
	bool jumped = false;
	bool lPressed = false;
	bool rPressed = false;

    public override void Update(ref Map map)
    {
		lastTrans = transform;

        vec_square movement;
	
		transform.velocity.x = 0.0f;
		transform.velocity.z = 0.0f;

        if(InputStates.keyW)
        {
			movement = vec_square(0.0, 0.0, -1) * transform.rotation;
			movement.y = 0;
			transform.velocity += movement * SPEED_TRUE;
        }
        if(InputStates.keyS)
        {
			movement = vec_square(0.0, 0.0, 1) * transform.rotation;
			movement.y = 0;
			transform.velocity += movement * SPEED_TRUE;
        }
        if(InputStates.keyA)
        {
			movement = vec_square(-1, 0.0, 0.0) * transform.rotation;
			movement.y = 0;
			transform.velocity += movement * SPEED_TRUE;
        }
		if(InputStates.keyD)
        {
			movement = vec_square(1, 0.0, 0.0) * transform.rotation;
			movement.y = 0;
			transform.velocity += movement * SPEED_TRUE;
        }

		//TODO implement actual, not shitty jump mechanics 	
		if(InputStates.keySPACE && !jumped)
		{
			transform.velocity.y = 5.0f;
			jumped = true;
		}
		else if(!InputStates.keySPACE)
		{
			jumped = false;
		}

		if(InputStates.mouseLEFT && !lPressed)
		{
			//Stupid raycast
			vec_square looking = vec_square(0.0, 0.0, -0.1) * transform.rotation;
			
			for(int i = 0; i < 60; i++)
			{
				vec_block blockPos = cast(vec_block)(transform.position + vec_square(0,1.5,0) + looking * i);
				ushort block = map.getBlock(blockPos);

				if(block)
				{
					map.setBlock(blockPos, 0);
					break;
				}
			}

			lPressed = true;
		}
		else if(!InputStates.mouseLEFT)
		{
			lPressed = false;
		}
		if(InputStates.mouseRIGHT && !rPressed)
		{
			//Stupid raycast
			vec_square looking = vec_square(0.0, 0.0, -0.1) * transform.rotation;
			
			for(int i = 0; i < 60; i++)
			{
				vec_block blockPos = cast(vec_block)(transform.position + vec_square(0,1.5,0) + looking * i);
				ushort block = map.getBlock(blockPos);

				if(block)
				{
					map.setBlock(blockPos, ++block);
					break;
				}
			}

			rPressed = true;
		}
		else if(!InputStates.mouseRIGHT)
		{
			rPressed = false;
		}

		rotationX -= InputStates.mouseXRel * sensitivity;
		rotationY -= InputStates.mouseYRel * sensitivity;

		rotationX = ClampAngle(rotationX, -360, 360);
		rotationY = ClampAngle(rotationY, -85, 85);

		transform.rotation = originalRot * quat.identity.rotatey(rotationX 
				* (PI / 180)) * quat.identity.rotatex(rotationY * (PI / 180));
    }

	public double getRadius()
	{
		return 0.75;
	}

	mat4 cameraMatrix = mat4.identity();

	public override RenderData Render(double tickOffset)
	{
		Transform interpTrans = transform;
		interpTrans += (transform - lastTrans) * (tickOffset / PHYSICS_DT);
		
		vec3 dirVec = vec3(0,0,-1) * interpTrans.rotation;


		cameraMatrix = mat4.look_at(interpTrans.position.toVec3() + vec3(0, 0.75, 0), interpTrans.position.toVec3() + vec3(0, 0.75, 0) + dirVec, vec3(0, 1, 0));

		byte[] serialized = *cast(byte[mat4.sizeof]*)(&cameraMatrix);
		return RenderData(0, serialized);
	}
}	


