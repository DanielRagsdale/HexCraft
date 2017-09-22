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
		
		double radius = 0.15;
		
		vec_square[vec_block] collisions;

		foreach(delta; square_dn)
		{
			vec_block blockCoords = obj.transform.position + delta * radius;
			
			if(delta.y == 0)
				blockCoords = cast(vec_block)(obj.transform.position + delta * radius + vec_square(0, 0.1, 0));
			
			if(map.getBlock(blockCoords))
			{
				collisions[blockCoords] = delta;
			}
		}

		foreach(blockCoords, delta; collisions)
		{
			vec_square intr = cast(vec_square)blockCoords - obj.transform.position + vec_square(0,1,0);
			
			double intrSize = delta * intr;
			double collisionValue = intrSize - radius;

			if(delta.y == 0)
			{
				collisionValue = intrSize + 0.5 - radius;
			}

			if(collisionValue < 0.05 && collisionValue > -0.8)
			{
				vec_square pushOut = delta * collisionValue * 0.6;

				obj.transform.position += pushOut;
			}

			double limitedDot = max (0.0, delta*obj.transform.velocity); 
			vec_square pComponent = delta * limitedDot;
			
			obj.transform.velocity -= pComponent;
		}

		obj.transform.position += obj.transform.velocity * PHYSICS_DT;
	}	
}


