attribute vec2 vertexPosition;
attribute vec2 texPosition;
 
varying vec2 v_texCoord;
varying vec2 v_blurCoord0;
varying vec2 v_blurCoord1;
varying vec2 v_blurCoord2;
varying vec2 v_blurCoord3;
varying vec2 v_blurCoord4;
varying vec2 v_blurCoord5;



uniform mat4 projectionMatrix;
 
void main()
{
    gl_Position =  projectionMatrix*vec4(vertexPosition.xy,0.0, 1.0) ;
	v_texCoord = texPosition.xy;
    v_blurCoord0= texPosition.xy + vec2(-0.00018, 0.0);
	v_blurCoord1 = texPosition.xy + vec2(-0.0009, 0.0);
    v_blurCoord2 = texPosition.xy+ vec2(-0.0035, 0.0);
    v_blurCoord3 = texPosition.xy+ vec2(0.0035, 0.0);
	v_blurCoord4 = texPosition.xy+ vec2(0.0009, 0.0);
	v_blurCoord5 = texPosition.xy+ vec2(0.00018, 0.0);


}