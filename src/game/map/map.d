import std.typecons;
import std.container.slist;

alias coordinate = Tuple!(int, int, int);

class Map
{
	ushort[16][16][16] hexes; 

	auto outdatedChunks = SList!coordinate();
	
	this()
	{
		outdatedChunks.insert(coordinate(0, 0, 0));
	}

	ushort[16][16][16] getChunk(coordinate c)
	{
		return hexes;
	}
}
