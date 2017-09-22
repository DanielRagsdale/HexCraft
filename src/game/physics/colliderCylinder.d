import util.coordVectors;

import map;

class ColliderCylinder
{
	vec_square base;
	double radius;
	double height;	

	this(vec_square base, double radius, double height)
	{
		this.base = base;
		this.radius = radius;
		this.height = height;
	}

	public void HandleCollisions(ref Map map)
	{

	}

	private void findPotentialCollisions(ref Map map)
	{

	}
}
