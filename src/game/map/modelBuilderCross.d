import derelict.opengl3.gl;
import gl3n.linalg;

import map;

import modelBuilder;

import hexes;
import mapModel;

import util.coordVectors;
import util.values;

private immutable vec3[] crossVertices = [
	// side 1
	vec3(-0.57735027f, 1.0f,  0.0f),
	vec3(0.57735027f,  1.0f,  0.0f),
	vec3(-0.57735027f, 0.0f,  0.0f),
	vec3(0.57735027f,  0.0f,  0.0f),
	//vec3(-0.288675,    1.0f, -0.5f),
	//vec3(0.288675,     1.0f,  0.5f),

	// bottom 
	//vec3(-0.288675,    0.0f, -0.5f),
	//vec3(0.288675, 	   0.0f,  0.5f),
	vec3(0.288675,     1.0f, -0.5f),
	vec3(-0.288675,    1.0f,  0.5f),
	vec3(0.288675,     0.0f, -0.5f),
	vec3(-0.288675,    0.0f,  0.5f)
];

private immutable vec2[] texPos = [
	vec2(0.0f, 0.0f),
	vec2(16f/512f, 0.0f),
	vec2(0.0f, 32f/512f),
	vec2(16f/512f, 32f/512f),
];

class ModelBuilderCross : ModelBuilder
{
	Map mWorldMap;

	this(ref Map map)
	{
		mWorldMap = map;
	}

	public override void AppendModel(vec_chunk c, int x, int y, int z, ref ChunkModel model)
	{
		int blockNum = mWorldMap.getBlockRelative(c, x, y, z);

		addSide!0(model, x, y, z, HexTypes[blockNum].GetTexture(0));
		addSide!4(model, x, y, z, HexTypes[blockNum].GetTexture(0));
	}

	void addSide(int side)(ref ChunkModel model, int x, int y, int z, int texNum)
	{
		int offset = cast(int)model.positions.length;

		vec2 texOff = vec2((16*texNum)/512f, 0.0f);

		for(int i = side, j = 0; i < side + 4; i++, j++)
		{
			vec3 temp = (crossVertices[i] + x*hex_dx + y*hex_dy + z*hex_dz);
			model.positions ~= [temp.x, temp.y, temp.z];

			model.texCoords ~= [(texPos[j] + texOff).x, (texPos[j] + texOff).y];
		}

		model.indices ~= [[offset+0,offset+1,offset+3],[offset+0,offset+3,offset+2],
				[offset+0,offset+3,offset+1],[offset+0,offset+2,offset+3]];
	}
}







