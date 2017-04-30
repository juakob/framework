#version 450


//uniform float time;
const float A = 0.03;
const float B = 200.0;
const float C = 5.0;

const float D = 0.003;
const float E = 13.0;
const float F = 9.0;


uniform sampler2D tex;
in vec2 texCoord;
out vec4 FragColor;

void kore() {
	float x =  D * sin(E * texCoord.x) * sin(F * 0.1)*texCoord.y;
	float y =  A * sin(B * texCoord.y) * sin(C * 0.1)*texCoord.y;
	
	vec2 c = vec2(texCoord.x + x, texCoord.y + y);
	vec4 diffuse_color =  texture(tex, c);
	FragColor = diffuse_color;
}
