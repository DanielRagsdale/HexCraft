module util.obj;

import std.conv;
import std.stdio;
import std.array;
import std.algorithm;

import gl3n.linalg;

alias vec3 = Vector!(float, 3);


class Model
{
    float[3][] verts;

    float[2][] texCoords;

    public int[] indices;

    this(float[3][] vertexData, float[2][] texCoordsData, int[] indexData)
    {
        this.verts = vertexData;
        this.texCoords = texCoordsData;
        this.indices = indexData;
    }

    /**
    * Returns the x, y, z coordinates for a vertex
    */
    public float[] vert(int index)
    {
        return verts[index];
    }

    /**
    * Returns the number of vertices
    */
    public uint nVerts()
    {
        return cast (uint)verts.length;
    }

    /**
    * Returns the index at the given position
    */
    public int index(int indexNumber)
    {
        return indices[indexNumber];
    }

    /**
    * Returns the number of indices
    */
    public uint nIndices()
    {
        return cast(uint) indices.length;
    }
}


/**
* Simple OBJ loader.
*/

//float[3][] verts;
//
//float[2][] texCoords;
//
//public int[] faces;

Model ImportOBJ(string filename)
{
    float[3][] tmpVerts;
    float[2][] tmpTexCoords;
    float[3][] tmpNormals;

    OBJIndex[] tmpIndices;

    auto f = File(filename, "r");

    foreach (line; f.byLine)
    {
        if (line.startsWith("v "))
        {
            float[3] v;
            v = line[2..$].splitter.map!(to!float).array;

            tmpVerts ~= v;
        }
        else if (line.startsWith("vt "))
        {
            float[] v;
            v = line[3..$].splitter.map!(to!float).array;

            float[2] vt = [v[0], v[1]];

            tmpTexCoords ~= vt;
        }
        else if (line.startsWith("f "))
        {
            OBJIndex tmpIndex;

            foreach (pol; line[2..$].splitter) {
				try
				{
					int rawVI = cast(int)(to!int(pol.splitter("/").array[0]));
					if(rawVI < 0)
					{
                		tmpIndex.vertexIndex = tmpVerts.length + rawVI;
					}
					else
					{
                		tmpIndex.vertexIndex = rawVI - 1;
					}
					
					int rawTI = cast(int)(to!int(pol.splitter("/").array[1]));
					if(rawTI < 0)
					{
						tmpIndex.texCoordIndex = tmpTexCoords.length + rawTI;
					}
					else
					{
                		tmpIndex.texCoordIndex = rawTI - 1;
					}
					
					int rawNI = cast(int)(to!int(pol.splitter("/").array[2]));
					if(rawNI < 0)
					{
                		tmpIndex.normalIndex = tmpNormals.length + rawNI;
					}
					else
					{
						tmpIndex.normalIndex = rawNI - 1;
					}

                	tmpIndices ~= tmpIndex;
				}
				catch(Exception e)
				{
					stderr.writeln(pol);
				}

            }
        }
    }
    stderr.writefln("%s: v# %d f# %d", filename, tmpVerts.length, tmpIndices.length);

    int[OBJIndex] associations;

    float[3][] outVerts;
    float[2][] outTexCoords;
    float[3][] outNormals;

    int[] outIndices;

    int associationCounter = 0;

    for(int i = 0; i < tmpIndices.length; i++)
    {
        int outIndex;

        int* p = (tmpIndices[i] in associations);

        if(p is null)
        {
            associations[tmpIndices[i]] = associationCounter;
			
            outVerts ~= tmpVerts[tmpIndices[i].vertexIndex];
            outTexCoords ~= tmpTexCoords[tmpIndices[i].texCoordIndex];
            //outNormals[associationCounter] = tmpNormals[tmpIndices[i].normalIndex];

            outIndex = associationCounter++;
        }
        else
        {
            outIndex = *p;
        }

        outIndices ~= outIndex;
    }



    return new Model(outVerts, outTexCoords, outIndices);
}

/**
* Stores information about the three different types of indices used in OBJ
*/
private struct OBJIndex
{
    public long vertexIndex;
    public long texCoordIndex;
    public long normalIndex;

//    override bool opEquals(Object o)
//    {
//        OBJIndex other = cast(OBJIndex) o;
//
//        return other && vertexIndex == other.vertexIndex && texCoordIndex == other.texCoordIndex
//                && normalIndex == other.normalIndex;
//    }
}
