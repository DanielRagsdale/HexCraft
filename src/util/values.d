module util.values;

import gl3n.linalg;

immutable double INPUT_DT = 1.0 / 60.0;
immutable double PHYSICS_DT = 1.0 / 20.0;

immutable double SPEED_TRUE = 5.0;
immutable double SPEED = SPEED_TRUE * PHYSICS_DT;

immutable int CHUNK_SIZE = 16;

immutable vec3 hex_dx = vec3(0.8660254,0,0.5);
immutable vec3 hex_dy = vec3(0, 1, 0);
immutable vec3 hex_dz = vec3(0,0,1);

immutable vec3[] hex_dn = [
	-hex_dx,
	-hex_dz,
	 hex_dx - hex_dz,
	 hex_dx,
	 hex_dz,
	-hex_dx + hex_dz
];

immutable mat3 matrixToSquare = mat3(vec3(0.8660254,0,0.5), vec3(0, 1, 0), vec3(0,0,1));
immutable mat3 matrixToHex = matrixToSquare.inverse();
