import shader;

import derelict.opengl3.gl;

class ShaderTest : Shader
{
	this()
	{
		super("./src/res/shader/test", 0x00);
		
		glBindAttribLocation(m_program, 0, "position");
		glBindAttribLocation(m_program, 1, "texCoord");
		//glBindAttribLocation(m_program, 2, "normal");
	}
}