#version 150

in vec2 texCoord1;

uniform sampler2D sampler;

out vec4 outColor;

in vec4 vertPos;

void main()
{
    outColor = texture2D(sampler, texCoord1);
}
