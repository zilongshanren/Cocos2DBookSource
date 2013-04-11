//
//  HelloWorldLayer.m
//  DelayActions
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
        CCSprite *mySprite = [CCSprite spriteWithFile:@"plane.png"];
        
        //  获取屏幕大小并设置精灵的位置
        CGSize size = [CCDirector sharedDirector].winSize;
        mySprite.position = ccp(size.width/2,size.height/2);
        
        //  将精灵对象添加为当前层的子节点
        [self addChild:mySprite];
        
        //  定义一个序列组合动作，首先延迟3秒，然后再执行CCMoveTo动作
        
        id action = [CCSequence actions:[CCDelayTime actionWithDuration:3],[CCMoveTo actionWithDuration:2 position:ccp(100+size.width/2,size.height/2)],nil];
        
        //  让精灵对象执行该组合动作
        [mySprite runAction:action];
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
