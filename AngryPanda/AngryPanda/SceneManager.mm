//
//  SceneManager.m

//
//  Created by eseedo on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//
//  SceneManager.m
//

#import "SceneManager.h"


@interface SceneManager ()

+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;

@end

@implementation SceneManager

/*  ___Template___________________________________
 
 Step 3 - Add implementation to call scene
 ______________________________________________
 
 
 +(void) goSceneName {
 [SceneManager go:[SceneName node]];
 }
 
 */

#pragma mark 切换场景

+(void) goStartGame {
    [SceneManager go:[StartGameScene node]];
}

+(void) goAboutScene {
    [SceneManager go:[About node]];
}


+(void) goChapterSelect {
    
    [SceneManager go:[ChapterSelect node]];
}

+(void) goLevelSelect {
    
    [SceneManager go:[LevelSelection node]];
}

+(void) goGameScene {
    [SceneManager go:[MainScene node]];
}




+(void)goLevelResult{
    
    [SceneManager go:[LevelResult node]];
}





+(void) go: (CCLayer *) layer {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    
    
    if ([director runningScene]) {
        
        [director replaceScene:newScene];
        
        
    }
    else {
        [director runWithScene:newScene];
    }
}


#pragma mark 类方法

+(CCScene *) wrap: (CCLayer *) layer {
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
}

@end
