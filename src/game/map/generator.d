import map;

void GenerateMap(shared Map map)
{
	foreach (x; 0 .. 16)
	{
	foreach (y; 0 .. 16)
	{
	foreach (z; 0 .. 16)
	{
		if(x*y*z < 256)
		{
			map.hexes[x][y][z] = cast(ushort) (x*y + z) % 9;
		}
	}
	}
	}
}
