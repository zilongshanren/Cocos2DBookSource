//
//  HelloWorldLayer.h
//  PhysicShootingGame
//
//  Created by guanghui on 8/4/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"


// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    
    b2Body  *_groundBody;
    b2Body *_armBody;
    
    b2MouseJoint *_mouseJoint; //用来拖拽手臂用的
    
    b2Body *_destBody;
    b2PrismaticJoint *_destJoint;
    
    b2Body *_scoreBody; //sensor
    
    MyContactListener *_contactListener;
    
    CCLabelTTF *_scoreLabel;
    int     _score;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
