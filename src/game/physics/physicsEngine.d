import std.stdio;
import std.math;
import gl3n.linalg;

import logicalGameState;
import gameObject;
import map;

import IPhysical;

import util.values;
import util.mathM;

void TickPhysics(ref Map map)
{
	foreach(GameObject obj; objectGroups[IterableObjectTypes.PHYSICAL])
	{
		obj.transform.velocity += PHYSICS_DT * vec3(0, -9.8, 0);
		obj.transform.position += PHYSICS_DT * obj.transform.velocity;
		
		vec3 hexCoord = toHex(obj.transform.position);
		if(map.getBlock(cast(int)round(hexCoord.x), cast(int)floor(hexCoord.y), cast(int)round(hexCoord.z)))
		{
			obj.transform.position.y = ceil(obj.transform.position.y) + 0.01;
			obj.transform.velocity.y = 0.0f;
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


