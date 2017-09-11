#version 150

in vec3 position;

uniform mat4 transform;
uniform mat4 camera;

void main()
{
    gl_Position = vec4(position, 1.0) * transform * camera;
}
