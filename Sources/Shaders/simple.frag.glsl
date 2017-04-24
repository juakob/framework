#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
varying vec2 texCoord;

void kore() {
	vec4 texcolor = texture2D(tex, texCoord) ;
	gl_FragColor = texcolor;
}
