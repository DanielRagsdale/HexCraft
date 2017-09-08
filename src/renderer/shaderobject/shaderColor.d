import shader;

import derelict.opengl3.gl;

class ShaderColor : Shader
{
	this()
	{
		super("./src/res/shader/color", 0x00);
		
		glBindAttribLocation(m_program, 0, "position");
	}
}
