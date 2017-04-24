#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
varying vec4 texCoord;

void kore() {
	vec4 texcolor = texture2D(tex, texCoord.xy) ;
	vec4 maskColor= texture2D(tex, texCoord.zw);
	texcolor*=maskColor.w;
	
	gl_FragColor = texcolor;
}
