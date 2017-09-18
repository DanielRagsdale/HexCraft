#version 150

in vec3 position;

uniform mat4 ortho;

void main()
{
    gl_Position = vec4(position.xy, -1, 1.0);
}
