import derelict.opengl3.gl;

import std.stdio;

import display;
import shader;
import shaderController;
import mesh;

import gl3n.linalg;

public Display disp;

/**
  * Matrices for movement and perspective transform
**/

const mat4 perspMatrix = mat4.perspective(1024, 768, 100, 0.1f, 500.0f);
mat4 cameraMatrix;


public void CreateDisplay(int width, int height, const(char)* title)
{
    disp = new Display(width, height, title);

    glFrontFace(GL_CCW);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);

	glEnable(GL_ALPHA);

	InitShaders();
}

public void Render ()
{ 
    disp.SwapBuffers();
}
