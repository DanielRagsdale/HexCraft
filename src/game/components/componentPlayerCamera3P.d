module componentPlayerCamera3P;

import std.stdio;

import gl3n.linalg;

import component;
import IRenderable;
import gameObject;
import renderObjectData;
import logicalGameState;

class ComponentPlayerCamera3P : Component, IRenderable
{
	mat4 cameraMatrix = mat4.identity();

	public override void init(GameObject go, uint localID)
	{
	    super.init(go, localID);

        AddComponentToIterable(this, IterableComponentTypes.RENDERABLE);
	}

	public override RenderData Render()
	{
		cameraMatrix = mat4.look_at(transform.position + vec3(0, -2, 3.5), transform.position, vec3(0, 0, 1));

//        writeln("testCamera");

		byte[] serialized = *cast(byte[mat4.sizeof]*)(&cameraMatrix);

		return RenderData(0, serialized);
	}
}
