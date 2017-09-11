import shader;

import derelict.opengl3.gl;

class ShaderColor : Shader
{
	this()
	{
		super("./src/res/shader/color", 0x00);
	}
}
