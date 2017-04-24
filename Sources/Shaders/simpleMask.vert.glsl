#version 100

attribute vec2 vertexPosition;
attribute vec4 texPosition;

uniform mat4 projectionMatrix;
varying vec4 texCoord;


void kore() {
	gl_Position =  projectionMatrix*vec4(vertexPosition.xy,0.0, 1.0) ;
	texCoord = texPosition;

}
