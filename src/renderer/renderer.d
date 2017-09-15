import derelict.opengl3.gl;

import std.stdio;

import display;
import shader;
import mesh;

import gl3n.linalg;

public Display disp;

Shader[] shaders = new Shader[5];
uint shaderID = -1;

/**
  * Matrices for movement and perspective transform
**/

const mat4 perspMatrix = mat4.perspective(1024, 768, 100, 0.1f, 500.0f);
mat4 cameraMatrix;


public void CreateDisplay(int width, int height, const(char)* title)
{
    disp = new Display(width, height, title);

    shaders[0] = new Shader("./src/res/shader/block", 0x00);
    shaders[1] = new Shader("./src/res/shader/test", 0x00);
    
	SetShaderProgram(0);

    glFrontFace(GL_CCW);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);

	glEnable(GL_ALPHA);
}

public void Render ()
{ 
    disp.SwapBuffers();
}

/**
* Check if a shader program is already bound, and, if not, bind the correct shaders.
* @return the OpenGL ProgramID.
*/
public GLint SetShaderProgram(uint sID)
{
    if(sID != shaderID)
    {
        shaderID = sID;
        return shaders[shaderID].Bind();
    }

    return shaders[shaderID].ProgramLocation();
}
