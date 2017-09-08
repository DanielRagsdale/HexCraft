module texture;

import std.stdio;

import imageformats;

import derelict.opengl3.gl;

class Texture
{
    IFImage textureData;
    GLuint m_texture;

    this(string fileName)
    {
        glGenTextures(1, &m_texture);
        glBindTexture(GL_TEXTURE_2D, m_texture);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

        textureData = read_image(fileName, ColFmt.RGB);

        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, textureData.w, textureData.h, 0, GL_RGB, GL_UNSIGNED_BYTE, &textureData.pixels[0]);
    }

    public void Bind()
    {
        glBindTexture(GL_TEXTURE_2D, m_texture);
    }

    ~this()
    {
        glDeleteTextures(1, &m_texture);
    }
}