#version 150

in vec3 position;
in vec2 texCoord;

uniform mat4 transform;
uniform mat4 camera;

out vec2 texCoord1;

void main()
{
    vec4 tempPos = vec4(position, 1.0) * transform * camera ;

    gl_Position = tempPos;

    texCoord1 = texCoord;
}
