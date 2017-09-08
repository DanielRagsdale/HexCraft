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
immutable void function(int x, int y, int z)[] DrawFunctions =
	[
		&DrawColorHex
	];


const vec3 dx = vec3(0.8660254,0,0.5);
const vec3 dy = vec3(0, 1, 0);
const vec3 dz = vec3(0,0,1);

GLfloat[] hexVertices = [
	// top
	-0.57735027f,  0.0f,  0.0000f,
	-0.288675,     0.0f, -0.5f,
	 0.288675,     0.0f, -0.5f,
	 0.57735027f,  0.0f,  0.0000f,
	 0.288675,     0.0f,  0.5f,
	-0.288675,     0.0f,  0.5f,

	// bottom 
	-0.57735027f,  -1.0f,  0.0000f,
	-0.288675,     -1.0f, -0.5f,
	 0.288675,     -1.0f, -0.5f,
	 0.57735027f,  -1.0f,  0.0000f,
	 0.288675, 	   -1.0f,  0.5f,
	-0.288675, 	   -1.0f,  0.5f,
];

GLfloat[] hexTexCoords = [
	0.0f, 0.0f,
	0.0f, 0.0f,
	0.0f, 0.0f,
	0.0f, 0.0f,
	0.0f, 0.0f,
	0.0f, 0.0f,

	1.0f, 1.0f,
	1.0f, 1.0f,
	1.0f, 1.0f,
	1.0f, 1.0f,
	1.0f, 1.0f,
	1.0f, 1.0f,
];

GLint[] hexIndices = [
	// top
	0, 5, 1,
	1, 5, 4,
	1, 4, 2,
	2, 4, 3,

	// side 1
	0, 1, 7,
	0, 7, 6,	
	// side 2
	1, 2, 8,
	1, 8, 7,
	// side 3
	2, 3, 9,
	2, 9, 8,
	// side 4
	3, 4, 10,
	3, 10, 9,
	// side 5
	4, 5, 11,
	4, 11, 10,
	// side 6
	5, 0, 6,
	5, 6, 11,

	// bottom
	6, 7, 11,
	7, 10, 11,
	7, 8, 10,
	8, 9, 10,
];

/**
* Draw a solid color hex.
*/
Mesh m;

void DrawColorHex(int x, int y, int z)
{
	if(m is null)
	{
		m = new Mesh(hexVertices.ptr, hexTexCoords.ptr, cast(int)hexVertices.length / 3 , hexIndices.ptr, cast(int)hexIndices.length);
	}
	
	DrawSimpleMesh(m, mat4.identity().translate(dx * x + dy * y + dz * z));
}

/**
* Draw the given mesh
* Transformed with given transformMatrix
*/
void DrawSimpleMesh(Mesh mesh, mat4 transformMatrix)
{
    GLint shLoc = SetShaderProgram(1);

    GLint transformUniformLocation = glGetUniformLocation(shLoc, "transform");

    GLint cameraUniformLocation = glGetUniformLocation(shLoc, "camera");

    glUniformMatrix4fv(transformUniformLocation, 1, GL_FALSE, &transformMatrix[0][0]);
    glUniformMatrix4fv(cameraUniformLocation, 1, GL_FALSE, &renderer.cameraMatrix[0][0]);

    mesh.Draw();
}





