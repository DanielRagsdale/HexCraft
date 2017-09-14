import std.stdio;
import std.math;
import gl3n.linalg;

import logicalGameState;
import gameObject;
import map;

import IPhysical;

import util.values;
import util.mathM;
import util.coordinates;

void TickPhysics(ref Map map)
{
	foreach(GameObject obj; objectGroups[IterableObjectTypes.PHYSICAL])
	{
		obj.transform.velocity += PHYSICS_DT * vec3(0, -9.8, 0);
		obj.transform.position += PHYSICS_DT * obj.transform.velocity;
		
		crd_square sqCoords = crd_square(obj.transform.x, obj.transform.y, obj.transform.z);
		if(map.getBlock(cast(crd_block)sqCoords))
		{
			obj.transform.y = ceil(obj.transform.y) + 0.01;
			obj.transform.vy = 0.0f;
		}

		//foreach(delta; hex_dn)
		{
			vec3 checkCoord = toHex(obj.transform.position);
			vec3 roundedCheckCoord = vec3(round(checkCoord.x), floor(checkCoord.y), round(checkCoord.z));
			if(map.getBlock(cast(int)roundedCheckCoord.x, cast(int)roundedCheckCoord.y, cast(int)roundedCheckCoord.z))
			{
				obj.transform.position -= PHYSICS_DT * 1.01 * obj.transform.velocity;
				obj.transform.velocity *= 0;
			}
		}
	}	
}


