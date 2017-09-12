import std.stdio;

import gameObject;

/**
* Stores the information about the game state.
* Information is then extracted and sent to the rendering thread
*/
enum IterableObjectTypes
{
	RENDERABLE, COLLIDABLE, END
}

/**
* Array of all of the GameObjects that exist within the scene
*/
public GameObject[] gameObjects;

/**
* Multidimensional array mapping IterableObjectTypes to an array of GameObject that belong within that group
*/
public GameObject[ulong][IterableObjectTypes] objectGroups;

private uint gameObjectIDCounter = 0;

/**
* Add a game object that does not have its render function called.
*/
public ulong RegisterGameObject(GameObject gameObject)
{
	gameObjectIDCounter++;

	gameObject.Register(gameObjectIDCounter);

	gameObjects ~= gameObject;

	return gameObjectIDCounter;
}

/**
* Adds a GameObject to a given group of IterableObjectTypes
*/
public void AddObjectToIterable(GameObject go, IterableObjectTypes type)
{
	objectGroups[type][go.GetID] = go;
}

/**
* The global update function.
*/
public void Update()
{
	foreach(go; gameObjects)
	{
		go.Update();
	}
}
