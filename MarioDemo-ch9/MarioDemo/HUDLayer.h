//
//  HUDLayer.h
//  MarioDemo
//
//  Created by guanghui on 8/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ZJoystick.h"
#import "Box2D/Box2D.h"


@interface HUDLayer : CCLayer<ZJoystickDelegate> {
    CCSprite *_player;
    b2Body *_playerBody;
    
    CCLabelTTF  *_scoreLabel;
    
    CCLabelTTF *_gameOverLabel;
}
@property(nonatomic,assign)CCLabelTTF *scoreLabel;
@property(nonatomic,assign)CCLabelTTF *gameOverLabel;

-(void) initScoreLabel;
-(void) initGameOverLabel;


+(id) HUDLayerWithSprite:(CCSprite*)sprite body:(b2Body*)body;
-(id) initWithSprite:(CCSprite*)sprite body:(b2Body*)body;

-(void) initJoystick;


@end
