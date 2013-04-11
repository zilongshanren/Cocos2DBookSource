//
//  HelloWorldLayer.m
//  CompositionActions
//
//  Created by guanghui on 9/5/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        //  创建并初始化精灵对象
        CCSprite *mySprite = [CCSprite spriteWithFile:@"ball.png"];
        
        //  获取屏幕大小并设置精灵的位置
        CGSize size = [CCDirector sharedDirector].winSize;
        mySprite.position = ccp(size.width/2,size.height/2);
        
        //  将精灵对象添加为当前层的子节点
        [self addChild:mySprite];
        
        //  定义一个CCAction组合动作
        
        CCAction *action = [CCSpawn actions:[CCFadeOut actionWithDuration:5.0],[CCScaleTo actionWithDuration:5.0 scale:0.5], nil];
        
        //  让精灵对象执行该动作
        [mySprite runAction:action];
        
        //  以下是四种组合动作的使用方法介绍
        //  要查看某种动作的效果，直接取消对相关代码的注释即可。
        
        //  CCSpawn：使用该方法可以让节点同时执行多个动作
        //    CCAction *action = [CCSpawn actions:[CCFadeIn actionWithDuration:2],[CCScaleTo actionWithDuration:2 scale:2], nil];
        //    [mySprite runAction:action];
        
        //  CCSpawn的另一种使用方法
        //    NSArray *actions = [NSArray arrayWithObjects:[CCFadeIn actionWithDuration:2],[CCScaleTo actionWithDuration:2 scale:2], nil];
        //    CCAction  *action =[CCSpawn actionsWithArray:actions];
        //    [mySprite runAction:action];
        
        //  CCSequence：使用该方法可以按顺序执行多个动作
        //    CCAction *action = [CCSequence actions:[CCFadeIn actionWithDuration:2],[CCScaleTo actionWithDuration:2 scale:2], nil];
        //    [mySprite runAction:action];
        
        //  CCSequence的另一种使用方法
        //    NSArray *actions = [NSArray arrayWithObjects:[CCFadeIn actionWithDuration:2],[CCScaleTo actionWithDuration:2 scale:2], nil];
        //    CCAction *action = [CCSequence actionsWithArray:actions];
        //    [mySprite runAction:action];
        
        //  CCRepeat：使用该方法，让节点在限定的时间内重复执行某个动作
        //    CCFiniteTimeAction *action = [CCSequence actions:[CCFadeIn actionWithDuration:2],[CCBlink actionWithDuration:1 blinks:3], nil];
        //    [mySprite runAction:[CCRepeat actionWithAction:action times:3]];
        
        //    CCRepeatForever：使用该组合动作，让节点反复执行某个动作
        //    id action1 = [CCMoveBy actionWithDuration:2 position:ccp(100,0)];
        //    [mySprite runAction:[CCRepeatForever actionWithAction:action]];
        
        //    id action2 = [CCSequence actions:[CCMoveBy actionWithDuration:2 position:ccp(100,0)],[CCScaleTo actionWithDuration:1 scale:1.2], nil];
        //    [mySprite runAction:[CCRepeatForever actionWithAction:action2]];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
