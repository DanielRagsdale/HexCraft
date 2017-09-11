module player;

import gl3n.linalg;

import util.input;

import logicalGameState;

import IRenderable;
import renderObjectData;
import util.mathM;

import gameObject;

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

    public override void Update()
    {
		//dirVec.x = dirVec.x * cos(-InputStates.mouseXRel * sensitivity) - dirVec.y * sin(-InputStates.mouseXRel * sensitivity);
		//dirVec.y = dirVec.x * sin(-InputStates.mouseXRel * sensitivity) + dirVec.y * cos(-InputStates.mouseXRel * sensitivity);

		//dirVec.z += sin(-InputStates.mouseYRel * sensitivity);

        vec3 movement;
		
        if(InputStates.keyW)
        {
			movement = transform.rotation * vec3(0.0, 0.0, -0.1);
			movement.y = 0;
			transform.position += movement;
        }
        if(InputStates.keyS)
        {
			movement = transform.rotation * vec3(0.0, 0.0, 0.1);
			movement.y = 0;
			transform.position += movement;
        }
        if(InputStates.keyA)
        {
			movement = transform.rotation * vec3(-0.1, 0.0, 0.0);
			movement.y = 0;
			transform.position += movement;
        }
		if(InputStates.keyD)
        {
			movement = transform.rotation * vec3(0.1, 0.0, 0.0);
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

	mat4 cameraMatrix = mat4.identity();

	public override RenderData Render()
	{
		//real nYaw = yaw(transform.rotation);
		
		//dirVec.y = cos(pitch(transform.rotation)) * sin(nYaw);
		//dirVec.x = sin(nYaw);
		//dirVec.z = cos(nYaw);
		//dirVec.y = sin(pitch(transform.rotation));

		vec3 dirVec = vec3(0,0,-1) * transform.rotation;
		//writeln(dirVec);

		cameraMatrix = mat4.look_at(transform.position + vec3(0, 1, 0), 
				transform.position + vec3(0, 1, 0) + dirVec, vec3(0, 1, 0));

		byte[] serialized = *cast(byte[mat4.sizeof]*)(&cameraMatrix);

		return RenderData(0, serialized);
	}
}	


