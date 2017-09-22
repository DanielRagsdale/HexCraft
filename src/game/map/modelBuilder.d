import derelict.opengl3.gl;
import gl3n.linalg;

import mapModel;

import util.coordVectors;

abstract class ModelBuilder
{
	abstract void AppendModel(vec_chunk chunkPos, int relX, int relY, int relZ, ref ChunkModel model);
}
