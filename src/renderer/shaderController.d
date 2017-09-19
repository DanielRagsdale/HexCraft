import derelict.opengl3.gl;

import std.stdio;

import display;
import shader;
import mesh;

import gl3n.linalg;

Shader[] shaders = new Shader[5];
uint shaderID = -1;

public enum ShaderTypes
{
	BLOCK,
	TEST,
	GUI
}

public void InitShaders()
{
    shaders[ShaderTypes.BLOCK] = new Shader("./src/res/shader/block", 0x00);
    shaders[ShaderTypes.TEST] = new Shader("./src/res/shader/test", 0x00);
    shaders[ShaderTypes.GUI] = new Shader("./src/res/shader/gui", 0x00);
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
