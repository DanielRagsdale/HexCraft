#version 150

uniform mat4 transform;
uniform mat4 camera;

layout(points) in;
layout(triangle_strip, max_vertices = 6) out;

in vec3[1] components0;
in vec3[1] color0;

out vec3 color1;
out vec4 position1;

void main()
{
	if(components0[0].x >= 0 && components0[0].y >= 0 && components0[0].z >= 0)
        {
            position1 = (gl_in[0].gl_Position + vec4(0.0, 0.0, 0.0, 0.0) * 0.1) * transform;
            gl_Position =  position1 * camera;
            color1 = color0[0];
            EmitVertex();

            position1 = (gl_in[0].gl_Position + vec4(components0[0].x, 0.0, components0[0].z, 0.0) * 0.1) * transform;
            gl_Position =  position1 * camera;
            color1 = color0[0];
            EmitVertex();

            position1 = (gl_in[0].gl_Position + vec4(0.0, components0[0].y, components0[0].z, 0.0) * 0.1) * transform;
            gl_Position = position1 * camera;
            color1 = color0[0];
            EmitVertex();

            EndPrimitive();


            position1 = (gl_in[0].gl_Position + vec4(components0[0].x, components0[0].y, components0[0].z, 0.0) * 0.1) * transform;
            gl_Position = position1 * camera;
            color1 = color0[0];
            EmitVertex();

            position1 = (gl_in[0].gl_Position + vec4(0.0, components0[0].y, 0.0, 0.0) * 0.1) * transform;
            gl_Position = position1 * camera;
            color1 = color0[0];
            EmitVertex();

            position1 = (gl_in[0].gl_Position + vec4(components0[0].x, 0.0, 0.0, 0.0) * 0.1) * transform;
            gl_Position =  position1 * camera;
            color1 = color0[0];
            EmitVertex();

            EndPrimitive();
        }
        else
        {
            position1 = (gl_in[0].gl_Position + vec4(components0[0].x, 0.0, components0[0].z, 0.0) * 0.1) * transform;
            gl_Position = position1 * camera;
            color1 = color0[0];
            EmitVertex();

            position1 = (gl_in[0].gl_Position + vec4(0.0, 0.0, 0.0, 0.0) * 0.1) * transform;
            gl_Position = position1 * camera;
            color1 = color0[0];
            EmitVertex();

            position1 = (gl_in[0].gl_Position + vec4(0.0, components0[0].y, components0[0].z, 0.0) * 0.1) * transform;
            gl_Position = position1 * camera;
            color1 = color0[0];
            EmitVertex();

            EndPrimitive();

            position1 = (gl_in[0].gl_Position + vec4(0.0, components0[0].y, 0.0, 0.0) * 0.1) * transform;
            gl_Position = position1 * camera;
            color1 = color0[0];
            EmitVertex();

            position1 = (gl_in[0].gl_Position + vec4(components0[0].x, components0[0].y, components0[0].z, 0.0) * 0.1) * transform;
            gl_Position = position1 * camera;
            color1 = color0[0];
            EmitVertex();

            position1 = (gl_in[0].gl_Position + vec4(components0[0].x, 0.0, 0.0, 0.0) * 0.1) * transform;
            gl_Position = position1 * camera;
            color1 = color0[0];
            EmitVertex();

            EndPrimitive();
        }
}
