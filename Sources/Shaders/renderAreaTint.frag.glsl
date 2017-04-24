#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
varying vec2 texCoord;

void kore() {
	vec4 texcolor = texture2D(tex, texCoord) ;
	vec4 col=vec4(texcolor.x+0.1,texcolor.y,texcolor.z,texcolor.w+0.1);

	gl_FragColor = col;
}
