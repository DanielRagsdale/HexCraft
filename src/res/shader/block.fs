#version 150

in vec2 texCoord1;

uniform sampler2D sampler;

out vec4 outColor;

void main()
{
    outColor = texture(sampler, texCoord1);
}
