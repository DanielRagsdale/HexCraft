import derelict.opengl3.gl;
import derelict.sdl2.sdl;
import gl3n.linalg;

import util.obj;

import std.stdio;

import hexMesh;
import texture;
import game;
import renderer;

import map;
import mapModel;

import values;

immutable vec3 dx = vec3(0.8660254,0,0.5);
immutable vec3 dy = vec3(0, 1, 0);
immutable vec3 dz = vec3(0,0,1);

void DrawRegion(ChunkModel cm, coordinate c)
{
	DrawChunk(cm, c[0], c[1], c[2]);
}

Texture hexTex;
HexMesh[coordinate] meshes;
void DrawChunk(ref ChunkModel cm, int x, int y, int z)
{
	if(hexTex is null)
	{
 		hexTex = new Texture("./src/res/bitmap/hexes.png");
	}

	HexMesh* m = coordinate(x, y, z) in meshes;	
	if(m is null)
	{
		meshes[coordinate(x,y,z)] = new HexMesh(cm);
	}
	hexTex.Bind();
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST); 
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 

	DrawSimpleChunk(meshes[coordinate(x,y,z)], mat4.identity().translate(x * CHUNK_SIZE * dx + y * CHUNK_SIZE * dy + z * CHUNK_SIZE * dz));
}

/**
* Draw the given mesh
* Transformed with given transformMatrix
*/
void DrawSimpleChunk(HexMesh mesh, mat4 transformMatrix)
{
    GLint shLoc = SetShaderProgram(0);

    GLint transformUniformLocation = glGetUniformLocation(shLoc, "transform");
    GLint cameraUniformLocation = glGetUniformLocation(shLoc, "camera");
    

    glUniformMatrix4fv(transformUniformLocation, 1, GL_FALSE, &transformMatrix[0][0]);
    glUniformMatrix4fv(cameraUniformLocation, 1, GL_FALSE, &renderer.cameraMatrix[0][0]);

    mesh.Draw();
}





