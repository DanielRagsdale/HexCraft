import derelict.opengl3.gl;

import std.stdio;

class Mesh
{
        enum
        {
            POSITION_VB,
            TEXCOORD_VB,
            INDEX_VB,

            NUM_BUFFERS = 3
        };

        GLuint m_vertexArrayObject;
        GLuint[NUM_BUFFERS] m_vertexArrayBuffers;
        uint m_drawCount;
    
    
    this(GLfloat* vertices, GLfloat* texCoords, uint numVertices, GLint* indices, uint numIndices)
    {    
	    m_drawCount = numIndices;
	
	    glGenVertexArrays(1, &m_vertexArrayObject);
	    glBindVertexArray(m_vertexArrayObject);
	
	    glGenBuffers(NUM_BUFFERS, &m_vertexArrayBuffers[0]);

	    //Bind and push the vertex data
            glBindBuffer(GL_ARRAY_BUFFER, m_vertexArrayBuffers[POSITION_VB]);
            glBufferData(GL_ARRAY_BUFFER, float.sizeof * numVertices * 3, vertices, GL_STATIC_DRAW);

            glEnableVertexAttribArray(0);
            glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, null);

        //Bind and push the texture data
            glBindBuffer(GL_ARRAY_BUFFER, m_vertexArrayBuffers[TEXCOORD_VB]);
            glBufferData(GL_ARRAY_BUFFER, float.sizeof * numVertices * 2, texCoords, GL_STATIC_DRAW);

            glEnableVertexAttribArray(1);
            glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, null);

		//Bind and push the index data
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_vertexArrayBuffers[INDEX_VB]);
            glBufferData(GL_ELEMENT_ARRAY_BUFFER, int.sizeof * numIndices, indices, GL_STATIC_DRAW);

	
	    glBindVertexArray(0);
    }

	public void Draw()
	{
	    glBindVertexArray(m_vertexArrayObject);
	
	    glDrawElements(GL_TRIANGLES, m_drawCount, GL_UNSIGNED_INT, null);

	    glBindVertexArray(0);
	}

	~this()
	{
	    glDeleteBuffers(NUM_BUFFERS, &m_vertexArrayBuffers[0]);
	    glDeleteVertexArrays(1, &m_vertexArrayObject); 
	}
}
