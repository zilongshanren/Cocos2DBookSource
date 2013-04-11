#ifdef GL_ES
precision mediump float;
#endif


varying vec2 v_texCoord;

uniform sampler2D u_texture;
uniform vec4 u_left_color;
uniform vec4 u_right_color;

void main()
{
    //注意运算全部要是浮点型
    vec2 v_tex = v_texCoord;
    vec4 color = texture2D(u_texture,v_tex);
    
    vec4 new_color = color;

    //左边是u_left_color,右边是u_right_color
    if(v_tex.x <= 0.5){
        new_color *= u_left_color;
    }
    
    if(v_tex.x >= 0.5){
        new_color *= u_right_color;
    }
    
    
    //gl_FragColor = vec4(1.0,0,0,1.0);
    gl_FragColor = new_color;
}