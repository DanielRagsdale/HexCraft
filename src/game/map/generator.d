import std.stdio;

import map;

void GenerateMap(Map map)
{
	foreach(i; 0 .. 3)
	{
		Chunk* chunk = map.getChunkPointer(0, 0, i);

	foreach (x; 0 .. 16)
	{
	foreach (y; 0 .. 16)
	{
	foreach (z; 0 .. 16)
	{
		if(y<=(x / (i+1)))
		{
			chunk.hexes[x][y][z] = cast(ushort) (x*y + z) % 15 + 1;
		}
		if(x*y*z > 256)
		{
			chunk.hexes[x][y][z] = 0;
		}
		if((x-8)*(x-8)+y*y+(z-4)*(z-4) < 9)
		{
			chunk.hexes[x][y][z] = 0;
		}
	}
	}
	}
	}
}
