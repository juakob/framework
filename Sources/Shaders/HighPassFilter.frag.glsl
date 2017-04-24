//-------------------------------
//BrightBloom_ps20.glsl
// High-pass filter for obtaining lumminance
// We use an aproximation formula that is pretty fast:
//   f(x) = ( -3 * ( x - 1 )^2 + 1 ) * 2
//   Color += Grayscale( f(Color) ) + 0.6


precision mediump float;


uniform sampler2D tex;
varying vec2 texCoord;

void main()
{
    vec4 col;
    vec4 bright4;
    float bright;
    
    col = texture2D( tex, texCoord);
    col -=1.00000;
    bright4 = -6.00000 * col * col + 2.00000;
    bright = dot( bright4, vec4( 0.333333, 0.333333, 0.333333, 0.000000) );
    col += (bright + 0.600000);
	
    gl_FragColor = col;
}