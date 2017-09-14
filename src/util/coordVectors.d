module util.coordVectors;

import std.typecons;
import std.math;

import gl3n.linalg;

import util.values;
import util.mathM;

alias vec_square = VectorSquare;
alias vec_hex = VectorHex;
alias vec_block = VectorBlock;
alias vec_chunk = VectorChunk;

struct VectorSquare
{
	float x;
	float y;
	float z;	
	
	this(float x, float y, float z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	this(VectorHex c)
	{
		vec3 squareVec = toSquare(vec3(c.x,c.y,c.z));
		this(squareVec.x, squareVec.y, squareVec.z);
	}

	vec3 toVec3()
	{
		return vec3(x,y,z);
	}
	
	/**
	  * Binary Operations
	 **/
    public VectorSquare opBinary(string op)(VectorSquare r) if((op == "+") || (op == "-")) {
		VectorSquare t;
        mixin("t.x = x" ~ op ~ "r.x;");
        mixin("t.y = y" ~ op ~ "r.y;");
        mixin("t.z = z" ~ op ~ "r.z;");
		return t;
    }
	VectorSquare opBinary(string op)(double r) if((op == "*") || (op == "/")) {
		VectorSquare t;
        mixin("t.x = x" ~ op ~ "r;");
        mixin("t.y = y" ~ op ~ "r;");
        mixin("t.z = z" ~ op ~ "r;");
		return t;
    }
  	
   	/**
  	* Function taken from GL3N as allowed by the MIT license
	**/	
	VectorSquare opBinary(string op : "*")(quat rot)
	{
		VectorSquare result;	
		
		float ww = rot.w^^2;
		float w2 = rot.w * 2;
		float wx2 = w2 * rot.x;
		float wy2 = w2 * rot.y;
		float wz2 = w2 * rot.z;

		float xx = rot.x^^2;
		float x2 = rot.x * 2;
		float xy2 = x2 * rot.y;
		float xz2 = x2 * rot.z;

		float yy = rot.y^^2;
		float yz2 = 2 * rot.y * rot.z;

		float zz = rot.z^^2;

		result.x = ww * this.x + wy2 * this.z - wz2 * this.y + xx * this.x 
						+ xy2 * this.y + xz2 * this.z - zz * this.x - yy * this.x;

		result.y = xy2 * this.x + yy * this.y + yz2 * this.z + wz2 * this.x
			            - zz * this.y + ww * this.y - wx2 * this.z - xx * this.y;

		result.z = xz2 * this.x + yz2 * this.y + zz * this.z - wy2 * this.x
			            - yy * this.z + wx2 * this.y - xx * this.z + ww * this.z;

		return result;
	}

	/**
	  * Assignment Operations
	 **/
    public VectorSquare opOpAssign(string op)(VectorSquare r) if((op == "+") || (op == "-")) {
        mixin("x" ~ op ~ "= r.x;");
        mixin("y" ~ op ~ "= r.y;");
        mixin("z" ~ op ~ "= r.z;");
		return this;
    }
	public VectorSquare opOpAssign(string op)(double r) if((op == "*") || (op == "/")) {
        mixin("x" ~ op ~ "= r;");
        mixin("y" ~ op ~ "= r;");
        mixin("z" ~ op ~ "= r;");
		return this;
    }
}


struct VectorHex
{
	float x;
	float y;
	float z;	
	
	this(float x, float y, float z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	this(VectorSquare c)
	{
		vec3 hexVec = toHex(vec3(c.x,c.y,c.z));
		this(hexVec.x, hexVec.y, hexVec.z);
	}
}

struct VectorBlock
{
	int x;
	int y;
	int z;	
	
	this(int x, int y, int z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	this(VectorHex c)
	{
		this(cast(int)round(c.x), cast(int)floor(c.y), cast(int)round(c.z));
	}

	this(VectorSquare c)
	{
		vec3 hexVec = toHex(vec3(c.x,c.y,c.z));
		this(cast(int)round(hexVec.x), cast(int)floor(hexVec.y), cast(int)round(hexVec.z));
	}

	this(VectorChunk c)
	{
		this(c.x*CHUNK_SIZE, c.y*CHUNK_SIZE, c.z*CHUNK_SIZE);
	}
}

struct VectorChunk
{
	int x;
	int y;
	int z;	
	
	this(int x, int y, int z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	this(VectorBlock c)
	{
		this(cast(int)floor(c.x/16.0f),cast(int)floor(c.y/16.0f),cast(int)floor(c.z/16.0f));
	}
	
	/**
	  * Binary Operations
	 **/
    public VectorChunk opBinary(string op)(VectorChunk r) if((op == "+") || (op == "-")) {
		VectorChunk t;
        mixin("t.x = x" ~ op ~ "r.x;");
        mixin("t.y = y" ~ op ~ "r.y;");
        mixin("t.z = z" ~ op ~ "r.z;");
		return t;
    }

	/**
	  * Assignment Operations
	 **/
    public VectorChunk opOpAssign(string op)(VectorChunk r) if((op == "+") || (op == "-")) {
        mixin("x" ~ op ~ "= r.x;");
        mixin("y" ~ op ~ "= r.y;");
        mixin("z" ~ op ~ "= r.z;");
		return this;
    }
}








