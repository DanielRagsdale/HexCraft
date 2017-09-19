import derelict.opengl3.gl;

import std.stdio;

import display;
import shader;
import mesh;
import texture;

import gl3n.linalg;

Texture[] textures = new Texture[5];
uint textureID = -1;

public enum TextureTypes
{
	HEXES
	//TEST,
	//GUI
}

public void InitTextures()
{
	textures[TextureTypes.HEXES] = new Texture("./src/res/bitmap/hexes.png");
}

/**
* Check if a shader program is already bound, and, if not, bind the correct shaders.
* @return the OpenGL ProgramID.
*/
public void SetTexture(uint tID)
{
    if(tID != textureID)
    {
        textureID = tID;
        return textures[textureID].Bind();
    }
}
