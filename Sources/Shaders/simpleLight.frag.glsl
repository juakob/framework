#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
uniform sampler2D tex2;
varying vec2 texCoord;

void kore() {
	vec4 light = texture2D(tex, texCoord) ;
	vec4 texcolor = texture2D(tex2, texCoord) ;
	texcolor.xyz=texcolor.xyz*light.xyz;
	gl_FragColor = texcolor;
}
