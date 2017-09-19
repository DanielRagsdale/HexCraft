import derelict.opengl3.gl;
import derelict.sdl2.sdl;
import gl3n.linalg;

import util.obj;

import std.stdio;

import mesh;
import texture;
import game;
import renderer;
import shaderController;

/**
* The array of draw functions that called with the information from RenderData
*/
void function(byte[] b)[] DrawFunctions =
	[
	&SetCamera,//0
	&Demo,
	&GUIRender //3
	];

/**
* Set the camera position and orientation
*
* [camTransformMatrix]
*/
void SetCamera(byte[] b)
{
	mat4 parsed = *cast(mat4*)&b[0];

	renderer.cameraMatrix = renderer.perspMatrix * parsed;
}

/**
* Demo render function
*/
void Demo(byte[] b)
{
}

GLfloat[] guiVerts = [
	-0.05f, -0.05f, 0.0f,
	 0.05f, -0.05f, 0.0f,
	 0.00f,  0.05f,  0.0f ];

GLfloat[] guiTexCoords = [
	0.0f, 1.0f,
	0.0f, 1.0f,
	0.0f, 1.0f];

GLint[] guiIndices = [0,1,2];

mat4 orthoMatrix = mat4.orthographic(-1.0f, 1.0f, -1.0f, 1.0f, 1.0f, -1.0f);

Mesh testMesh;

void GUIRender(byte[] b)
{
	/*
	if(testMesh is null)
	{
		testMesh = new Mesh(guiVerts.ptr, guiTexCoords.ptr, 3, guiIndices.ptr, 3);
	}
    GLint shLoc = SetShaderProgram(ShaderTypes.GUI);
	GLint orthoUniformLocation = glGetUniformLocation(shLoc, "ortho");
	
    glUniformMatrix4fv(orthoUniformLocation, 1, GL_FALSE, &orthoMatrix[0][0]);

	glDisable(GL_DEPTH_TEST);

	testMesh.Draw();

	glEnable(GL_DEPTH_TEST);

	*/
}


/**
* Contains the information needed to render a RenderObject
*/
struct RenderData
{
	public int RenderObjectID;
	public byte[] Data;
	
	this(uint ID, byte[] data)
	{
		RenderObjectID = ID;
		Data = data.dup;
	}
	
	int opCmp(ref const RenderData s) const 
	{
		return RenderObjectID - s.RenderObjectID;
	}
}
