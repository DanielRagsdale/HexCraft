import gl3n.linalg;

import util.coordVectors;


/**
* Struct that holds the position, rotation, and scale of a GameObject
*/
struct Transform
{
    public vec_square position;
    public quat rotation;
    public vec3 scale;

	public vec_square velocity;

    alias get_comp!("position","x") x;
    alias get_comp!("position","y") y;
    alias get_comp!("position","z") z;

    alias get_comp!("scale","x") sx;
    alias get_comp!("scale","y") sy;
    alias get_comp!("scale","z") sz;

    alias get_comp!("velocity","x") vx;
    alias get_comp!("velocity","y") vy;
    alias get_comp!("velocity","z") vz;

    /**
    * Create a Transform with the given position and default scale and rotation
    */
    //TODO Expand to allow more general creation
    public this(vec_square pos)
    {
		this(pos, quat.identity, vec3(1,1,1));
    }

	public this(vec_square pos, quat rot)
	{
		this(pos, rot, vec3(1,1,1));
	}
	
	public this(vec_square pos, vec3 sc)
	{
		this(pos, quat.identity, sc);
	}

	public this(vec_square pos, quat rot, vec3 sc)
	{
        position = pos;
        rotation = rot;
        scale = sc; 
		velocity = vec_square(0,0,0);
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
	private @property ref get_comp(string aspect, string comp)()
	{
		mixin("return " ~ aspect ~ "." ~ comp ~ ";");
	}

	
	/**
	  * Binary Operations
	 **/
    public Transform opBinary(string op)(double r) if((op == "*") || (op == "/")) {
		Transform t;
        mixin("t.position = position" ~ op ~ "r;");
        mixin("t.rotation = rotation" ~ op ~ "r;");
		t.scale = scale;
		return t;
    }

    public Transform opBinary(string op)(Transform r) if((op == "+") || (op == "-")) {
		Transform t;
        mixin("t.position = position" ~ op ~ "r.position;");
        mixin("t.rotation = rotation" ~ op ~ "r.rotation;");
		t.scale = scale;
		return t;
    }

    public Transform opBinary(string op)(vec_square r) if((op == "+") || (op == "-")) {
		Transform t;
        mixin("t.position = position" ~ op ~ "r;");
		t.rotation = rotation;
		t.scale = scale;
		return t;
	}

	/**
	  * Assignment Operations
	 **/

    public Transform opOpAssign(string op)(double r) if((op == "*") || (op == "/")) {
        mixin("position" ~ op ~ "= r;");
        mixin("rotation" ~ op ~ "= r;");
		return this;
    }

    public Transform opOpAssign(string op)(Transform r) if((op == "+") || (op == "-")) {
        mixin("position" ~ op ~ "= r.position;");
        mixin("rotation" ~ op ~ "= r.rotation;");
		return this;
    }

    public Transform opOpAssign(string op)(vec_square r) if((op == "+") || (op == "-")) {
        mixin("position" ~ op ~ "= r;");
		return this;
    }
}
