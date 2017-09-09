import std.stdio;
import core.atomic;

import gameObject;
import component;

/**
* Stores the information about the game state.
* Information is then extracted and sent to the rendering thread
*/
enum IterableComponentTypes
{
	RENDERABLE, COLLIDABLE, END
}

/**
* Array of all of the GameObjects that exist within the scene
*/
public shared GameObject[] gameObjects;

/**
* Multidimensional array mapping IterableComponentTypes to an array of Components that belong within that group
*/
public shared Component[ulong][IterableComponentTypes] componentGroups;

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
* Adds a component to a given group of IterableComponentTypes
*/
public void AddComponentToIterable(Component comp, IterableComponentTypes type)
{
	componentGroups[type][comp.GetID] = cast(shared Component) comp;
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
