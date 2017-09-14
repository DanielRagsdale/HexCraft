import std.stdio;
import std.math;
import gl3n.linalg;

import logicalGameState;
import gameObject;
import map;

import IPhysical;

import util.values;
import util.mathM;
import util.coordVectors;

void TickPhysics(ref Map map)
{
	foreach(GameObject obj; objectGroups[IterableObjectTypes.PHYSICAL])
	{
		obj.transform.velocity += vec_square(0, -9.8, 0) * PHYSICS_DT;
		
		obj.transform.position += obj.transform.velocity * PHYSICS_DT;
		
		vec_square sqCoords = vec_square(obj.transform.x, obj.transform.y, obj.transform.z);
		if(map.getBlock(cast(vec_block)sqCoords))
		{
			obj.transform.y = ceil(obj.transform.y) + 0.01;
			obj.transform.vy = 0.0f;
		}

		//foreach(delta; hex_dn)
		{
			if(map.getBlock(cast(vec_block)obj.transform.position))
			{
				obj.transform.position -= obj.transform.velocity * PHYSICS_DT * 1.01;
				obj.transform.velocity *= 0;
			}
		}
	}	
}


