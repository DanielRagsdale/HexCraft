import std.typecons;
import std.container.slist;

alias coordinate = Tuple!(int, int, int);

class Map
{
	coordinate[] outdatedChunks;

	shared ushort[16][16][16] hexes; 

	shared this()
	{
		outdatedChunks ~= coordinate(0, 0, 0);
	}
}
