module componentPlayerCamera;

import std.stdio;
import std.math;

import gl3n.linalg;

import util.input;

import component;
import IRenderable;
import gameObject;
import renderObjectData;
import logicalGameState;
import util.mathM;

class ComponentPlayerCamera : Component, IRenderable
{
	mat4 cameraMatrix = mat4.identity();

	public override void init(GameObject go, uint localID)
	{
	    super.init(go, localID);

        AddComponentToIterable(this, IterableComponentTypes.RENDERABLE);
	}

	public override RenderData Render()
	{
		//real nYaw = yaw(transform.rotation);
		
		//dirVec.y = cos(pitch(transform.rotation)) * sin(nYaw);
		//dirVec.x = sin(nYaw);
		//dirVec.z = cos(nYaw);
		//dirVec.y = sin(pitch(transform.rotation));

		vec3 dirVec = vec3(0,0,-1) * transform.rotation;
		//writeln(dirVec);

		cameraMatrix = mat4.look_at(transform.position + vec3(0, 1, 0), transform.position + vec3(0, 1, 0) + dirVec, vec3(0, 1, 0));

//        writeln("testCamera");

		byte[] serialized = *cast(byte[mat4.sizeof]*)(&cameraMatrix);

		return RenderData(0, serialized);
	}
}
