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
		
		foreach(delta; square_dn)
		{
			vec_block blockCoords = obj.transform.position + delta * (cast(IPhysical)obj).GetRadius();
			
			vec_square intr = cast(vec_square)blockCoords - obj.transform.position - vec_square(0,1,0);

			if(map.getBlock(blockCoords))
			{
				if(map.getBlock(cast(vec_block)(obj.transform.position + delta * (cast(IPhysical)obj).GetRadius() * 0.9)))
				{
					vec_square pushOut = delta * (delta*intr) * 0.1 * (cast(IPhysical)obj).GetRadius();

					obj.transform.position -= pushOut;
				}

				double limitedDot = max (0.0, delta*obj.transform.velocity); 
				vec_square pComponent = delta * limitedDot;
				
				obj.transform.velocity -= pComponent;
			}
		}
		obj.transform.position += obj.transform.velocity * PHYSICS_DT;
	}	
}


