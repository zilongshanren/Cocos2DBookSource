//
//  CustomAnimation.m
//  CustomAnimationClass


#import "CustomAnimation.h"


@implementation CustomAnimation

//初始化动画，并设置多种属性

-(id) initWithOurOwnProperties:(NSString*)theFileNameToAnimate theFrameToStartWith:(int)theFrameToStartWith theNumberOfFramesToAnimate:(int)theNumberOfFramesToAnimate theX:(int)theX theY:(int)theY flipOnX:(bool)flipOnX flipOnY:(bool)flipOnY doesItLoop:(bool)doesItLoop doesItUseRandomFrameToLoop:(bool)doesItUseRandomFrameToLoop{
    
    if ((self = [super init]))
    {
        
        
        fileNameToAnimate = theFileNameToAnimate;
        
        frameToStartWith = theFrameToStartWith;
        currentFrame = frameToStartWith;
        
        framesToAnimate = theNumberOfFramesToAnimate;
        
        animationFlippedX = flipOnX;
        animationFlippedY = flipOnY;
        
        doesTheAnimationLoop = doesItLoop;
        useRandomFrameToLoop = doesItUseRandomFrameToLoop;
        
        someSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_000%i.png", fileNameToAnimate, currentFrame]];
        [self addChild:someSprite];
        someSprite.position = ccp( theX , theY );
        
        someSprite.flipX = animationFlippedX;
        someSprite.flipY = animationFlippedY;
        
        
        
        [self schedule:@selector(runMyAnimation:) interval: 1.0f / 60.0f ];
        
        
    }
    return self;
}

//运行动画

-(void) runMyAnimation:(ccTime) delta {
    
    currentFrame ++; //给currentFrame加1
    
    if (currentFrame <= framesToAnimate) {
        
        if (currentFrame < 10) {
            
            [someSprite setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_000%i.png", fileNameToAnimate, currentFrame]] texture] ];
            
            
        } else if (currentFrame < 100) {
            
            [someSprite setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_00%i.png", fileNameToAnimate, currentFrame]] texture] ];
            
        } else {
            
            [someSprite setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_0%i.png", fileNameToAnimate, currentFrame]] texture] ];
            
        }
        
        
    } else {
        
        if ( doesTheAnimationLoop == YES && useRandomFrameToLoop == NO) {
            
            currentFrame = frameToStartWith;
            
        } else if ( doesTheAnimationLoop == YES && useRandomFrameToLoop == YES) {
            
            
            
            currentFrame = arc4random() % framesToAnimate; // 得到一个从0到framesToAnimate的随机数
            
        } else {
            [self removeChild:someSprite cleanup:NO];
            [self unschedule:_cmd];
        }
        
    }
    
    
}

//更改透明度

-(void) changeOpacityTo:(int)theNewOpacity {
    
    someSprite.opacity = theNewOpacity;  //范围从0到255
    
}

//着色

-(void) tintMe:(ccColor3B)theColor {
    
    someSprite.color = theColor;
    
}

//类方法

+(id) createClassWithFile:(NSString*)theFileNameToAnimate theFrameToStartWith:(int)theFrameToStartWith theNumberOfFramesToAnimate:(int)theNumberOfFramesToAnimate theX:(int)theX theY:(int)theY flipOnX:(bool)flipOnX flipOnY:(bool)flipOnY  doesItLoop:(bool)doesItLoop doesItUseRandomFrameToLoop:(bool)doesItUseRandomFrameToLoop{
    
    return [[[self alloc] initWithOurOwnProperties:(NSString*)theFileNameToAnimate theFrameToStartWith:(int)theFrameToStartWith theNumberOfFramesToAnimate:(int)theNumberOfFramesToAnimate theX:(int)theX theY:(int)theY flipOnX:(bool)flipOnX flipOnY:(bool)flipOnY  doesItLoop:(bool)doesItLoop doesItUseRandomFrameToLoop:(bool)doesItUseRandomFrameToLoop] autorelease];
}


//释放内存

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
