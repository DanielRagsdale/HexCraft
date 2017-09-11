import std.stdio;
import core.atomic;

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
public shared GameObject[] gameObjects;

/**
* Multidimensional array mapping IterableObjectTypes to an array of GameObject that belong within that group
*/
public shared GameObject[ulong][IterableObjectTypes] objectGroups;

private shared uint gameObjectIDCounter = 0;

/**
* Add a game object that does not have its render function called.
*/
public ulong RegisterGameObject(GameObject gameObject)
{
	atomicOp!"+="(gameObjectIDCounter, 1);

	gameObject.Register(gameObjectIDCounter);

	gameObjects ~= cast(shared GameObject) gameObject;

	return gameObjectIDCounter;
}

/**
* Adds a GameObject to a given group of IterableObjectTypes
*/
public void AddObjectToIterable(GameObject go, IterableObjectTypes type)
{
	objectGroups[type][go.GetID] = cast(shared GameObject) go;
}

/**
* The global update function.
*/
public void Update()
{
	foreach(shared GameObject go; gameObjects)
	{
		(cast(GameObject)go).Update();
	}
}
