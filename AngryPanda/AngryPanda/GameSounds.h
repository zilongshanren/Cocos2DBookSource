//
//  GameSounds.h

/*
 
 与游戏音效相关的类，主要作用是开启或关闭音效
 
 */


#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameSounds : CCNode {
    
}



+(GameSounds*) sharedGameSounds;

//启用或禁止音效
-(void) disableSoundEffect;
-(void) enableSoundEffect;

//播放或关闭背景音乐
-(void) playBackgroundMusic;
-(void) stopBackgroundMusic;

//以下方法用于播放不同界面中的不同音效

//-(void) playSoundEffect:(NSString*)fileName;
//-(void) playSoundEffectWithDelay:(NSString*)fileName:(float)delayTime;


//-(void) playStretchSlingshotSound;
//-(void) playReleaseSlingshotSound;
//-(void) playImpactSound;
//-(void) playBreakSound;
//-(void) playIntroSound;

//-(void) restartBackgroundMusic;
//-(void) playAboutSceneMusic;

//-(void) preloadSounds;

//-(void) levelClear;
//-(void) levelLose;

@end
