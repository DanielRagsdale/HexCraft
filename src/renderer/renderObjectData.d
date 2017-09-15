import derelict.opengl3.gl;
import derelict.sdl2.sdl;
import gl3n.linalg;

import util.obj;

import std.stdio;

import mesh;
import texture;
import game;
import renderer;

/**
* The array of draw functions that called with the information from RenderData
*/
void function(byte[] b)[] DrawFunctions =
	[
	&SetCamera,//0
	&Demo,
	&DrawPrimitives,
	&MeshRender
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

/**
* Draw a variety of primitives.
*
* [primitiveType, primTransformMatrix, ...]
*/
void DrawPrimitives(byte[] b)
{
//TODO

	GLfloat[] cubeVertices = [
		// front
		-1.0f, -1.0f,  1.0f,
		 1.0f, -1.0f,  1.0f,
		 1.0f,  1.0f,  1.0f,
		-1.0f,  1.0f,  1.0f,
		// back
		-1.0f, -1.0f, -1.0f,
		 1.0f, -1.0f, -1.0f,
		 1.0f,  1.0f, -1.0f,
		-1.0f,  1.0f, -1.0f,
	];

	GLfloat[] cubeTexCoords = [
		0.0f, 0.0f,
		0.0f, 0.0f,
		0.0f, 0.0f,
		0.0f, 0.0f,

		0.0f, 0.0f,
		0.0f, 0.0f,
		0.0f, 0.0f,
		0.0f, 0.0f,
	];

	GLint[] cubeIndices = [
		// front
		0, 1, 2,
		2, 3, 0,
		// top
		1, 5, 6,
		6, 2, 1,
		// back
		7, 6, 5,
		5, 4, 7,
		// bottom
		4, 0, 3,
		3, 7, 4,
		// left
		4, 5, 1,
		1, 0, 4,
		// right
		3, 2, 6,
		6, 7, 3,
	];

	int i = 0;
	while(i < b.length && i == 0)
	{
		switch(b[i])
		{
			/**
			* Draw rectangular prism
			*/
			case 0:
				auto mesh = new Mesh(cubeVertices.ptr, cubeTexCoords.ptr, 8, cubeIndices.ptr, cast(int)cubeIndices.length);
				//mat4 parsed = *cast(mat4*)&b[i + 1];
				//DrawSimpleMesh(mesh, parsed);

				break;
			/**
			* Draw low poly sphere
			*/ 
			case 1:
			default:
				break;
		}
		i += 1 + mat4.sizeof;
	}
}

string[3] meshNames =
["dwarf", //0
"milestone",
"car"
];
Texture[3] meshTextures;
Mesh[3] meshes;

/**
* Draw a mesh from an index.
*
* [objID, objTransformMatrix, ...]
*/
void MeshRender(byte[] b)
{
    short id = *cast(short*)&b[0];

    mat4 parsedTrans = *cast(mat4*)&b[2];

    if(meshTextures[id] is null)
    {
        string fileName = meshNames [id];
        meshTextures[id] = new Texture("./src/res/bitmap/" ~ fileName ~ ".png");
    }

    meshTextures[id].Bind();

    if(meshes[id] is null)
    {
        string fileName = meshNames [id];

        auto mod = ImportOBJ("./src/res/model/" ~ fileName ~ ".obj");
        meshes[id] = new Mesh(&mod.vert(0)[0], &mod.texCoords[0][0], mod.nVerts(), &mod.indices[0], mod.nIndices());
    }

    DrawSimpleMesh(meshes[id], parsedTrans);
}


/**
* Draw the given mesh
* Transformed with given transformMatrix
*/
void DrawSimpleMesh(Mesh mesh, mat4 transformMatrix)
{
    GLint shLoc = SetShaderProgram(0);

    GLint transformUniformLocation = glGetUniformLocation(shLoc, "transform");

    GLint cameraUniformLocation = glGetUniformLocation(shLoc, "camera");

    glUniformMatrix4fv(transformUniformLocation, 1, GL_FALSE, &transformMatrix[0][0]);
    glUniformMatrix4fv(cameraUniformLocation, 1, GL_FALSE, &renderer.cameraMatrix[0][0]);

    mesh.Draw();
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
