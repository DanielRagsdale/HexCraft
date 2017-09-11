import std.stdio;
import std.file;

import derelict.opengl3.gl;

public static immutable uint USE_GEOMETRY_SHADER = 0x01;

class Shader
{
	static const uint NUM_SHADERS = 2;
	
	GLuint m_program;
	GLuint[] m_shaders;
	
	/**
	* Creates a new shader program.
	*/
	this(const string fileName, uint UseShaderTypes)
	{
		m_program = glCreateProgram();
		m_shaders ~= CreateShader(LoadShader(fileName ~ ".vs"), GL_VERTEX_SHADER);
		m_shaders ~= CreateShader(LoadShader(fileName ~ ".fs"), GL_FRAGMENT_SHADER);
	
		if(UseShaderTypes & USE_GEOMETRY_SHADER)
		{
			m_shaders ~= CreateShader(LoadShader(fileName ~ ".gs"), GL_GEOMETRY_SHADER);
		}
	
		foreach(GLuint s; m_shaders)
		{		
			glAttachShader(m_program, s);
		}
	
		glBindAttribLocation(m_program, 0, "position");
		glBindAttribLocation(m_program, 1, "texCoord");

		glLinkProgram(m_program);
		CheckShaderError(m_program, GL_LINK_STATUS, true, "Error linking shader program");
	
		glValidateProgram(m_program);
		CheckShaderError(m_program, GL_LINK_STATUS, true, "Invalid shader program");
	}
	
	public GLint Bind()
	{
		glUseProgram(m_program);
		return m_program;
	}
	
	public GLint ProgramLocation()
	{
		return m_program;
	}

	GLuint CreateShader(const string text, uint type)
	{
	    GLuint shader = glCreateShader(type);
	
	    if(shader == 0)
	    {
			writeln("error compiling shader of type: ", type);
	    }
	
	    const GLchar* p = &text[0];
	    GLint lengths = cast(int)(text.length);
	
	    glShaderSource(shader, 1, &p, &lengths);
	    glCompileShader(shader);
	
	    CheckShaderError(shader, GL_COMPILE_STATUS, false, "Error compiling shader!");
	
	    return shader;
	}
	
	void CheckShaderError(GLuint shader, GLuint flag, bool isProgram, const string errorMessage)
	{
	    GLint success = 0;
	    GLchar[1024] error;
	
	    if(isProgram)
	    {
	        glGetProgramiv(shader, flag, &success);
	    }
	    else
	    {
	        glGetShaderiv(shader, flag, &success);
	    }
	
	    if(success == GL_FALSE)
	    {
	        if(isProgram)
	        {
	            glGetProgramInfoLog(shader, cast(int)(error).sizeof, cast(int*)(0), &error[0]);
	        }
	        else
	        {
	            glGetShaderInfoLog(shader, cast(int)(error).sizeof, cast(int*)(0), &error[0]);
	        }
	
	        writeln(errorMessage, ": ", error);
	    }
	}
	
	string LoadShader(const string fileName)
	{
	    string output;
	
		if(exists(fileName))
		{
			
			output = cast(string)read(fileName);
		}
	
	    return output;
	}
}
