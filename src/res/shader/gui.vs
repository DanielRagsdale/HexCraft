#version 150

in vec3 position;
in vec2 texCoord;

uniform mat4 ortho;

out vec2 texCoord1;

void main()
{
    gl_Position = vec4(position, 1.0) * ortho;

    texCoord1 = texCoord;
}
