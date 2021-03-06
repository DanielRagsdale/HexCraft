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
import textureController;

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
	//HotBar
	-0.82f, -0.8f, 0.0f,
	-0.82f, -1.0f, 0.0f,
	 0.82f, -1.0f, 0.0f,
	 0.82f, -0.8f, 0.0f,
	 
	//CrossHair
	-0.03f,  0.03f, 0.0f,
	-0.03f, -0.03f, 0.0f,
	 0.03f, -0.03f, 0.0f,
	 0.03f,  0.03f, 0.0f];

GLfloat[] guiTexCoords = [
	0.0f,    0.0f,
	0.0f,    0.0781f,
	0.6406f, 0.0781f,
	0.6406f, 0.0f,

	0.6406f, 0.0f,
	0.6406f, 0.0781f,
	0.7188f, 0.0781f,
	0.7188f, 0.0f];

GLint[] guiIndices = [0,1,2, 0,2,3,   4,5,6, 4,6,7];

mat4 orthoMatrix = mat4.orthographic(-1.0f, 1.0f, -2.0f, 2.0f, 1.0f, -1.0f);

Mesh guiMesh;

void GUIRender(byte[] b)
{
	orthoMatrix = mat4.orthographic(-1.0f * disp.aspectRatio, 1.0f * disp.aspectRatio, -1.0f, 1.0f, 1.0f, -1.0f);

	if(guiMesh is null)
	{
		guiMesh = new Mesh(guiVerts.ptr, guiTexCoords.ptr, guiVerts.length / 3, guiIndices.ptr, guiIndices.length);
	}
	SetTexture(TextureTypes.HUD);

    GLint shLoc = SetShaderProgram(ShaderTypes.GUI);
	GLint orthoUniformLocation = glGetUniformLocation(shLoc, "ortho");
	
    glUniformMatrix4fv(orthoUniformLocation, 1, GL_FALSE, &orthoMatrix[0][0]);

	glDisable(GL_DEPTH_TEST);

	guiMesh.Draw();

	glEnable(GL_DEPTH_TEST);
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
