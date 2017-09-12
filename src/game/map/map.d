import std.typecons;
import std.stdio;
import std.math;
import std.container.slist;

import util.values;

alias coordinate = Tuple!(int, int, int);

class Map
{
	Chunk[coordinate] chunks; 

	auto outdatedChunks = SList!coordinate();
	
	this()
	{
		outdatedChunks.insert(coordinate(0, 0, 0));
		outdatedChunks.insert(coordinate(0, 0, 1));
		outdatedChunks.insert(coordinate(0, 0, 2));
	}
	
	int getBlock(int x, int y, int z)
	{
		int cX = cast(int)floor(cast(float)x / 16);
		int cY = cast(int)floor(cast(float)y / 16);
		int cZ = cast(int)floor(cast(float)z / 16);
		
		Chunk* test = coordinate(cX,cY,cZ) in chunks;
		if(test is null)
		{
			return 0;
		}

		return test.hexes[x - cX*CHUNK_SIZE][y - cY*CHUNK_SIZE][z - cZ*CHUNK_SIZE];		
	}

	int getBlockRelative(coordinate c, int x, int y, int z)
	{
		return getBlock(x + c[0]*CHUNK_SIZE, y + c[1]*CHUNK_SIZE, z + c[2]*CHUNK_SIZE);
	}

	Chunk getChunkVal(int x, int y, int z)
	{
		return chunks[coordinate(x,y,z)];
	}

	Chunk getChunkVal(coordinate c)
	{
		return chunks[c];
	}
	
	ref Chunk getChunkRef(coordinate c)
	{
		Chunk* test = c in chunks;
		if(test is null)
		{
			chunks[c] = Chunk();
		}
		return chunks[c];
	}

	Chunk* getChunkPointer(int x, int y, int z)
	{
		Chunk* test = coordinate(x,y,z) in chunks;
		if(test is null)
		{
			chunks[coordinate(x,y,z)] = Chunk();
		}
		return &chunks[coordinate(x,y,z)];
	}
}

struct Chunk
{
	ushort[16][16][16] hexes;
}
