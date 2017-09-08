import renderObjectData;
import gl3n.linalg;
import std.stdio;
import core.vararg;
//import core.vararg;

import component;
import IRenderable;

/**
* Class representing a GameObject which exists in the scene. Implements component functionality.
*/
class GameObject
{
    /**
    * The unique ID of this GameObject
    */
    public uint ID;

    /**
    * The transform object associated with this GameObject
    */
    public Transform transform;

    /**
    * Array of the components this object houses
    */
    public Component[] components;

    protected this(float x, float y, float z)
    {
        transform.x = x;
        transform.y = y;
        transform.z = z;
    }

    /**
    * Create a GameObject with given transform and components
    */
    public this(Transform trans, Component[] comps ...)
    {
        transform = trans;

        this(comps);
    }

    /**
    * Create a GameObject with given components
    */
    public this(Component[] comps ...)
    {
        foreach(Component c; comps)
        {
            components ~= c;
        }
    }

    /**
    * Called when this GameObject is added to the scene
    */
    public void Register(uint ID)
    {
        this.ID = ID;

        for(int i = 0; i < components.length; i++)
        {
            components[i].init(this, i);
        }
    }

    /**
    * Called once per game tick
    */
    public void Update()
    {
        foreach(Component c; components)
        {
            c.Update();
        }
    }

    /**
    * Returns the transform mat4 associated with this GameObject.
    */
    public mat4 GetTransformMatrix()
    {
        mat4 transMatrix = mat4.identity();

        transMatrix.translate(transform.x, transform.y, transform.z);
        transMatrix.scale(transform.sx, transform.sy, transform.sz);

        //transMatrix.Rotate();


        mat4 mat = transform.rotation.to_matrix!(4, 4);

        return mat4.identity();
    }

    public ulong GetID()
    {
        return ID;
    }

    public Transform GetTransform()
    {
        return transform;
    }
}

/**
* Struct that holds the position, rotation, and scale of a GameObject
*/
struct Transform
{
    public vec3 position;
    public quat rotation;
    public vec3 scale;

    alias getp_!"x" x;
    alias getp_!"y" y;
    alias getp_!"z" z;

    alias gets_!"x" sx;
    alias gets_!"y" sy;
    alias gets_!"z" sz;

    /**
    * Create a Transform with the given position and default scale and rotation
    */
    //TODO Expand to allow more general creation
    public this(vec3 pos)
    {
        position = pos;
        rotation = quat.identity;
        scale = vec3(1, 1, 1);
    }

	public this(vec3 pos, quat rot)
	{
        position = pos;
        rotation = rot;
        scale = vec3(1, 1, 1);
	}
	
	public this(vec3 pos, quat rot, vec3 sc)
	{
        position = pos;
        rotation = rot;
        scale = sc; 
	}
	
	public this(vec3 pos, vec3 sc)
	{
        position = pos;
        rotation = quat.identity;
        scale = sc; 
	}

    public mat4 GetTransformMatrix()
    {
        //Rotation
        mat4 outMatrix = rotation.to_matrix!(4, 4)();

        //Scale
        outMatrix.scale(sx, sy, sz);

        //Translation
        outMatrix[0][3] = x;
        outMatrix[1][3] = y;
        outMatrix[2][3] = z;

        //Point type modifier
        outMatrix[3][3] = 1.0f;

        return outMatrix;
    }

    @safe pure nothrow:
    private @property ref getp_(string coord)()
    {
        mixin("return position." ~ coord[coord.length - 1] ~ ";");
    }

    @safe pure nothrow:
    private @property ref gets_(string coord)()
    {
        mixin("return scale." ~ coord[coord.length - 1] ~ ";");
    }


    void opOpAssign(string op)(Transform r) if((op == "+") || (op == "-")) {
        mixin("x" ~ op ~ "= r.x;");
        mixin("y" ~ op ~ "= r.y;");
        mixin("z" ~ op ~ "= r.z;");
    }

    void opOpAssign(string op)(vec3 r) if((op == "+") || (op == "-")) {
        mixin("x" ~ op ~ "= r.x;");
        mixin("y" ~ op ~ "= r.y;");
        mixin("z" ~ op ~ "= r.z;");
    }
}
