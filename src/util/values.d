module util.values;

import gl3n.linalg;

import util.coordVectors;

immutable double INPUT_DT = 1.0 / 60.0;
immutable double PHYSICS_DT = 1.0 / 20.0;

immutable double SPEED_TRUE = 4.0;
immutable double SPEED = SPEED_TRUE * PHYSICS_DT;

immutable int CHUNK_SIZE = 16;

immutable vec3 hex_dx = vec3(0.8660254,0,0.5);
immutable vec3 hex_dy = vec3(0, 1, 0);
immutable vec3 hex_dz = vec3(0,0,1);

immutable vec_square square_dx = vec_square(0.8660254,0,0.5);
immutable vec_square square_dy = vec_square(0, 1, 0);
immutable vec_square square_dz = vec_square(0,0,1);

immutable vec_square[] square_dn = [
	-square_dx,
	-square_dz,
	 square_dx - square_dz,
	 square_dx,
	 square_dz,
	-square_dx + square_dz,
	 square_dy,
	-square_dy
];

immutable vec_block[] block_dn = [
	vec_block(-1,  0,  0),
	vec_block( 0,  0, -1),
	vec_block( 1,  0, -1),
	vec_block( 1,  0,  0),
	vec_block( 0,  0,  1),
	vec_block(-1,  0,  1),
	vec_block( 0,  1,  0),
	vec_block( 0, -1,  0),
];

immutable vec_chunk[] chunk_dn = [
	vec_chunk(-1,  0,  0),
	vec_chunk( 0,  0, -1),
	vec_chunk( 1,  0, -1),
	vec_chunk( 1,  0,  0),
	vec_chunk( 0,  0,  1),
	vec_chunk(-1,  0,  1),
	vec_chunk( 0,  1,  0),
	vec_chunk( 0, -1,  0),
];

immutable mat3 matrixToSquare = mat3(vec3(0.8660254,0,0.5), vec3(0, 1, 0), vec3(0,0,1));
immutable mat3 matrixToHex = matrixToSquare.inverse();
