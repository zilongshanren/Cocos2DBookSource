//
//  HelloWorldLayer.h
//  MarioDemo
//
//  Created by guanghui qu on 7/11/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "HUDLayer.h"

#import "MyContactListener.h"
#import "CoinQueryCallback.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    
    CCTMXTiledMap *_gameMap;
    CCSprite    *_player;
    b2Body      *_playerBody;
    
    BOOL    _isOnGround;
    float   _jumpCounter;
    BOOL    _isJumpPressed;  //是否触摸屏幕
    float   _lastVelocity;
    
    MyContactListener *_contactListener;
    
    HUDLayer *_hudLayer;
    
    int     _totalScore;
        
    BOOL        _isCrazy; //能够3秒种吸收80个像素内的所有金币
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
