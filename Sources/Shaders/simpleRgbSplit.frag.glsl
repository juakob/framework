#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
varying vec2 texCoord;

void kore() {
	vec4 c1 = texture2D( tex, texCoord);
	vec4 finalColor=vec4( c1.x, c1.y, c1.z, c1.w);
	gl_FragColor = finalColor;
}
