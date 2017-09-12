module util.values;

immutable double INPUT_DT = 1.0 / 60.0;
immutable double PHYSICS_DT = 1.0 / 20.0;

immutable double SPEED_TRUE = 5.0;
immutable double SPEED = SPEED_TRUE * PHYSICS_DT;

immutable int CHUNK_SIZE = 16;
