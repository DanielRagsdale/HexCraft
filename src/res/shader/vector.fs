#version 150

in vec3 color1;
in vec4 position1;

out vec4 outColor;

//TODO Come up with a more efficient algorithm for marking borders
void main()
{

//    if((mod(position1.x + 0.0001, 0.1) < 0.005 && mod(position1.y + 0.0001, 0.1) < 0.005) ||
//            (mod(position1.x + 0.0001, 0.1) < 0.005 && mod(position1.z + 0.0001, 0.1) < 0.005) ||
//            (mod(position1.y + 0.0001, 0.1) < 0.005 && mod(position1.z + 0.0001, 0.1) < 0.005))
//    {
//        outColor = vec4(color1, 0.0) * 0.9;
//    }
//    else
//    {
//
//    }

    outColor = vec4(color1, 0.0);

    float z = gl_FragCoord.z * 2.0 - 1.0;

    float linearDepth = (2.0 * 0.1 * 500) / (500 + 0.1 - z * (500 - 0.1));

//    outColor = vec4(vec3(linearDepth / 30), 1.0f);

}
