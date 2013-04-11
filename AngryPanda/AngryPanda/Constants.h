//
//  Constants.h
//  AngryPanda
//
//  Created by eseedo on 10/23/12.
//  Copyright (c) 2012 eseedo. All rights reserved.
//

#ifndef AngryPanda_Constants_h
#define AngryPanda_Constants_h

//判断设备类型

#define  kDeviceTypeNotIphone5 0
#define  kDeviceTypeIphone5OrNewTouch 1

#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)

//Box2D世界与Cocos2D世界的坐标切换

#define PTM_RATIO 32


//精灵对象在层中的z-order（显示层级）值

#define zOrderClouds -300
#define zOrderParticles -299
#define zOrderHills -298
#define zOrderFloor -290
#define zOrderScore -285

#define zOrderWhiteDots -205

#define zOrderStrapBack -202
#define zOrderPlatform -201
#define zOrderPandas -200
#define zOrderStack -199


#define zOrderSlingShotFront -179
#define zOrderStrapFront -178

#define zOrderVisualEffect 50
#define zOrderPointScore 100

#define zOrderChapterBg -100
#define zOrderLevelBg   -100
#define zOrderLevelText  10


//标识

#define tagForWhiteDotsEvenNumberedTurn 1000
#define tagForWhiteDotsOddNumberedTurn 2000

//物体形状的创建方法

#define useShapeOfSourceImage 0  // 用于方形和矩形

#define useTriangle 1 //图片左下角，右下角和中心点的顶点值


#define useTrapezoid 3 //图片左下角，右下角，顶部1/4和3/4处的顶点值（

#define useDiameterOfImageForCircle 4  //用于完美的圆形


#define customCoordinates 100  //使用类似Vertex Helper Pro等工具获取定制顶点坐标

// 在定义定制的顶点坐标时，必须按逆时针顺序进行，且最多只能有8个顶点，且必须形成凸面。)


#define breakEffectNone 0
#define breakEffectSmokePuffs 1
#define breakEffectExplosion 2



#endif
