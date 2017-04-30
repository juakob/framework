#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
in vec2 texCoord;
out vec4 FragColor;

void kore() {
	vec4 c1 = texture( tex, texCoord);
	vec4 finalColor=vec4( c1.x, c1.y, c1.z, c1.w);
	FragColor = finalColor;
}
