module util.input;

import core.atomic;

import derelict.sdl2.sdl;

import std.stdio;
import game;
import renderer;

public shared bool ShouldQuit;


void PollSDLEvents()
{
	SDL_PumpEvents();
}

void UpdateInput()
{
	const Uint8* keystates = SDL_GetKeyboardState(null);

    InputStates.mouseXRel = 0;
    InputStates.mouseYRel = 0;

    if(keystates[SDL_SCANCODE_A]) {
   		InputStates.keyA++;
	} else {
   		InputStates.keyA = 0;
	}
    if(keystates[SDL_SCANCODE_D]) {
    	InputStates.keyD++;
	} else {
    	InputStates.keyD = 0;
	}
    if(keystates[SDL_SCANCODE_E]) {
    	InputStates.keyE++;
	} else {
    	InputStates.keyE = 0;
	}
    if(keystates[SDL_SCANCODE_S]) {
    	InputStates.keyS++;
	} else {
    	InputStates.keyS = 0;
	}
    if(keystates[SDL_SCANCODE_Q]) {
    	InputStates.keyQ++;
	} else {
    	InputStates.keyQ = 0;
	}
    if(keystates[SDL_SCANCODE_W]) {
    	InputStates.keyW++;
	} else {
    	InputStates.keyW = 0;
	}
    if(keystates[SDL_SCANCODE_Z]) {
    	InputStates.keyZ++;
	} else {
    	InputStates.keyZ = 0;
	}
    if(keystates[SDL_SCANCODE_0]) {
    	InputStates.key0++;
	} else {
    	InputStates.key0 = 0;
	}
    if(keystates[SDL_SCANCODE_1]) {
    	InputStates.key1++;
	} else {
    	InputStates.key1 = 0;
	}
    if(keystates[SDL_SCANCODE_2]) {
    	InputStates.key2++;
	} else {
    	InputStates.key2 = 0;
	}
    if(keystates[SDL_SCANCODE_3]) {
    	InputStates.key3++;
	} else {
    	InputStates.key3 = 0;
	}
    if(keystates[SDL_SCANCODE_4]) {
    	InputStates.key4++;
	} else {
    	InputStates.key4 = 0;
	}
    if(keystates[SDL_SCANCODE_5]) {
    	InputStates.key5++;
	} else {
    	InputStates.key5 = 0;
	}
    if(keystates[SDL_SCANCODE_6]) {
    	InputStates.key6++;
	} else {
    	InputStates.key6 = 0;
	}
    if(keystates[SDL_SCANCODE_7]) {
    	InputStates.key7++;
	} else {
    	InputStates.key7 = 0;
	}
    if(keystates[SDL_SCANCODE_8]) {
    	InputStates.key8++;
	} else {
    	InputStates.key8 = 0;
	}
    if(keystates[SDL_SCANCODE_9]) {
    	InputStates.key9++;
	} else {
    	InputStates.key9 = 0;
	}
    if(keystates[SDL_SCANCODE_SPACE]) {
    	InputStates.keySPACE++;
	} else {
    	InputStates.keySPACE = 0;
	}
    if(keystates[SDL_SCANCODE_LEFT]) {
    	InputStates.keyLEFT++;
	} else {
    	InputStates.keyLEFT = 0;
	}
    if(keystates[SDL_SCANCODE_RIGHT]) {
    	InputStates.keyRIGHT++;
	} else {
    	InputStates.keyRIGHT = 0;
	}
    if(keystates[SDL_SCANCODE_UP]) {
    	InputStates.keyUP++;
	} else {
    	InputStates.keyUP = 0;
	}
    if(keystates[SDL_SCANCODE_DOWN]) {
    	InputStates.keyDOWN++;
	} else {
    	InputStates.keyDOWN = 0;
	}
	
	//Mouse Button Stuff
	
	uint buttonMask = SDL_GetMouseState(null, null);
	if(buttonMask & SDL_BUTTON(SDL_BUTTON_LEFT)) {
		InputStates.mouseLEFT++;
	} else {
		InputStates.mouseLEFT = 0;
	}
	if(buttonMask & SDL_BUTTON(SDL_BUTTON_RIGHT)) {
		InputStates.mouseRIGHT++;
	} else {
		InputStates.mouseRIGHT = 0;
	}

	/*
		else if(event.type == SDL_MOUSEBUTTONDOWN)
		{
			switch(event.button.button)
			{
				case SDL_BUTTON_LEFT:
					break;
				case SDL_BUTTON_RIGHT:
					InputStates.mouseRIGHT++;
					break;
				default:
					break;
			}
		}
		else if(event.type == SDL_MOUSEBUTTONUP)
		{
			switch(event.button.button)
			{
				case SDL_BUTTON_LEFT:
					InputStates.mouseLEFT = 0;
					break;
				case SDL_BUTTON_RIGHT:
					InputStates.mouseRIGHT = 0;
					break;
				default:
					break;
			}
		}
	*/

	//Mouse Motion Stuff

    SDL_Event[128] inputEvents;
	int amt = SDL_PeepEvents(inputEvents.ptr, inputEvents.length, SDL_GETEVENT, SDL_FIRSTEVENT, SDL_LASTEVENT);
    for(int i = 0; i < amt; i++)
    {
		SDL_Event event = inputEvents[i];

    	if(event.type == SDL_QUIT)
    	{
    		ShouldQuit = true;
    	}
		else if(event.type == SDL_MOUSEMOTION)
        {
            InputStates.mouseXRel = event.motion.xrel;
            InputStates.mouseYRel = event.motion.yrel;

            InputStates.mouseX = event.motion.x;

            InputStates.mouseY = event.motion.y;
        }
	}
}

struct InputStates
{
	public static shared int shouldQuit;


    public static int keyA;
//    public static int keyB;
//    public static int keyC;
    public static int keyD;
    public static int keyE;
//    public static int keyF;
//    public static int keyG;
//    public static int keyH;
//    public static int keyI;
//    public static int keyK;
//    public static int keyL;
//    public static int keyM;
//    public static int keyN;
//    public static int keyO;
//    public static int keyP;
    public static int keyQ;
//    public static int keyR;
    public static int keyS;
//    public static int keyT;
//    public static int keyU;
//    public static int keyV
    public static int keyW;
//    public static int keyX;
//    public static int keyY;
    public static int keyZ;


    public static int key0;
    public static int key1;
    public static int key2;
    public static int key3;
    public static int key4;
    public static int key5;
    public static int key6;
    public static int key7;
    public static int key8;
    public static int key9;

    public static int keySPACE;

    public static int keyLEFT;
    public static int keyRIGHT;
    public static int keyUP;
    public static int keyDOWN;

    public static int mouseXRel;
    public static int mouseYRel;

    public static uint mouseX;
    public static uint mouseY;

	public static int mouseLEFT;
	public static int mouseRIGHT;
}
