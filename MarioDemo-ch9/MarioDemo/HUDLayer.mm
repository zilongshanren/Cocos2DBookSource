//
//  HUDLayer.m
//  MarioDemo
//
//  Created by guanghui on 8/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HUDLayer.h"


@implementation HUDLayer
@synthesize scoreLabel = _scoreLabel;
@synthesize gameOverLabel = _gameOverLabel;

+(id) HUDLayerWithSprite:(CCSprite *)sprite body:(b2Body *)body{
    return [[[self alloc] initWithSprite:sprite body:body] autorelease];
}

-(id) initWithSprite:(CCSprite *)sprite body:(b2Body *)body{
    if (self = [super init]) {
        _player = sprite;
        _playerBody = body;
        
        [self initJoystick];
        
        [self initScoreLabel];
        [self initGameOverLabel];
    }
    return self;
}

-(void) initScoreLabel{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    _scoreLabel = [CCLabelTTF labelWithString:@"00" fontName:@"Arial" fontSize:20];
    _scoreLabel.position = ccp(winSize.width / 2, winSize.height - _scoreLabel.contentSize.height);
    [self addChild:_scoreLabel];
}
-(void) initGameOverLabel{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    _gameOverLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:40];
    _gameOverLabel.visible = NO;
    _gameOverLabel.scale = 0.0;
    _gameOverLabel.position = ccp(winSize.width/2,winSize.height/2);
    [self addChild:_gameOverLabel];
}
-(void) initJoystick{
    
    ZJoystick *joystick		 = [ZJoystick joystickNormalSpriteFile:@"JoystickContainer_norm.png"
                                             selectedSpriteFile:@"JoystickContainer_trans.png"
                                           controllerSpriteFile:@"Joystick_norm.png"];
    joystick.position          = ccp(joystick.contentSize.width/2 + 10,
                                     joystick.contentSize.height/2 + 10);
    joystick.delegate          = self;    //Joystick Delegate
    joystick.controlledObject  = _player;
    joystick.speedRatio        = 2.0f;
    joystick.joystickRadius    = 30.0f;   //added in v1.2
    joystick.joystickTag       = 999;
    [self addChild:joystick];
        
}


#pragma mark - zJoystick delegate methods
-(void)joystickControlBegan {
    //	CCLOG(@"Joystick Began Controlling");
	
}

-(void)joystickControlMoved {
    //	CCLOG(@"Joystick Move Controlling");
	
}

-(void)joystickControlEnded {
    //	CCLOG(@"Joystick End Controlling");
    b2Vec2 v = _playerBody->GetLinearVelocity();
    _playerBody->SetLinearVelocity(b2Vec2(0,v.y));
	
}

-(void)joystickControlDidUpdate:(id)joystick toXSpeedRatio:(CGFloat)xSpeedRatio toYSpeedRatio:(CGFloat)ySpeedRatio{
    
    ZJoystick *zJoystick = (ZJoystick *)joystick;
    if (zJoystick.joystickTag == 999) {
        if (xSpeedRatio > 0.6) {
            _playerBody->ApplyForce(b2Vec2(25,0), _playerBody->GetLocalCenter());
        }else if(xSpeedRatio < -0.6){
            _playerBody->ApplyForce(b2Vec2(-25,0), _playerBody->GetLocalCenter());

        }
    }
}
@end
