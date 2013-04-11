#ifdef GL_ES
precision mediump float;
#endif


varying vec2 v_texCoord;


// Scene buffer
uniform sampler2D u_texture;
uniform sampler2D noiseTex;
uniform sampler2D maskTex;
uniform float elapsedTime; // seconds
const float luminanceThreshold = 0.2; // 0.2
const float colorAmplification = 4.0; // 4.0
const float effectCoverage = 1.0; // 0.5就是mask一半图片

void main()
{
    vec4 finalColor;
    // Set effectCoverage to 1.0 for normal use.
    if (v_texCoord.x < effectCoverage)
    {
        vec2 uv;
        uv.x = 0.4 * sin(elapsedTime * 50.0);
        uv.y = 0.4 * cos(elapsedTime * 50.0);
        
        float m = texture2D(maskTex, v_texCoord).r;
        
        vec3 n = texture2D(noiseTex,
                           (v_texCoord * 3.5) + uv).rgb;
        
        vec3 c = texture2D(u_texture, v_texCoord
                           + (n.xy * 0.005)).rgb;
        
        float lum = dot(vec3(0.30, 0.59, 0.11), c);
        if (lum < luminanceThreshold)
            c *= colorAmplification;
        
        vec3 visionColor = vec3(0.1, 0.95, 0.2);
        finalColor.rgb = (c + (n*0.2)) * visionColor * m;
    }
    else
    {
        finalColor = texture2D(u_texture,
                               v_texCoord);
    }
    gl_FragColor.rgb = finalColor.rgb;
    gl_FragColor.a = 1.0;}