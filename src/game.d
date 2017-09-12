/**
* The Start function is launched by app.d and then handles the main
* game loop.
*/

import std.stdio;
import std.concurrency;
import std.conv;
import std.algorithm.sorting;

import util.time;
import util.input;

import core.time;
import core.thread;

import gl3n.linalg;

import IRenderable;

import renderer;
import display;
import logicalGameState;
import renderObjectData;
import renderHexData;
import gameObject;

import player;

import map;
import mapModel;
import generator;

import values;

shared RenderMessage rMessage;

Tid LogicThreadTid;
Tid PhysicsThreadTid;

/**
* Prepares the game to be started.
* Begins the game loop after everything has been configured.
*/
void Start()
{
    CreateDisplay(1680, 1050, "Aurora");

    rMessage = new shared RenderMessage();

    LogicThreadTid = spawn(&LogicThread, thisTid(), rMessage);
    PhysicsThreadTid = spawn(&PhysicsThread, thisTid(), rMessage);

	RenderInputLoop(rMessage);
}

/**
* The game rendering loop. Renders the game data that is pushed from the helper threads.
*
* Runs on Thread 0
*/
void RenderInputLoop(shared(RenderMessage) rMessage)
{
	double t = 0.0;

    double time0 = CurrentTime();
    double accumulator = 0.0;

    while(!InputStates.shouldQuit)
    {
        double time1 = CurrentTime();
        double frameTime = time1 - time0;
        time0 = time1;

        accumulator += frameTime;

        //Constant framerate game logic and physics ticks.
        while(accumulator >= INPUT_DT)
        {
        	PollSDLEvents();
			accumulator -= INPUT_DT;
        }
		
		if(rMessage.Ready())
		{
			rMessage.Render();
		}
	}
}

Map worldMap; 

MapModel worldMapModel; 

/**
* Handles everything that is not input or rendering related.
* Uses an additional thread pool to further offload work.
*
* Runs on Thread 1
*/
void LogicThread(Tid parentTid, shared(RenderMessage) rMessage)
{
	/*
		Begin First Scene Init Script:
		------------------------
	*/

    RegisterGameObject(new Player(Transform(vec3(0.0, 0.0, 0.0))));
	
	worldMap = new Map();
	GenerateMap(worldMap);

	worldMapModel = new MapModel(worldMap);	

	/*
		End First Scene Init Script:
		------------------------
	*/

	double t = 0.0;

    double time0 = CurrentTime();
    double accumulator = 0.0;

	double lastFrameTime;

    while(!InputStates.shouldQuit)
    {
        double time1 = CurrentTime();
        double frameTime = time1 - time0;
        time0 = time1;

        accumulator += frameTime;

        //Constant framerate game logic and physics ticks.
        while(accumulator >= PHYSICS_DT)
        {
			Update();
			accumulator -= PHYSICS_DT;
			lastFrameTime = CurrentTime();
        }
       	
	   	/**	
		 * GLVM Render Extraction
		 **/

		//Hexes
		worldMapModel.RefreshChunks();

		//Objects	
		auto dataArr = ExtractRenderObjects(CurrentTime() - lastFrameTime);
		sort(cast(RenderData[])dataArr);
		
        rMessage.SetData([[short(1)]], cast(immutable)dataArr);
		rMessage.cm = cast(shared) worldMapModel.cm;

		Thread.sleep( dur!("msecs")(1));  
    }
}

/**
* Handles various physics interactions in the world
*
* Runs on Thread 2
*/
void PhysicsThread(Tid parentTid, shared(RenderMessage) rMessage)
{
}

/**
* Data extractions from the LogicalGameState
*/
immutable (immutable RenderData)[] ExtractRenderObjects(double tickOffset)
{
	RenderData[] rd;

	foreach(ulong i, shared GameObject renderableObj; objectGroups[IterableObjectTypes.RENDERABLE])
	{
		rd ~= (cast(IRenderable)renderableObj).Render(tickOffset);
	}

	return cast(immutable) rd;
}

/**
* The shared class that handles communication of render data between threads.
*/
class RenderMessage
{
	private shared immutable (short)[][] mHexData;
	private shared immutable (RenderData)[] mObjectData;

	public shared ChunkModel cm;

	/**
	* Set the data that is going to be rendered the next time the rendering loop executes.
	*/
	public shared void SetData(immutable(short)[][] hexData, immutable(RenderData)[] objectData)
	{
		mHexData = cast(shared)hexData;
		mObjectData = cast(shared)objectData;
	}
	
	/**
	* Use all of the RenderData objects that were exracted to render the scene
	*/
	public shared void Render()
	{
		disp.Clear(0.1f, 0.1f, 0.1f, 1.0f);
		
		//Render Objects
		foreach(immutable RenderData rd; mObjectData)
		{
			renderObjectData.DrawFunctions[rd.RenderObjectID](rd.Data);
		}
		
		//Render Map

		DrawRegion(cast(ChunkModel)cm, 0, 0, 0);

		renderer.Render();
	}

	public shared bool Ready()
	{
		return true;
	}
}
