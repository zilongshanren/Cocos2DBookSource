//
//  StartGameScene.h
//  AngryPanda
//
//  Created by eseedo on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 
 游戏启动后的首界面，其作用很简单，当用户触碰Play按钮后即可进入关卡选择界面
 在修改后可重用到其它项目
 
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"
#import "MainScene.h"
#import "GameSounds.h"
#import "LevelSelection.h"


@interface StartGameScene : CCLayer{
    
    CCSprite *bgGameStart;
    CCSprite *gameTitle;
    CGSize screenSize;
    CCMenuItem *playItem;
    CCMenuItem *aboutItem;
    
    //音效设置
    
    CCMenu* soundEffectMenu;
    CCMenu* backgroundMusicMenu;
    
    CGPoint soundEffectMenuLocation;
    CGPoint backgroundMusicMenuLocation;
    CGPoint aboutMenuLocation;
    
    //设备类型
    int deviceType;
    
    
}



+(id)scene;


@end
