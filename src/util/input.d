module util.input;

import derelict.sdl2.sdl;

import std.stdio;
import game;
import renderer;

void PollSDLEvents()
{
    SDL_Event event;

    InputStates.mouseXRel = 0;
    InputStates.mouseYRel = 0;

    if(SDL_PollEvent(&event))
    {
        do
        {
            if(event.type == SDL_QUIT)
            {
                InputStates.shouldQuit = true;
            }
            else if(event.type == SDL_KEYDOWN)
            {
                switch(event.key.keysym.sym)
                {
                    case SDLK_a:
                        InputStates.keyA = true;
                        break;
                    case SDLK_d:
                        InputStates.keyD = true;
                        break;
                    case SDLK_s:
                        InputStates.keyS = true;
                        break;
                    case SDLK_q:
                        InputStates.keyQ = true;
                        break;
                    case SDLK_w:
                        InputStates.keyW = true;
                        break;
                    case SDLK_z:
                        InputStates.keyZ = true;
                        break;

                    case SDLK_0:
                        InputStates.key0 = true;
                        break;
                    case SDLK_1:
                        InputStates.key1 = true;
                        break;
                    case SDLK_2:
                        InputStates.key2 = true;
                        break;
                    case SDLK_3:
                        InputStates.key3 = true;
                        break;
                    case SDLK_4:
                        InputStates.key4 = true;
                        break;
                    case SDLK_5:
                        InputStates.key5 = true;
                        break;
                    case SDLK_6:
                        InputStates.key6 = true;
                        break;
                    case SDLK_7:
                        InputStates.key7 = true;
                        break;
                    case SDLK_8:
                        InputStates.key8 = true;
                        break;
                    case SDLK_9:
                        InputStates.key9 = true;
                        break;

                    case SDLK_SPACE:
                        InputStates.keySPACE = true;
                        break;

                    case SDLK_LEFT:
                        InputStates.keyLEFT = true;
                        break;
                    case SDLK_RIGHT:
                        InputStates.keyRIGHT = true;
                        break;
                    case SDLK_UP:
                        InputStates.keyUP = true;
                        break;
                    case SDLK_DOWN:
                        InputStates.keyDOWN = true;
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
                        InputStates.keyA = false;
                        break;
                    case SDLK_d:
                        InputStates.keyD = false;
                        break;
                    case SDLK_s:
                        InputStates.keyS = false;
                        break;
                    case SDLK_q:
                        InputStates.keyQ = false;
                        break;
                    case SDLK_w:
                        InputStates.keyW = false;
                        break;
                    case SDLK_z:
                        InputStates.keyZ = false;
                        break;

                    case SDLK_0:
                        InputStates.key0 = false;
                        break;
                    case SDLK_1:
                        InputStates.key1 = false;
                        break;
                    case SDLK_2:
                        InputStates.key2 = false;
                        break;
                    case SDLK_3:
                        InputStates.key3 = false;
                        break;
                    case SDLK_4:
                        InputStates.key4 = false;
                        break;
                    case SDLK_5:
                        InputStates.key5 = false;
                        break;
                    case SDLK_6:
                        InputStates.key6 = false;
                        break;
                    case SDLK_7:
                        InputStates.key7 = false;
                        break;
                    case SDLK_8:
                        InputStates.key8 = false;
                        break;
                    case SDLK_9:
                        InputStates.key9 = false;
                        break;

                    case SDLK_SPACE:
                        InputStates.keySPACE = false;
                        break;

                    case SDLK_LEFT:
                        InputStates.keyLEFT = false;
                        break;
                    case SDLK_RIGHT:
                        InputStates.keyRIGHT = false;
                        break;
                    case SDLK_UP:
                        InputStates.keyUP = false;
                        break;
                    case SDLK_DOWN:
                        InputStates.keyDOWN = false;
                        break;

                    default:
                        break;
                }
            }
            else if(event.type == SDL_MOUSEMOTION)
            {
                InputStates.mouseXRel = event.motion.xrel;
                InputStates.mouseYRel = event.motion.yrel;

//                writeln(event.motion.x, "   ", event.motion.y);

                InputStates.mouseX = event.motion.x;

                InputStates.mouseY = event.motion.y;
            }
        }while(SDL_PollEvent(&event));

            //SDL_WarpMouseInWindow(disp.m_window, disp.halfWidth, disp.halfHeight);
    }
}


struct InputStates
{
	public static shared bool shouldQuit;


    public static shared bool keyA;
//    public static shared bool keyB;
//    public static shared bool keyC;
    public static shared bool keyD;
//    public static shared bool keyE;
//    public static shared bool keyF;
//    public static shared bool keyG;
//    public static shared bool keyH;
//    public static shared bool keyI;
//    public static shared bool keyK;
//    public static shared bool keyL;
//    public static shared bool keyM;
//    public static shared bool keyN;
//    public static shared bool keyO;
//    public static shared bool keyP;
    public static shared bool keyQ;
//    public static shared bool keyR;
    public static shared bool keyS;
//    public static shared bool keyT;
//    public static shared bool keyU;
//    public static shared bool keyV;
    public static shared bool keyW;
//    public static shared bool keyX;
//    public static shared bool keyY;
    public static shared bool keyZ;


    public static shared bool key0;
    public static shared bool key1;
    public static shared bool key2;
    public static shared bool key3;
    public static shared bool key4;
    public static shared bool key5;
    public static shared bool key6;
    public static shared bool key7;
    public static shared bool key8;
    public static shared bool key9;

    public static shared bool keySPACE;

    public static shared bool keyLEFT;
    public static shared bool keyRIGHT;
    public static shared bool keyUP;
    public static shared bool keyDOWN;


    public static shared int mouseXRel;
    public static shared int mouseYRel;

    public static shared uint mouseX;
    public static shared uint mouseY;
}
