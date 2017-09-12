import map;

void GenerateMap(Map map)
{
	foreach (x; 1 .. 15)
	{
	foreach (y; 1 .. 15)
	{
	foreach (z; 1 .. 15)
	{
		if(y==x)
		{
			//map.hexes[x][y][z] = cast(ushort) (x*y + z) % 9;
			map.hexes[x][y][z] = 1;
		}
		if(x*y*z > 256)
		{
			map.hexes[x][y][z] = 0;
		}
	}
	}
	}
}
