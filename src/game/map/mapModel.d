import std.stdio;

import derelict.opengl3.gl;
import gl3n.linalg;

import map;

immutable vec3 dx = vec3(0.8660254,0,0.5);
immutable vec3 dy = vec3(0, 1, 0);
immutable vec3 dz = vec3(0,0,1);

immutable vec3[] hexVertices = [
	// top
	vec3(-0.57735027f, 0.0f,  0.0000f),
	vec3(-0.288675,    0.0f, -0.5f),
	vec3(0.288675,     0.0f, -0.5f),
	vec3(0.57735027f,  0.0f,  0.0000f),
	vec3(0.288675,     0.0f,  0.5f),
	vec3(-0.288675,    0.0f,  0.5f),

	// bottom 
	vec3(-0.57735027f, -1.0f,  0.0000f),
	vec3(-0.288675,    -1.0f, -0.5f),
	vec3(0.288675,     -1.0f, -0.5f),
	vec3(0.57735027f,  -1.0f,  0.0000f),
	vec3(0.288675, 	   -1.0f,  0.5f),
	vec3(-0.288675,    -1.0f,  0.5f)
];

class MapModel
{
	Map mWorldMap;

	ChunkModel[coordinate] cm;

	this(Map worldMap)
	{
		mWorldMap = worldMap;
	}	
	
	ref ChunkModel getChunkModel(coordinate c)
	{
		return cm[c];	
	}

	bool RefreshChunks()
	{
		bool didSomething = false;
		while(!mWorldMap.outdatedChunks.empty())
		{
			didSomething = true;

			coordinate c = mWorldMap.outdatedChunks.front();

			const ushort[16][16][16] chunk = mWorldMap.getChunkRef(c).hexes;

			ChunkModel model;
			
			foreach (x; 0 .. 16)
			{
			foreach (y; 0 .. 16)
			{
			foreach (z; 0 .. 16)
			{
				int texNum = chunk[x][y][z];
				if(!texNum)
				{
					continue;
				}

				//Top
				if(!mWorldMap.getBlockRelative(c,x,y+1,z))
				{
					addTop(model, x, y, z, texNum);
				}					
				//Bottom
				if(!mWorldMap.getBlockRelative(c,x,y-1,z))
				{
					addBottom(model, x, y, z, texNum);
				}					
				//Side 0
				if(!mWorldMap.getBlockRelative(c,x-1,y,z))
				{
					addSide!0(model, x, y, z, texNum);
				}
				//Side 1
				if(!mWorldMap.getBlockRelative(c,x,y,z-1))
				{
					addSide!1(model, x, y, z, texNum);
				}
				//Side 2
				if(!mWorldMap.getBlockRelative(c,x+1,y,z-1))
				{
					addSide!2(model, x, y, z, texNum);
				}
				//Side 3
				if(!mWorldMap.getBlockRelative(c,x+1,y,z))
				{
					addSide!3(model, x, y, z, texNum);
				}
				//Side 4
				if(!mWorldMap.getBlockRelative(c,x,y,z+1))
				{
					addSide!4(model, x, y, z, texNum);
				}
				//Side 5
				if(!mWorldMap.getBlockRelative(c,x-1,y,z+1))
				{
					addSide!5(model, x, y, z, texNum);
				}
			}
			}
			}

			model.loc = c;
			cm[c] = model;

			mWorldMap.outdatedChunks.removeFront();
		}

		return didSomething;
	}
	
	void addTop(ref ChunkModel model, int x, int y, int z, int texNum)
	{
		int offset = cast(int)model.positions.length;

		foreach(i; 0..6)
		{
			vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
			model.positions ~= [temp.x, temp.y, temp.z];
		}
		model.texCoords ~= [[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f]];
		model.indices ~= [[offset+0,offset+5,offset+1],[offset+1,offset+5,offset+4],
				[offset+1,offset+4,offset+2],[offset+2,offset+4,offset+3]];
	}
	void addBottom(ref ChunkModel model, int x, int y, int z, int texNum)
	{
		int offset = cast(int)model.positions.length;

		foreach(i; 6..12)
		{
			vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
			model.positions ~= [temp.x, temp.y, temp.z];
		}
		model.texCoords ~= [[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f]];

		model.indices ~= [[offset+0,offset+1,offset+5],[offset+1,offset+4,offset+5],
				[offset+1,offset+2,offset+4],[offset+2,offset+3,offset+4]];
	}

	void addSide(int side)(ref ChunkModel model, int x, int y, int z, int texNum)
	{
		int offset = cast(int)model.positions.length;

		foreach(i; [side+0,(side+1)%6,side+6,(side+1)%6+6])
		{
			vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
			model.positions ~= [temp.x, temp.y, temp.z];
		}
		model.texCoords ~= [[(16*texNum)/512f, 0.0f],[(16*texNum+8)/512f, 0.0f],
					[(16*texNum)/512f, 16f/512f],[(16*texNum+8)/512f, 16f/512f]];

		model.indices ~= [[offset+0,offset+1,offset+3],[offset+0,offset+3,offset+2]];
	}
}

struct ChunkModel
{
	GLfloat[3][] positions;
	GLfloat[2][] texCoords;
	GLint[3][] indices;

	coordinate loc;
}





