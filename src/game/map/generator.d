import std.stdio;
import std.math;

import map;

void GenerateMap(Map map)
{
	foreach(j; -2 .. 5)
	foreach(i; -2 .. 5)
	{
		Chunk chunk = Chunk();

	foreach (x; 0 .. 16)
	{
	foreach (y; 0 .. 16)
	{
	foreach (z; 0 .. 16)
	{
		if(y<=(x / (i+3)))
		{
			chunk.hexes[x][y][z] = cast(ushort) (x*y + z) % 3 + 1;
		}
		if(x*y*z >= abs(256 * j))
		{
			//chunk.hexes[x][y][z] = 1;
		}
		if((x-8)*(x-8)+y*y+(z-4)*(z-4) < 9)
		{
			chunk.hexes[x][y][z] = 0;
		}
	}
	}
	}

	map.setChunk(chunk, j,0,i);
	}
	
	foreach(j; -2 .. 5)
	foreach(i; -2 .. 5)
	{
		Chunk chunk = Chunk();

	foreach (x; 0 .. 16)
	{
	foreach (y; 0 .. 16)
	{
	foreach (z; 0 .. 16)
	{
		if(y == 15)
		{
			chunk.hexes[x][y][z] = 3;
		}
		else if (y > 8) 
		{
			chunk.hexes[x][y][z] = 2;
		}
		else
		{
			chunk.hexes[x][y][z] = 1;
		}
	}
	}
	}

	map.setChunk(chunk, j,-1,i);
	}
}
