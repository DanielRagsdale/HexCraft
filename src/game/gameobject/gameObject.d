import renderObjectData;
import gl3n.linalg;
import std.stdio;
import core.vararg;
import transform;

import map;

/**
* Class representing a GameObject which exists in the scene
*/
abstract class GameObject
{
    /**
    * The unique ID of this GameObject
    */
    public uint ID;

    /**
    * The transform object associated with this GameObject
    */
    public Transform transform;

    /**
    * Create a GameObject with given transform and components
    */
    public this(Transform trans)
    {
        transform = trans;
    }

    /**
    * Called when this GameObject is added to the scene
    */
    public void Register(uint ID)
    {
        this.ID = ID;
    }

	public abstract void Update(ref Map map);
    
	/**
    * Returns the transform mat4 associated with this GameObject.
    */
    public mat4 GetTransformMatrix()
    {
        mat4 transMatrix = mat4.identity();

        transMatrix.translate(transform.x, transform.y, transform.z);
        transMatrix.scale(transform.sx, transform.sy, transform.sz);

        //transMatrix.Rotate();


        mat4 mat = transform.rotation.to_matrix!(4, 4);

        return mat4.identity();
    }

    public ulong GetID()
    {
        return ID;
    }

    public Transform GetTransform()
    {
        return transform;
    }
}

