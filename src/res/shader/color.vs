#version 150

in vec3 position;

uniform mat4 transform;
uniform mat4 camera;

out vec4 vertPos;

void main()
{
    vec4 tempPos = vec4(position, 1.0) * transform * camera ;

    gl_Position = tempPos;

    vertPos = tempPos;
}
