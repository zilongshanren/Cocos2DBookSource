attribute vec4 a_position;
attribute vec2 a_texCoord;

uniform float u_scale;
uniform vec2 u_move;
uniform float u_rotate; //角度

#ifdef GL_ES
varying mediump vec2 v_texCoord;
#else
varying vec2 v_texCoord;
#endif

const float PI = 3.141592653;

void main()
{
    //不同直接操作a_position，而需要定义一个中转变量vec4 a来操作顶点坐标
    vec4 a = a_position;
    //2d中点的缩放
    a.x = a.x * u_scale;
    a.y = a.y * u_scale;
    
    //2d中点的平移
    a.x = a.x +  + u_move.x;
    a.y = a.y + u_move.y;
    
    //2d中的点中(x,y)按逆时针旋转θ弧度,可使用下面的公式:
    //x′ = x * cos θ - y * sin θ; y′ = y * cos θ + x * sin θ
    a.x = a.x * cos(u_rotate *  PI / 180.0 ) - a.y * sin(u_rotate * PI / 180.0);
    a.y = a.y * cos(u_rotate * PI/ 180.0) + a.x * sin(u_rotate * PI / 180.0);
    
    gl_Position = CC_MVPMatrix * a;
    v_texCoord = a_texCoord;
}
