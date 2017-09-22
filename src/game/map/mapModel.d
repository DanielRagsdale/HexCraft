import std.stdio;

import derelict.opengl3.gl;
import gl3n.linalg;

import util.values;
import util.coordVectors;

import hexes;

import modelBuilder;
import modelBuilderHex;

import map;


ModelBuilder[] ModelBuilders;

class MapModel
{
	Map mWorldMap;

	public ChunkModel[vec_chunk] cm;

	this(Map worldMap)
	{
		mWorldMap = worldMap;
		ModelBuilders ~= new ModelBuilderHex(worldMap);
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

				ModelBuilders[0].AppendModel(c, x, y, z, model);

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
}

struct ChunkModel
{
	GLfloat[3][] positions;
	GLfloat[2][] texCoords;
	GLint[3][] indices;

	vec_chunk loc;

	uint chunkVersion;
}





