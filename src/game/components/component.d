import std.stdio;

import gameObject;

/**
* A component that can be added to a GameObject
* Unlike in many engines, components are not necessary for a game object to exist.
*/
abstract class Component
{
    /**
    * The unique ID of this component
    */
    ulong ID;

	/**
	* The GameObject that houses this component
	*/
	GameObject gameObject;

	/**
	* The transform object of the parent GameObject
	*/
	alias get_trans!() transform;

    private Transform* transPtr;

    /**
    * Called to instantiate this component and configure initial values
    */
	public void init(GameObject go, uint localID)
	{
        gameObject = go;
        transPtr = &gameObject.transform;

        ID = (go.GetID << 16) + localID;
	}

    /**
    * Called once per game tick
    */
	public void Update(){}

	public ulong GetID()
	{
	    return ID;
	}

    @safe pure nothrow:
    private @property ref get_trans()()
    {
        return *transPtr;
    }
}