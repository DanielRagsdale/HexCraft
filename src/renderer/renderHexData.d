import derelict.opengl3.gl;
import derelict.sdl2.sdl;
import gl3n.linalg;

import util.obj;

import std.stdio;

import hexMesh;
import texture;
import game;
import renderer;
import shaderController;
import textureController;

import map;
import mapModel;

import util.values;
import util.coordVectors;

HexMesh[vec_chunk] meshes;
uint[vec_chunk] chunkVersions;

void DrawRegion(ChunkModel cm, vec_chunk c)
{
	SetTexture(TextureTypes.HEXES);	

	HexMesh* m = c in meshes;	
	if(m is null)
	{
		meshes[c] = new HexMesh(cm);
		chunkVersions[c] = cm.chunkVersion;
	}

	if(cm.chunkVersion != chunkVersions[c])
	{
		meshes[c].destroy;
		meshes[c] = new HexMesh(cm);
		chunkVersions[c] = cm.chunkVersion;
	}

	DrawSimpleChunk(meshes[c], mat4.identity().translate(c.x * CHUNK_SIZE * hex_dx 
				+ c.y * CHUNK_SIZE * hex_dy + c.z * CHUNK_SIZE * hex_dz));
}

/**
* Draw the given mesh
* Transformed with given transformMatrix
*/
void DrawSimpleChunk(HexMesh mesh, mat4 transformMatrix)
{
    GLint shLoc = SetShaderProgram(ShaderTypes.BLOCK);

    GLint transformUniformLocation = glGetUniformLocation(shLoc, "transform");
    GLint cameraUniformLocation = glGetUniformLocation(shLoc, "camera");
    
    glUniformMatrix4fv(transformUniformLocation, 1, GL_FALSE, &transformMatrix[0][0]);
    glUniformMatrix4fv(cameraUniformLocation, 1, GL_FALSE, &renderer.cameraMatrix[0][0]);

    mesh.Draw();
}





