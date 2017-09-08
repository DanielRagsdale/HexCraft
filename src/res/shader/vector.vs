#version 150

in vec3 basepoint;
in vec3 components;
in vec3 color;



out vec3 components0;
out vec3 color0;

void main()
{
    gl_Position = vec4(basepoint * 0.1, 1.0);

    components0 = components;
    color0 = color;
}
