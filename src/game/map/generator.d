import std.stdio;

import map;

void GenerateMap(Map map)
{
	foreach(i; 0 .. 3)
	{
		Chunk* chunk = map.getChunkRef(0, 0, i);

	foreach (x; 1 .. 15)
	{
	foreach (y; 1 .. 15)
	{
	foreach (z; 1 .. 15)
	{
	if(y<=x)
		{
			chunk.hexes[x][y][z] = cast(ushort) (x*y + z) % 15 + 1;
		}
		if(x*y*z > 256)
		{
			chunk.hexes[x][y][z] = 0;
		}
	}
	}
	}
	}
}
