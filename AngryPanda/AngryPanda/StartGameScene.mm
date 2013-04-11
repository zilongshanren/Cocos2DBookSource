//
//  StartGameScene.m
//  AngryPanda
//
//  Created by eseedo on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartGameScene.h"
#import "SimpleAudioEngine.h"
#import "About.h"
#import "SceneManager.h"
#import "GameData.h"

#import "Constants.h"


@implementation StartGameScene



+(id)scene{
    
    CCScene *scene =[CCScene node];
    StartGameScene *layer = [StartGameScene node];
    [scene addChild:layer];
    return scene;
    
}

#pragma mark 添加基本视觉元素

//判断设备是否属于Iphone或最新ipod touch
//获取设备类型
-(void)getDeviceType{
    
    if([GameData sharedData].isDeviceIphone5 == NO){
        deviceType = kDeviceTypeNotIphone5;
    }else{
        deviceType = kDeviceTypeIphone5OrNewTouch;
    }
}


//添加游戏菜单项
-(void)addPlayItem{
    
    screenSize = [CCDirector sharedDirector].winSize;
    
    
    playItem = [CCMenuItemImage itemWithNormalImage:@"button_begin.png" selectedImage:nil target:self selector:@selector(startGame)];
    playItem.scale = 0.5;
    playItem.position = ccp(screenSize.width*0.52,screenSize.height*0.5);
    [playItem runAction:[CCScaleTo actionWithDuration:2.0f scale:0.9]];
    
    
    CCMenu *menu =[CCMenu menuWithItems:playItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
}

//添加about菜单项
-(void)addAboutItem{
    screenSize = [CCDirector sharedDirector].winSize;
    
    aboutItem = [CCMenuItemImage itemWithNormalImage:@"about.png" selectedImage:@"about.png" target:self selector:@selector(about)];
    aboutItem.position =aboutMenuLocation;
    CCMenu *menu =[CCMenu menuWithItems:aboutItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
}

//进入关卡选择画面

-(void)startGame{
    
    //进入场景选择画面
    //  NSLog(@"进入场景选择界面");
    
    [SceneManager goChapterSelect];
    
}

//进入游戏介绍画面
-(void)about{

    [SceneManager goAboutScene];
    
}

//添加游戏名称
-(void)addGameTitle{
    screenSize = [CCDirector sharedDirector].winSize;
    
    gameTitle = [CCLabelTTF labelWithString:@"Angry Panda" fontName:@"Helvetica-Bold" fontSize:38];
    gameTitle.position =ccp(screenSize.width/2,screenSize.height*0.85);
    [self addChild:gameTitle];
    
}

//添加背景图片
-(void)addBackground{
    
    screenSize= [CCDirector sharedDirector].winSize;
    
    if(IS_IPHONE)
    {
        if(deviceType == kDeviceTypeNotIphone5){
            bgGameStart = [CCSprite spriteWithFile:@"bg_startgame.png"];
   
        }else if(deviceType == kDeviceTypeIphone5OrNewTouch){
            
            bgGameStart = [CCSprite spriteWithFile:@"bg_startgame-iphone5.png"];

        }
        
        
    }else if(IS_IPAD){
        
        bgGameStart = [CCSprite spriteWithFile:@"bg_startgame-ipad.png"];
        
    }
    bgGameStart.position = ccp(screenSize.width/2,screenSize.height/2);
    [self addChild:bgGameStart z:-1];
    
}


//添加背景音乐
-(void)playBackgroundMusic{
    
    [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusicIfNoOtherAudio];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    GameData *data = [GameData sharedData];
    if ( data.backgroundMusicMuted == NO ) {
        
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"bg_startgamescene.mp3" loop:YES];
        [CDAudioManager sharedManager].backgroundMusic.volume = 0.15f;
        
    }
    
    
}





#pragma mark 设置背景音乐选项

//创建背景音乐开关菜单选项

-(void) createBackgroundMusicMenuOn {
    
    [self removeChild:backgroundMusicMenu cleanup:YES];
    
    
    CCMenuItem *button1 = [CCMenuItemImage itemWithNormalImage:@"musicon.png" selectedImage:@"musicon.png" target:self selector:@selector(turnBackgroundMusicOff)];
    
    backgroundMusicMenu = [CCMenu menuWithItems:button1, nil];
    backgroundMusicMenu.position= backgroundMusicMenuLocation;
    
    [self addChild:backgroundMusicMenu z:10  ];
    
    
    
}


-(void)createBackgroundMusicMenuOff{
    [self removeChild:backgroundMusicMenu cleanup:YES];
    CCMenuItem *button1 = [CCMenuItemImage itemWithNormalImage:@"musicoff.png" selectedImage:@"musicoff.png" target:self selector:@selector(turnBackgroundMusicOn)];
    
    backgroundMusicMenu = [CCMenu menuWithItems:button1, nil];
    backgroundMusicMenu.position= backgroundMusicMenuLocation;
    
    [self addChild:backgroundMusicMenu z:10  ];
}


-(void)turnBackgroundMusicOn{
    
    GameData *data = [GameData sharedData];
    data.backgroundMusicMuted = NO;
    [[SimpleAudioEngine sharedEngine]resumeBackgroundMusic];
    [self createBackgroundMusicMenuOn];
}

-(void)turnBackgroundMusicOff{
    
    GameData *data = [GameData sharedData];
    data.backgroundMusicMuted = YES;
    [[SimpleAudioEngine sharedEngine]pauseBackgroundMusic];
    [self createBackgroundMusicMenuOff];
}

#pragma mark 设置音效开关选项

//创建音效开关选项

-(void) createSoundEffectMenuOn{
    
    [self removeChild:soundEffectMenu cleanup:YES];
    
    CCMenuItem *button1 = [CCMenuItemImage itemWithNormalImage:@"soundon.png" selectedImage:@"soundon.png" target:self selector:@selector(turnSoundEffectOff)];
    
    soundEffectMenu = [CCMenu menuWithItems:button1, nil];
    soundEffectMenu.position= soundEffectMenuLocation;
    
    [self addChild:soundEffectMenu z:10  ];
    
    
    
}
-(void)createSoundEffectMenuOff{
    
    [self removeChild:soundEffectMenu cleanup:YES];
    CCMenuItem *button1 = [CCMenuItemImage itemWithNormalImage:@"soundoff.png" selectedImage:@"soundoff.png" target:self selector:@selector(turnSoundEffectOn)];
    
    soundEffectMenu = [CCMenu menuWithItems:button1, nil];
    soundEffectMenu.position= soundEffectMenuLocation;
    
    [self addChild:soundEffectMenu z:10  ];
}


-(void)turnSoundEffectOn{
    
    GameData *data = [GameData sharedData];
    data.soundEffectMuted = NO;
    [[GameSounds sharedGameSounds]enableSoundEffect];
    [self createSoundEffectMenuOn];
}

-(void)turnSoundEffectOff{
    
    GameData *data = [GameData sharedData];
    data.soundEffectMuted = YES;
    [[GameSounds sharedGameSounds]disableSoundEffect];
    [self createSoundEffectMenuOff];
}

#pragma mark 设置菜单的位置

-(void)setMenuLocation{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    
    soundEffectMenuLocation = ccp(size.width*0.375,size.height*0.15);
    backgroundMusicMenuLocation = ccp(size.width*0.5,size.height*0.15);
    aboutMenuLocation = ccp(size.width*0.625,size.height*0.15);

}

#pragma  mark 创建声音设置的两个选项
-(void)createSoundSettingMenu{
    
    
    if([GameData sharedData].soundEffectMuted ==NO){
        [self createSoundEffectMenuOn];
    }else {
        [self createSoundEffectMenuOff];
    }
    
    if([GameData sharedData].backgroundMusicMuted ==NO){
        [self createBackgroundMusicMenuOn];
    }else {
        [self createBackgroundMusicMenuOff];
    }
    
    
}


#pragma mark-场景初始化


-(id)init{
    
    if((self  =[super init])){
        
        [self getDeviceType];
        
        [self addGameTitle];
        [self addBackground];
        
        [self setMenuLocation];
        [self addPlayItem];
        [self addAboutItem];
        
        [self createSoundSettingMenu];
        
        [self playBackgroundMusic];
        
    }
    return self;
}



@end
