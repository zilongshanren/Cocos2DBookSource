//
//  GamePause.m
//  AngryPanda
//
//  Created by Ricky Wang on 3/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePause.h"
#import "CCTouchDispatcher.h"
#import "SceneManager.h"
#import "GameSounds.h"
#import "SimpleAudioEngine.h"
#import "GameData.h"
#import "Constants.h"


@implementation GamePause

@synthesize delegate;

+ (id) layerWithColor:(ccColor4B)color delegate:(id)_delegate

{
    
    return [[[self alloc] initWithColor:color delegate:_delegate] autorelease];
    
}

- (id) initWithColor:(ccColor4B)c delegate:(id)_delegate {
    
    self = [super initWithColor:c];
    
    if (self != nil) {
        
        
        delegate = _delegate;
        
        [self pauseDelegate];
        
        [self getDeviceType];
        [self addBg];
        
        [self createPausedMenu];


    }
    
    return self;
    
}

#pragma mark 添加基本视觉元素

//获取设备类型
-(void)getDeviceType{
    
    if([GameData sharedData].isDeviceIphone5 == NO){
        deviceType = kDeviceTypeNotIphone5;
    }else{
        deviceType = kDeviceTypeIphone5OrNewTouch;
    }
}


//添加背景


-(void)addBg{
    
    screenSize = [CCDirector sharedDirector].winSize;
    
    if(deviceType == kDeviceTypeNotIphone5){
        bg = [CCSprite spriteWithFile:@"bg_pause.png"];
        bg.position = ccp(screenSize.width/2,screenSize.height/2);
        [self addChild:bg z:-1];
    }else if(deviceType == kDeviceTypeIphone5OrNewTouch){
        
        bg = [CCSprite spriteWithFile:@"bg_pause-iphone5.png"];
        bg.position = ccp(screenSize.width/2,screenSize.height/2);
        [self addChild:bg z:-1];
    }
}


-(void)createPausedMenu{
//创建暂停画面

        CGSize size = [CCDirector sharedDirector].winSize;



        CCMenuItemImage *buttonPlay = [CCMenuItemImage itemWithNormalImage:@"button_play.png" selectedImage:@"button_play.png" target:self selector:@selector(resumeCurrentLevel)];
        CCMenuItemImage *buttonMenu = [CCMenuItemImage itemWithNormalImage:@"button_menu.png" selectedImage:@"button_menu.png" target:self selector:@selector(goLevelSelection)];
        CCMenuItemImage *buttonReplay = [CCMenuItemImage itemWithNormalImage:@"button_replay.png" selectedImage:@"button_replay.png" target:self selector:@selector(replayCurretLevel)];

        buttonPlay.position = ccp(size.width*0.35,size.height/2);
        buttonMenu.position = ccp(size.width*0.15,size.height*0.3);
        buttonReplay.position = ccp(size.width*0.15,size.height*0.7);

        CCMenu *menu = [CCMenu menuWithItems:buttonMenu,buttonPlay,buttonReplay, nil];

        menu.position = CGPointZero;
        [self addChild:menu z:1];
    
}


-(void)resumeCurrentLevel{
    
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(doResume:)] ,nil]];
}

-(void)replayCurretLevel{
    
        [SceneManager goGameScene];
    
}


-(void)goLevelSelection{
    
        [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
        [SceneManager goLevelSelect];
}



-(void)pauseDelegate

{
    
        if([delegate respondsToSelector:@selector(pauseLayerDidPause)])
        
            [delegate pauseLayerDidPause];
    
            [delegate onExit];
    
            [delegate.parent addChild:self z:10];
    
}

-(void)doResume: (id)sender

{
    
        [delegate onEnter];
    
        if([delegate respondsToSelector:@selector(pauseLayerDidUnpause)])
        
            [delegate pauseLayerDidUnpause];
    
            [self.parent removeChild:self cleanup:YES];
    
}

-(void)dealloc

{
    
        [super dealloc];
    
}

@end
