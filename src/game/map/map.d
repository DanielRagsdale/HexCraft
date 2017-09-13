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
	
	void setChunk(ref Chunk c, int x, int y, int z)
	{
		setChunk(c, coordinate(x,y,z));
	}
	void setChunk(ref Chunk c, coordinate coord)
	{
		chunks[coord] = c;
		
		coordinate below = coordinate(coord[0], coord[1] - 1, coord[2]);	
		if(chunkExists(below))
		{
			outdatedChunks.insert(below);
		}

		outdatedChunks.insert(coord);
	}	

	int getBlock(int x, int y, int z)
	{
		int cX = cast(int)floor(x / 16.0);
		int cY = cast(int)floor(y / 16.0);
		int cZ = cast(int)floor(z / 16.0);
		
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

	bool chunkExists(coordinate c)
	{
		Chunk* test = c in chunks;
		return test != null;
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
