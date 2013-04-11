#ifdef GL_ES
precision mediump float;
#endif


varying vec2 v_texCoord;


// Scene buffer
uniform sampler2D u_texture;

// Currently not used in this demo!
uniform float time;

// width of the current render target
uniform float rt_w;
//  height of the current render target
uniform float rt_h;

uniform float angle;


// Swirl effect parameters
const float radius = 160.0;
const vec2 center = vec2(240.0, 160.0);

vec4 PostFX(sampler2D tex, vec2 uv, float time)
{
    vec2 texSize = vec2(rt_w, rt_h);
    vec2 tc = uv * texSize;
    tc -= center;
    float dist = length(tc);
    if (dist < radius)
    {
        float percent = (radius - dist) / radius;
        float theta = percent * percent * angle * 8.0;
        float s = sin(theta);
        float c = cos(theta);
        tc = vec2(dot(tc, vec2(c, -s)), dot(tc, vec2(s, c)));
    }
    tc += center;
    vec3 color = texture2D(u_texture, tc / texSize).rgb;
    return vec4(color, 1.0);
}

void main (void)
{
    vec2 uv = v_texCoord;
    gl_FragColor = PostFX(u_texture, uv, time);
}