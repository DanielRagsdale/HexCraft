#version 150

in vec2 texCoord1;

uniform sampler2D sampler;

out vec4 outColor;

void main()
{
	vec4 texColor = texture(sampler, texCoord1);

    //if(texColor.a < 0.1)
        //discard;

    outColor = texColor;
}
