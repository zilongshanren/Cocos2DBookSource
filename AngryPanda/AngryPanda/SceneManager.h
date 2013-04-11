//
//  SceneManager.h

//
//  Created by eseedo on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//
//  SceneManager.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/*  ___Template___________________________________
 
 Step 1 - Import header of your SceneName
 ______________________________________________
 
 #import "SceneName.h"
 
 */
#import "StartGameScene.h"
#import "ChapterSelect.h"
#import "MainScene.h"
#import "About.h"

#import "LevelResult.h"

#import "LevelSelection.h"





@interface SceneManager : NSObject {
    
}

/*  ___Template___________________________________
 
 Step 2 - Add interface scene calling method
 ______________________________________________
 
 +(void) goSceneName;
 
 */

+(void) goStartGame;
+(void) goAboutScene;
+(void) goChapterSelect;
+(void) goLevelSelect;
+(void) goGameScene;

+(void) goLevelResult;





@end
