import std.typecons;
import std.stdio;
import std.math;
import std.container.slist;

import util.values;
import util.coordinates;

class Map
{
	Chunk[crd_chunk] chunks; 

	auto outdatedChunks = SList!crd_chunk();
	
	void setChunk(ref Chunk c, int x, int y, int z)
	{
		setChunk(c, crd_chunk(x,y,z));
	}
	void setChunk(ref Chunk c, crd_chunk coord)
	{
		chunks[coord] = c;
		
		foreach(delta; chunk_dn)
		{	
			crd_chunk update = coord + delta;	
			if(chunkExists(update))
			{
				outdatedChunks.insert(update);
			}
		}

		outdatedChunks.insert(coord);
	}	

	int getBlock(crd_block c)
	{
		return getBlock(c.x, c.y, c.z);
	}

	int getBlock(int x, int y, int z)
	{
		int cX = cast(int)floor(x / 16.0);
		int cY = cast(int)floor(y / 16.0);
		int cZ = cast(int)floor(z / 16.0);
		
		Chunk* test = crd_chunk(cX,cY,cZ) in chunks;
		if(test is null)
		{
			return 0;
		}

		return test.hexes[x - cX*CHUNK_SIZE][y - cY*CHUNK_SIZE][z - cZ*CHUNK_SIZE];		
	}

	int getBlockRelative(crd_chunk c, int x, int y, int z)
	{
		return getBlock(x + c.x*CHUNK_SIZE, y + c.y*CHUNK_SIZE, z + c.z*CHUNK_SIZE);
	}

	bool chunkExists(crd_chunk c)
	{
		Chunk* test = c in chunks;
		return test != null;
	}

	Chunk getChunkVal(crd_chunk c)
	{
		return chunks[c];
	}
	
	ref Chunk getChunkRef(crd_chunk c)
	{
		Chunk* test = c in chunks;
		if(test is null)
		{
			chunks[c] = Chunk();
		}
		return chunks[c];
	}

	Chunk* getChunkPointer(crd_chunk c)
	{
		Chunk* test = c in chunks;
		if(test is null)
		{
			chunks[c] = Chunk();
		}
		return &chunks[c];
	}
}

struct Chunk
{
	ushort[16][16][16] hexes;
}
