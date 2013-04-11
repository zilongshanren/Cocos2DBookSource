#ifdef GL_ES
precision mediump float;
#endif


varying vec2 v_texCoord;


// Scene buffer
uniform sampler2D u_texture;


uniform float vx_offset;
uniform float rt_w; 
uniform float rt_h;
//低像素的宽度和高度  chang this two value to tweak
const float pixel_w = 15.0;
const float pixel_h = 15.0;
void main()
{
    vec2 uv = v_texCoord;
    
    vec3 tc = vec3(1.0, 0.0, 0.0);
    if (uv.x < (vx_offset-0.005))
    {
        float dx = pixel_w * (1./rt_w);
        float dy = pixel_h * (1./rt_h);
        vec2 coord = vec2(dx * floor(uv.x/dx),
                          dy * floor(uv.y/dy));
        tc = texture2D(u_texture, coord).rgb;
    }
    else if (uv.x >= (vx_offset + 0.005))
    {
        tc = texture2D(u_texture, uv).rgb;
    }
	gl_FragColor = vec4(tc, 1.0);
}