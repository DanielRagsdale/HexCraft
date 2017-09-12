import std.typecons;
import std.stdio;
import std.container.slist;

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

	Chunk getChunkVal(int x, int y, int z)
	{
		return chunks[coordinate(x,y,z)];
	}

	Chunk getChunkVal(coordinate c)
	{
		return chunks[c];
	}
	
	Chunk* getChunkRef(int x, int y, int z)
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
