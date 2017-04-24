#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
varying vec2 texCoord;
varying vec4 _colorMul;
varying vec4 _colorAdd;

void kore() {
	vec4 texcolor = texture2D(tex, texCoord)*_colorMul;
	texcolor.xyz*=_colorMul.w;
	texcolor+=_colorAdd*texcolor.w;
	
	gl_FragColor = texcolor;
}
