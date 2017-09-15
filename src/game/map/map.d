import std.typecons;
import std.stdio;
import std.math;

import util.values;
import util.coordVectors;

class Map
{
	Chunk[vec_chunk] chunks; 

	//auto outdatedChunks = SList!vec_chunk();
	bool[vec_chunk] outdatedChunks;
	
	void setChunk(ref Chunk c, int x, int y, int z)
	{
		setChunk(c, vec_chunk(x,y,z));
	}
	void setChunk(ref Chunk c, vec_chunk coord)
	{
		chunks[coord] = c;
		
		foreach(delta; chunk_dn)
		{	
			vec_chunk update = coord + delta;	
			if(chunkExists(update))
			{
				outdatedChunks[update] = true;
			}
		}

		outdatedChunks[coord] = true;
	}	
	
	void setBlock(vec_block c, ushort block)
	{
		int cX = cast(int)floor(c.x / 16.0);
		int cY = cast(int)floor(c.y / 16.0);
		int cZ = cast(int)floor(c.z / 16.0);
		
		Chunk* test = vec_chunk(cX,cY,cZ) in chunks;
		if(test is null)
		{
			return;
		}

		test.hexes[c.x - cX*CHUNK_SIZE][c.y - cY*CHUNK_SIZE][c.z - cZ*CHUNK_SIZE] = block;		

		outdatedChunks[cast(vec_chunk)c] = true;

		foreach(delta; block_dn)
		{	
			vec_chunk update = cast(vec_chunk)(c + delta);	
			if(chunkExists(update))
			{
				outdatedChunks[update] = true;
			}
		}
	}

	ushort getBlock(vec_block c)
	{
		return getBlock(c.x, c.y, c.z);
	}

	ushort getBlock(int x, int y, int z)
	{
		int cX = cast(int)floor(x / 16.0);
		int cY = cast(int)floor(y / 16.0);
		int cZ = cast(int)floor(z / 16.0);
		
		Chunk* test = vec_chunk(cX,cY,cZ) in chunks;
		if(test is null)
		{
			return 0;
		}

		return test.hexes[x - cX*CHUNK_SIZE][y - cY*CHUNK_SIZE][z - cZ*CHUNK_SIZE];		
	}

	ushort getBlockRelative(vec_chunk c, int x, int y, int z)
	{
		return getBlock(x + c.x*CHUNK_SIZE, y + c.y*CHUNK_SIZE, z + c.z*CHUNK_SIZE);
	}

	bool chunkExists(vec_chunk c)
	{
		Chunk* test = c in chunks;
		return test != null;
	}

	Chunk getChunkVal(vec_chunk c)
	{
		return chunks[c];
	}
	
	ref Chunk getChunkRef(vec_chunk c)
	{
		Chunk* test = c in chunks;
		if(test is null)
		{
			chunks[c] = Chunk();
		}
		return chunks[c];
	}

	Chunk* getChunkPointer(vec_chunk c)
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
