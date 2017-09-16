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
import core.atomic;

import gl3n.linalg;

import renderer;
import display;
import logicalGameState;
import physicsEngine;
import renderObjectData;
import renderHexData;
import gameObject;
import transform;

import player;

import map;
import mapModel;
import generator;

import util.values;
import util.coordVectors;

shared RenderMessage rMessage;

Tid LogicThreadTid;

/**
* Prepares the game to be started.
* Begins the game loop after everything has been configured.
*/
void Start()
{
    CreateDisplay(1280, 720, "Aurora");

    rMessage = new shared RenderMessage();

    LogicThreadTid = spawn(&LogicThread, thisTid(), rMessage);

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

    while(!ShouldQuit)
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

    RegisterGameObject(new Player(Transform(vec_square(0.0, 0.0, 0.0))));
	
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

    while(!ShouldQuit)
    {
        double time1 = CurrentTime();
        double frameTime = time1 - time0;
        time0 = time1;

        accumulator += frameTime;

        //Constant framerate game logic and physics ticks.
        while(accumulator >= PHYSICS_DT)
        {
			UpdateInput();

			Update(worldMap);
			TickPhysics(worldMap);

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
		
        rMessage.SetData(worldMapModel.cm.values, dataArr); 
		Thread.sleep( dur!("msecs")(1));  
    }
}

/**
* Data extractions from the LogicalGameState
*/
RenderData[] ExtractRenderObjects(double tickOffset)
{
	RenderData[] rd;

	//foreach(GameObject renderableObj; objectGroups[IterableObjectTypes.RENDERABLE])

	foreach(RenderData delegate(double to) func; renderFunctions)
	{
		RenderData data = func(tickOffset);
		if(data.RenderObjectID >= 0)
		{
			rd ~= func(tickOffset);
		}
	}

	return rd;
}

/**
* The shared class that handles communication of render data between threads.
*/
class RenderMessage
{
	private shared (ChunkModel)[] mHexData;
	private shared (RenderData)[] mObjectData;

	private shared bool hasNewData = false;

	/**
	* Set the data that is going to be rendered the next time the rendering loop executes.
	*/
	public shared void SetData(ChunkModel[] hexData, RenderData[] objectData)
	{
		mHexData.atomicStore(cast(shared)hexData);
		mObjectData.atomicStore(cast(shared)objectData);

		hasNewData.atomicStore(true);
	}
	
	/**
	* Use all of the RenderData objects that were exracted to render the scene
	*/
	public shared void Render()
	{
		disp.Clear(0.5273f, 0.8047f, 0.9766f, 1.0f);
		
		//Render Objects
		foreach(shared RenderData rd; mObjectData)
		{
			renderObjectData.DrawFunctions[rd.RenderObjectID](cast(byte[])rd.Data);
		}
		
		//Render Map
		foreach(shared ChunkModel cm; mHexData)
		{
			DrawRegion(cast(ChunkModel)cm, cast(vec_chunk)cm.loc);
		}

		renderer.Render();

		hasNewData.atomicStore(false);
	}

	public shared bool Ready()
	{
		return hasNewData || true;
	}
}
