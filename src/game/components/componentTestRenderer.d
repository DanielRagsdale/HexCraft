module componentTestRenderer;

import std.stdio;

import renderObjectData;
import component;
import IRenderable;
import gameObject;
import logicalGameState;

import gl3n.linalg;

class ComponentTestRenderer : Component, IRenderable
{
    mat4 m5;

    short meshID;
	short renderFunc;

	public this(short rf, short meshID)
	{
		this.meshID = meshID;
		this.renderFunc = rf;
	}

	public override void init(GameObject go, uint localID)
	{
	    super.init(go, localID);

        AddComponentToIterable(this, IterableComponentTypes.RENDERABLE);
	}

    public override RenderData Render()
    {

		m5 = transform.GetTransformMatrix();

        byte[] byteID = *cast(byte[short.sizeof]*)(&meshID);

        byte[] serialized = *cast(byte[mat4.sizeof]*)(&m5);

        return RenderData(renderFunc, byteID ~ serialized);
    }
}
