import shader;

import derelict.opengl3.gl;

class ShaderTest : Shader
{
	this()
	{
		super("./src/res/shader/test", 0x00);
	}
}
