import std.stdio;

import derelict.opengl3.gl;
import gl3n.linalg;

import util.values;
import util.coordVectors;

import hexes;

import map;



immutable vec3[] hexVertices = [
	// top
	vec3(-0.57735027f, 1.0f,  0.0000f),
	vec3(-0.288675,    1.0f, -0.5f),
	vec3(0.288675,     1.0f, -0.5f),
	vec3(0.57735027f,  1.0f,  0.0000f),
	vec3(0.288675,     1.0f,  0.5f),
	vec3(-0.288675,    1.0f,  0.5f),

	// bottom 
	vec3(-0.57735027f, 0.0f,  0.0000f),
	vec3(-0.288675,    0.0f, -0.5f),
	vec3(0.288675,     0.0f, -0.5f),
	vec3(0.57735027f,  0.0f,  0.0000f),
	vec3(0.288675, 	   0.0f,  0.5f),
	vec3(-0.288675,    0.0f,  0.5f)
];

immutable vec2[] texPos = [
	vec2(0.0f, 0.0f),
	vec2(16f/512f, 0.0f),
	vec2(0.0f, 32f/512f),
	vec2(16f/512f, 32f/512f),


	vec2(0.0f, 0.5f) * 16f/512f,
	vec2(0.25, 0.066987f) * 16f/512f,
	vec2(0.75, 0.066987f) * 16f/512f,

	vec2(1.0f, 0.5f) * 16f/512f,
	vec2(0.75f, 0.93301f) * 16f/512f,
	vec2(0.25f, 0.93301f) * 16f/512f
];

class MapModel
{
	Map mWorldMap;

	public ChunkModel[vec_chunk] cm;

	this(Map worldMap)
	{
		mWorldMap = worldMap;
	}	
	
	ref ChunkModel getChunkModel(vec_chunk c)
	{
		return cm[c];	
	}

	bool RefreshChunks()
	{
		bool didSomething = false;
		while(mWorldMap.outdatedChunks.length > 0)
		{
			uint chunkVersion = 0;

			didSomething = true;

			vec_chunk c = mWorldMap.outdatedChunks.keys[0];

			ChunkModel* old = c in cm;
			if(old !is null)
			{
				chunkVersion = old.chunkVersion + 1;
			}
			

			const ushort[16][16][16] chunk = mWorldMap.getChunkRef(c).hexes;
			ChunkModel model;
			
			foreach (x; 0 .. 16)
			{
			foreach (y; 0 .. 16)
			{
			foreach (z; 0 .. 16)
			{
				int blockNum = chunk[x][y][z];
				if(!blockNum)
				{
					continue;
				}

				//Side 0
				if(!mWorldMap.getBlockRelative(c,x-1,y,z))
				{
					addSide!0(model, x, y, z, HexTypes[blockNum].GetTexture(0));
				}
				//Side 1
				if(!mWorldMap.getBlockRelative(c,x,y,z-1))
				{
					addSide!1(model, x, y, z, HexTypes[blockNum].GetTexture(1));
				}
				//Side 2
				if(!mWorldMap.getBlockRelative(c,x+1,y,z-1))
				{
					addSide!2(model, x, y, z, HexTypes[blockNum].GetTexture(2));
				}
				//Side 3
				if(!mWorldMap.getBlockRelative(c,x+1,y,z))
				{
					addSide!3(model, x, y, z, HexTypes[blockNum].GetTexture(3));
				}
				//Side 4
				if(!mWorldMap.getBlockRelative(c,x,y,z+1))
				{
					addSide!4(model, x, y, z, HexTypes[blockNum].GetTexture(4));
				}
				//Side 5
				if(!mWorldMap.getBlockRelative(c,x-1,y,z+1))
				{
					addSide!5(model, x, y, z, HexTypes[blockNum].GetTexture(5));
				}
				//Top
				if(!mWorldMap.getBlockRelative(c,x,y+1,z))
				{
					addTop(model, x, y, z, HexTypes[blockNum].GetTexture(6));
				}					
				//Bottom
				if(!mWorldMap.getBlockRelative(c,x,y-1,z))
				{
					addBottom(model, x, y, z, HexTypes[blockNum].GetTexture(7));
				}					
			}
			}
			}

			model.loc = c;
			model.chunkVersion = chunkVersion;

			cm[c] = model;

			mWorldMap.outdatedChunks.remove(c);
		}

		return didSomething;
	}
	
	void addSide(int side)(ref ChunkModel model, int x, int y, int z, int texNum)
	{
		int offset = cast(int)model.positions.length;

		vec2 texOff = vec2((16*texNum)/512f, 0.0f);

		foreach(i, j; [side+0,(side+1)%6,side+6,(side+1)%6+6])
		{
			vec3 temp = (hexVertices[j] + x*hex_dx + y*hex_dy + z*hex_dz);
			model.positions ~= [temp.x, temp.y, temp.z];

			model.texCoords ~= [(texPos[i] + texOff).x, (texPos[i] + texOff).y];
		}

		model.indices ~= [[offset+0,offset+1,offset+3],[offset+0,offset+3,offset+2]];
	}

	void addTop(ref ChunkModel model, int x, int y, int z, int texNum)
	{
		int offset = cast(int)model.positions.length;

		vec2 texOff = vec2((16*texNum)/512f, 0.5f);
		foreach(i; 0..6)
		{
			vec3 temp = (hexVertices[i] + x*hex_dx + y*hex_dy + z*hex_dz);
			model.positions ~= [temp.x, temp.y, temp.z];
			
			model.texCoords ~= [(texPos[i+4] + texOff).x, (texPos[i+4] + texOff).y];
		}
		
		model.indices ~= [[offset+0,offset+5,offset+1],[offset+1,offset+5,offset+4],
				[offset+1,offset+4,offset+2],[offset+2,offset+4,offset+3]];
	}
	void addBottom(ref ChunkModel model, int x, int y, int z, int texNum)
	{
		int offset = cast(int)model.positions.length;

		vec2 texOff = vec2((16*texNum)/512f, 0.5f);
		foreach(i; 6..12)
		{
			vec3 temp = (hexVertices[i] + x*hex_dx + y*hex_dy + z*hex_dz);
			model.positions ~= [temp.x, temp.y, temp.z];
			
			model.texCoords ~= [(texPos[i-2] + texOff).x, (texPos[i-2] + texOff).y];
		}

		model.indices ~= [[offset+0,offset+1,offset+5],[offset+1,offset+4,offset+5],
				[offset+1,offset+2,offset+4],[offset+2,offset+3,offset+4]];
	}
}

struct ChunkModel
{
	GLfloat[3][] positions;
	GLfloat[2][] texCoords;
	GLint[3][] indices;

	vec_chunk loc;

	uint chunkVersion;
}





