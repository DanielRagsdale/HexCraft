module util.coordinates;

import std.typecons;
import std.math;

import gl3n.linalg;

import util.values;
import util.mathM;

alias crd_square = CoordinateSquare;
alias crd_hex = CoordinateHex;
alias crd_block = CoordinateBlock;
alias crd_chunk = CoordinateChunk;

struct CoordinateSquare
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

	this(CoordinateHex c)
	{
		vec3 squareVec = toSquare(vec3(c.x,c.y,c.z));
		this(squareVec.x, squareVec.y, squareVec.z);
	}
}


struct CoordinateHex
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

	this(CoordinateSquare c)
	{
		vec3 hexVec = toHex(vec3(c.x,c.y,c.z));
		this(hexVec.x, hexVec.y, hexVec.z);
	}
}

struct CoordinateBlock
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

	this(CoordinateHex c)
	{
		this(cast(int)round(c.x), cast(int)floor(c.y), cast(int)round(c.z));
	}

	this(CoordinateSquare c)
	{
		vec3 hexVec = toHex(vec3(c.x,c.y,c.z));
		this(cast(int)round(hexVec.x), cast(int)floor(hexVec.y), cast(int)round(hexVec.z));
	}

	this(CoordinateChunk c)
	{
		this(c.x*CHUNK_SIZE, c.y*CHUNK_SIZE, c.z*CHUNK_SIZE);
	}
}

struct CoordinateChunk
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

	this(CoordinateBlock c)
	{
		this(cast(int)floor(c.x/16.0f),cast(int)floor(c.y/16.0f),cast(int)floor(c.z/16.0f));
	}
}








