
import map;

class MapModel
{
	shared Map mWorldMap;

	shared this(shared Map worldMap)
	{
		mWorldMap = worldMap;
	}	

	shared bool RefreshChunks()
	{
		return false;
	}
}
