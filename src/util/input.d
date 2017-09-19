module util.input;

import core.atomic;

import derelict.sdl2.sdl;

import std.stdio;
import game;
import renderer;

public shared bool ShouldQuit;

shared SDL_Event[] rawEvents;

void PollSDLEvents()
{
	//SDL_Event[] tempEvents;

    SDL_Event event;
    while(SDL_PollEvent(&event))
    {
    	if(event.type == SDL_QUIT)
    	{
    	ShouldQuit = true;
    	}
		else
		{
			rawEvents ~= event;
		}
	}

	//rawEvents.atomicStore(cast(shared)tempEvents);
}

void UpdateInput()
{
	//SDL_Event[] localEvents;	
	//localEvents.atomicStore(cast(SDL_Event[])rawEvents);
	//localEvents = cast(SDL_Event[])rawEvents;

    InputStates.mouseXRel = 0;
    InputStates.mouseYRel = 0;

	foreach(event; rawEvents)
	{
        if(event.type == SDL_KEYDOWN)
        {
            switch(event.key.keysym.sym)
            {
                case SDLK_a:
                    InputStates.keyA.atomicOp!"+="(1);
                    break;
                case SDLK_d:
                    InputStates.keyD.atomicOp!"+="(1);
                    break;
                case SDLK_e:
                    InputStates.keyE.atomicOp!"+="(1);
                    break;
                case SDLK_s:
                    InputStates.keyS.atomicOp!"+="(1);
                    break;
                case SDLK_q:
                    InputStates.keyQ.atomicOp!"+="(1);
                    break;
                case SDLK_w:
                    InputStates.keyW.atomicOp!"+="(1);
                    break;
                case SDLK_z:
                    InputStates.keyZ.atomicOp!"+="(1);
                    break;

                case SDLK_0:
                    InputStates.key0.atomicOp!"+="(1);
                    break;
                case SDLK_1:
                    InputStates.key1.atomicOp!"+="(1);
                    break;
                case SDLK_2:
                    InputStates.key2.atomicOp!"+="(1);
                    break;
                case SDLK_3:
                    InputStates.key3.atomicOp!"+="(1);
                    break;
                case SDLK_4:
                    InputStates.key4.atomicOp!"+="(1);
                    break;
                case SDLK_5:
                    InputStates.key5.atomicOp!"+="(1);
                    break;
                case SDLK_6:
                    InputStates.key6.atomicOp!"+="(1);
                    break;
                case SDLK_7:
                    InputStates.key7.atomicOp!"+="(1);
                    break;
                case SDLK_8:
                    InputStates.key8.atomicOp!"+="(1);
                    break;
                case SDLK_9:
                    InputStates.key9.atomicOp!"+="(1);
                    break;

                case SDLK_SPACE:
                    InputStates.keySPACE.atomicOp!"+="(1);
                    break;

                case SDLK_LEFT:
                    InputStates.keyLEFT.atomicOp!"+="(1);
                    break;
                case SDLK_RIGHT:
                    InputStates.keyRIGHT.atomicOp!"+="(1);
                    break;
                case SDLK_UP:
                    InputStates.keyUP.atomicOp!"+="(1);
                    break;
                case SDLK_DOWN:
                    InputStates.keyDOWN.atomicOp!"+="(1);
                    break;

                default:
                    break;
            }
        }
        else if(event.type == SDL_KEYUP)
        {
            switch(event.key.keysym.sym)
            {
                case SDLK_a:
                    InputStates.keyA = 0;
                    break;
                case SDLK_d:
                    InputStates.keyD = 0;
                    break;
                case SDLK_e:
                    InputStates.keyE = 0;
                    break;
                case SDLK_s:
                    InputStates.keyS = 0;
                    break;
                case SDLK_q:
                    InputStates.keyQ = 0;
                    break;
                case SDLK_w:
                    InputStates.keyW = 0;
                    break;
                case SDLK_z:
                    InputStates.keyZ = 0;
                    break;

                case SDLK_0:
                    InputStates.key0 = 0;
                    break;
                case SDLK_1:
                    InputStates.key1 = 0;
                    break;
                case SDLK_2:
                    InputStates.key2 = 0;
                    break;
                case SDLK_3:
                    InputStates.key3 = 0;
                    break;
                case SDLK_4:
                    InputStates.key4 = 0;
                    break;
                case SDLK_5:
                    InputStates.key5 = 0;
                    break;
                case SDLK_6:
                    InputStates.key6 = 0;
                    break;
                case SDLK_7:
                    InputStates.key7 = 0;
                    break;
                case SDLK_8:
                    InputStates.key8 = 0;
                    break;
                case SDLK_9:
                    InputStates.key9 = 0;
                    break;

                case SDLK_SPACE:
                    InputStates.keySPACE = 0;
                    break;

                case SDLK_LEFT:
                    InputStates.keyLEFT = 0;
                    break;
                case SDLK_RIGHT:
                    InputStates.keyRIGHT = 0;
                    break;
                case SDLK_UP:
                    InputStates.keyUP = 0;
                    break;
                case SDLK_DOWN:
                    InputStates.keyDOWN = 0;
                    break;

                default:
                    break;
            }
        }
        else if(event.type == SDL_MOUSEMOTION)
        {
            InputStates.mouseXRel = event.motion.xrel;
            InputStates.mouseYRel = event.motion.yrel;

            InputStates.mouseX = event.motion.x;

            InputStates.mouseY = event.motion.y;
        }
		else if(event.type == SDL_MOUSEBUTTONDOWN)
		{
			switch(event.button.button)
			{
				case SDL_BUTTON_LEFT:
					InputStates.mouseLEFT.atomicOp!"+="(1);
					break;
				case SDL_BUTTON_RIGHT:
					InputStates.mouseRIGHT.atomicOp!"+="(1);
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
	}
	rawEvents = [];

}

struct InputStates
{
	public static shared int shouldQuit;


    public static shared int keyA;
//    public static shared int keyB;
//    public static shared int keyC;
    public static shared int keyD;
    public static shared int keyE;
//    public static shared int keyF;
//    public static shared int keyG;
//    public static shared int keyH;
//    public static shared int keyI;
//    public static shared int keyK;
//    public static shared int keyL;
//    public static shared int keyM;
//    public static shared int keyN;
//    public static shared int keyO;
//    public static shared int keyP;
    public static shared int keyQ;
//    public static shared int keyR;
    public static shared int keyS;
//    public static shared int keyT;
//    public static shared int keyU;
//    public static shared int keyV
    public static shared int keyW;
//    public static shared int keyX;
//    public static shared int keyY;
    public static shared int keyZ;


    public static shared int key0;
    public static shared int key1;
    public static shared int key2;
    public static shared int key3;
    public static shared int key4;
    public static shared int key5;
    public static shared int key6;
    public static shared int key7;
    public static shared int key8;
    public static shared int key9;

    public static shared int keySPACE;

    public static shared int keyLEFT;
    public static shared int keyRIGHT;
    public static shared int keyUP;
    public static shared int keyDOWN;


    public static shared int mouseXRel;
    public static shared int mouseYRel;

    public static shared uint mouseX;
    public static shared uint mouseY;

	public static shared int mouseLEFT;
	public static shared int mouseRIGHT;
}
