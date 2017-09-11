#version 150

in vec3 position;
in vec2 texCoord;

uniform mat4 transform;
uniform mat4 camera;

out vec2 texCoord1;

void main()
{
    gl_Position = vec4(position, 1.0) * transform * camera;

    texCoord1 = texCoord;
    //texCoord1 = vec2(0.5, 0.1);
}
