import std.stdio;

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
public GameObject[] gameObjects;

/**
* Multidimensional array mapping IterableComponentTypes to an array of Components that belong within that group
*/
public Component[ulong][IterableComponentTypes] componentGroups;

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
* Adds a component to a given group of IterableComponentTypes
*/
public void AddComponentToIterable(Component comp, IterableComponentTypes type)
{
	componentGroups[type][comp.GetID] = comp;
}

/**
* The global update function.
*/
public void Update()
{
	foreach(GameObject go; gameObjects)
	{
		go.Update();
	}
}