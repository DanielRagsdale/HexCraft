import std.stdio;

import derelict.sdl2.sdl;
import derelict.opengl3.gl;

import renderer;

class Display
{
    SDL_Window* m_window;
    SDL_GLContext m_glContext;

    public int width;
    public int height;

    public int halfWidth;
    public int halfHeight;

    this(int w, int h, const(char)* title)
    {        
        width = w;
        height = h;

        halfWidth = w / 2;
        halfHeight = h / 2;

        DerelictSDL2.load();
        DerelictGL3.load();

        SDL_Init(SDL_INIT_EVERYTHING);

        SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE,32);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE,16);

        SDL_SetRelativeMouseMode(SDL_TRUE);

        m_window = SDL_CreateWindow(title, SDL_WINDOWPOS_CENTERED,
                SDL_WINDOWPOS_CENTERED, w, h, SDL_WINDOW_OPENGL);
	    m_glContext = SDL_GL_CreateContext(m_window);

        DerelictGL3.reload();

	    glEnable(GL_DEPTH_TEST);
    }

    void Clear(float r, float g, float b, float a)
    {
	    glClearColor(r, g, b, a);
	    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }

    void SwapBuffers()
    {
	    SDL_GL_SwapWindow(m_window);
    }
}
