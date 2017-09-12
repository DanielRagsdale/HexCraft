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
			
			foreach (x; 1 .. 15)
			{
			foreach (y; 1 .. 15)
			{
			foreach (z; 1 .. 15)
			{

				int texNum = chunk[x][y][z];
				if(!texNum)
				{
					continue;
				}

				//Top
				if(!chunk[x][y+1][z])
				{
					int offset = cast(int)model.positions.length;

					foreach(i; 0..6)
					{
						vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
						model.positions ~= [temp.x, temp.y, temp.z];
					}
					model.texCoords ~= [[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f]];

					model.indices ~= [[offset+0,offset+5,offset+1],[offset+1,offset+5,offset+4],[offset+1,offset+4,offset+2],[offset+2,offset+4,offset+3]];
				}					
				//Bottom
				if(!chunk[x][y-1][z])
				{
					int offset = cast(int)model.positions.length;

					foreach(i; 6..12)
					{
						vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
						model.positions ~= [temp.x, temp.y, temp.z];
					}
					model.texCoords ~= [[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f],[0.0f, 0.0f]];

					model.indices ~= [[offset+0,offset+1,offset+5],[offset+1,offset+4,offset+5],[offset+1,offset+2,offset+4],[offset+2,offset+3,offset+4]];
				}					
				//Side 0
				if(!chunk[x-1][y][z])
				{
					int offset = cast(int)model.positions.length;

					foreach(i; [0,1,6,7])
					{
						vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
						model.positions ~= [temp.x, temp.y, temp.z];
					}
					model.texCoords ~= [[(16*texNum)/512f, 0.0f],[(16*texNum+8)/512f, 0.0f],[(16*texNum)/512f, 16f/512f],[(16*texNum+8)/512f, 16f/512f]];

					model.indices ~= [[offset+0,offset+1,offset+3],[offset+0,offset+3,offset+2]];
				}
				//Side 1
				if(!chunk[x][y][z-1])
				{
					int offset = cast(int)model.positions.length;

					foreach(i; [1,2,7,8])
					{
						vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
						model.positions ~= [temp.x, temp.y, temp.z];
					}
					model.texCoords ~= [[(16*texNum)/512f, 0.0f],[(16*texNum+8)/512f, 0.0f],[(16*texNum)/512f, 16f/512f],[(16*texNum+8)/512f, 16f/512f]];

					model.indices ~= [[offset+0,offset+1,offset+3],[offset+0,offset+3,offset+2]];
				}
				//Side 2
				if(!chunk[x+1][y][z-1])
				{
					int offset = cast(int)model.positions.length;

					foreach(i; [2,3,8,9])
					{
						vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
						model.positions ~= [temp.x, temp.y, temp.z];
					}
					model.texCoords ~= [[(16*texNum)/512f, 0.0f],[(16*texNum+8)/512f, 0.0f],[(16*texNum)/512f, 16f/512f],[(16*texNum+8)/512f, 16f/512f]];

					model.indices ~= [[offset+0,offset+1,offset+3],[offset+0,offset+3,offset+2]];
				}
				//Side 3
				if(!chunk[x+1][y][z])
				{
					int offset = cast(int)model.positions.length;

					foreach(i; [3,4,9,10])
					{
						vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
						model.positions ~= [temp.x, temp.y, temp.z];
					}
					model.texCoords ~= [[(16*texNum)/512f, 0.0f],[(16*texNum+8)/512f, 0.0f],[(16*texNum)/512f, 16f/512f],[(16*texNum+8)/512f, 16f/512f]];

					model.indices ~= [[offset+0,offset+1,offset+3],[offset+0,offset+3,offset+2]];
				}
				//Side 4
				if(!chunk[x][y][z+1])
				{
					int offset = cast(int)model.positions.length;

					foreach(i; [4,5,10,11])
					{
						vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
						model.positions ~= [temp.x, temp.y, temp.z];
					}
					model.texCoords ~= [[(16*texNum)/512f, 0.0f],[(16*texNum+8)/512f, 0.0f],[(16*texNum)/512f, 16f/512f],[(16*texNum+8)/512f, 16f/512f]];

					model.indices ~= [[offset+0,offset+1,offset+3],[offset+0,offset+3,offset+2]];
				}
				//Side 5
				if(!chunk[x-1][y][z+1])
				{
					int offset = cast(int)model.positions.length;

					foreach(i; [5,0,11,6])
					{
						vec3 temp = (hexVertices[i] + x*dx + y*dy + z*dz);
						model.positions ~= [temp.x, temp.y, temp.z];
					}
					model.texCoords ~= [[(16*texNum)/512f, 0.0f],[(16*texNum+8)/512f, 0.0f],[(16*texNum)/512f, 16f/512f],[(16*texNum+8)/512f, 16f/512f]]; 
					model.indices ~= [[offset+0,offset+1,offset+3],[offset+0,offset+3,offset+2]];
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
}

struct ChunkModel
{
	GLfloat[3][] positions;
	GLfloat[2][] texCoords;
	GLint[3][] indices;

	coordinate loc;
}





