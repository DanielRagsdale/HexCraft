#version 150

layout(triangles) in;
layout(line_strip, max_vertices = 6) out;

in vec2[3] texCoord0;

out vec2 texCoord1;

void main()
{
    gl_Position = gl_in[0].gl_Position;
    texCoord1 = texCoord0[0];
    EmitVertex();

    gl_Position = gl_in[1].gl_Position;
    texCoord1 = texCoord0[1];
    EmitVertex();

    EndPrimitive();


    gl_Position = gl_in[1].gl_Position;
        texCoord1 = texCoord0[1];
    EmitVertex();

    gl_Position = gl_in[2].gl_Position;
        texCoord1 = texCoord0[2];
    EmitVertex();

    EndPrimitive();


    gl_Position = gl_in[0].gl_Position;
        texCoord1 = texCoord0[0];
    EmitVertex();

    gl_Position = gl_in[2].gl_Position;
        texCoord1 = texCoord0[2];
    EmitVertex();

    EndPrimitive();
}
