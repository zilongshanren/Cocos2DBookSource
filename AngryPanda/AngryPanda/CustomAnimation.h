//
//  CustomAnimation.h
//  CustomAnimationClass


/*
 该类用于创建定制化的动画效果
 较少使用
 
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CustomAnimation : CCNode {
    
    NSString *fileNameToAnimate;
    int currentFrame;
    int framesToAnimate;
    int frameToStartWith;
    
    CCSprite *someSprite;
    
    bool animationFlippedX;
    bool animationFlippedY;
    bool doesTheAnimationLoop;
    bool useRandomFrameToLoop;
}

+(id) createClassWithFile:(NSString*)theFileNameToAnimate theFrameToStartWith:(int)theFrameToStartWith theNumberOfFramesToAnimate:(int)theNumberOfFramesToAnimate theX:(int)theX theY:(int)theY flipOnX:(bool)flipOnX flipOnY:(bool)flipOnY doesItLoop:(bool)doesItLoop doesItUseRandomFrameToLoop:(bool)doesItUseRandomFrameToLoop;

-(void) tintMe:(ccColor3B)theColor;
-(void) changeOpacityTo:(int)theNewOpacity;

@end
