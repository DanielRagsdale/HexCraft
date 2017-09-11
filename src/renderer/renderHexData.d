import derelict.opengl3.gl;
import derelict.sdl2.sdl;
import gl3n.linalg;

import util.obj;

import std.stdio;

import mesh;
import texture;
import game;
import renderer;


void DrawRegion(ushort[16][16][16]* reg, int rX, int rY, int rZ)
{
	foreach(x; 0 .. 16)
	{
	foreach(y; 0 .. 16)
	{
	foreach(z; 0 .. 16)
	{
		if((*reg)[x][y][z])
		{
			DrawColorHex(cast(ushort)((*reg)[x][y][z] - 1), x, y, z);
		}

		//writeln("From DrawRegion: ", reg);
	}
	}
	}
}

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
	0.000000f, 0.0f,
	0.015625f, 0.0f,
	0.031250f, 0.0f,
	0.046875f, 0.0f,
	0.062500f, 0.0f,
	0.078125f, 0.0f,

	0.000000f, 0.03125f,
	0.015625f, 0.03125f,
	0.031250f, 0.03125f,
	0.046875f, 0.03125f,
	0.062500f, 0.03125f,
	0.078125f, 0.03125f,
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

GLfloat[4][8] palette = [
	[0.0f, 0.0f, 0.0f, 0.0f],
	[1.0f, 0.0f, 0.0f, 0.0f],
	[0.0f, 1.0f, 0.0f, 0.0f],
	[0.0f, 0.0f, 1.0f, 0.0f],
	[1.0f, 1.0f, 0.0f, 0.0f],
	[1.0f, 0.0f, 1.0f, 0.0f],
	[0.0f, 1.0f, 1.0f, 0.0f],
	[0.0f, 1.0f, 1.0f, 0.0f]];


/**
* Draw a solid color hex.
*/
Mesh m;
Texture hexTex;

void DrawColorHex(ushort col, int x, int y, int z)
{
	if(m is null)
	{
		m = new Mesh(hexVertices.ptr, hexTexCoords.ptr, cast(int)hexVertices.length / 3 , hexIndices.ptr, cast(int)hexIndices.length);
	}
	if(hexTex is null)
	{
 		hexTex = new Texture("./src/res/bitmap/hexes.png");
	}
	hexTex.Bind();
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST); 
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 

	DrawSimpleHex(m, mat4.identity().translate(dx * x + dy * y + dz * z), palette[col].ptr);
}

/**
* Draw the given mesh
* Transformed with given transformMatrix
*/
ulong counter;
void DrawSimpleHex(Mesh mesh, mat4 transformMatrix, GLfloat* color)
{
    GLint shLoc = SetShaderProgram(0);

    GLint transformUniformLocation = glGetUniformLocation(shLoc, "transform");
    GLint cameraUniformLocation = glGetUniformLocation(shLoc, "camera");
    
	GLint colorUniformLocation = glGetUniformLocation(shLoc, "color");

    glUniformMatrix4fv(transformUniformLocation, 1, GL_FALSE, &transformMatrix[0][0]);
    glUniformMatrix4fv(cameraUniformLocation, 1, GL_FALSE, &renderer.cameraMatrix[0][0]);

	glUniform4fv(colorUniformLocation, 1, color);

    mesh.Draw();
}





