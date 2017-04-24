#version 100

attribute vec2 vertexPosition;
attribute vec2 texPosition;
attribute vec4 colorMul;
attribute vec4 colorAdd;

uniform mat4 projectionMatrix;
varying vec2 texCoord;
varying vec4 _colorMul;
varying vec4 _colorAdd;


void kore() {
	gl_Position =  projectionMatrix*vec4(vertexPosition.xy,0.0, 1.0) ;
	texCoord = texPosition;
	_colorMul = colorMul;
	_colorAdd = colorAdd;

}
