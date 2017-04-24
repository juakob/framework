#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
varying vec3 texCoord;

void kore() {
	vec4 texcolor = texture2D(tex, texCoord.xy)*texCoord.z;
	gl_FragColor = texcolor;
}
