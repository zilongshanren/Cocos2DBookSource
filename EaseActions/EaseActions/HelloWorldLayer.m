//
//  HelloWorldLayer.m
//  EaseActions
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
        
        //  定义一个ease动作
        id easeAction = [CCEaseBounceOut actionWithAction:[CCMoveTo actionWithDuration:2.0 position:ccp(100+size.width/2,size.height/2)]];
        
        //  定义一个CCSequence组合动作，组合动作中的第一个动作是刚定义的ease动作，第二个动作则是缩放动作
        id action = [CCSequence actions:easeAction,[CCScaleTo actionWithDuration:2.0 scale:2], nil];
        
        //  让精灵对象执行该组合动作
        [mySprite runAction:action];
        
        //  以下是各种Ease动作的代码
        //  要查看某种动作的效果，直接取消对相关代码的注释即可。
        
        //  CCEaseBackIn动作
        //    id easeBackInAction = [CCEaseBackIn actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)]];
        //    [mySprite runAction:easeBackInAction];
        
        //  CCEaseBackInOut动作
        //    id easeBackInOutAction = [CCEaseBackInOut actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)]];
        //    [mySprite runAction:easeBackInOutAction];
        
        //  CCEaseBackOut动作
        //    id easeBackOutAction = [CCEaseBackOut actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)]];
        //    [mySprite runAction:easeBackOutAction];
        
        //  CCEaseBounce动作
        //    id easeBouceAction = [CCEaseBounce actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)]];
        //    [mySprite runAction:easeBouceAction];
        
        //  CCEaseElastic动作
        //    id easeElasticAction = [CCEaseElastic actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)] period:5.0];
        //    [mySprite runAction:easeElasticAction];
        
        //  CCEaseElasticIn动作
        
        //    id easeElasticInAction = [CCEaseElasticIn actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)] period:5.0];
        //    [mySprite runAction:easeElasticInAction];
        
        //  CCEaseElasticInOut动作
        
        //    id easeElasticInOutAction = [CCEaseElasticInOut actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)] period:5.0];
        //    [mySprite runAction:easeElasticInOutAction];
        
        //  CCEaseElasticOut动作
        
        //    id easeElasticOutAction = [CCEaseElasticOut actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)] period:5.0];
        //    [mySprite runAction:easeElasticOutAction];
        
        // CCEaseExponentialIn动作
        
        //    id easeExponentialInAction =[CCEaseExponentialIn actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)]];
        //    [mySprite runAction:easeExponentialInAction];
        
        //CCEaseExponentialInOut动作
        
        //    id easeExponentialInOutAction = [CCEaseExponentialInOut actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)]];
        //    [mySprite runAction:easeExponentialInOutAction];
        
        //CCEaseExponentialOut动作
        
        //    id easeExponentialOutAction =[CCEaseExponentialOut actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)]];
        //    [mySprite runAction:easeExponentialOutAction];
        
        //CCEaseIn动作
        
        //    id easeInAction = [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)] rate:2.0];
        //    [mySprite runAction:easeInAction];
        
        //CCEaseInOut动作
        
        //    id easeInOutAction = [CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)] rate:2.0];
        //    [mySprite runAction:easeInOutAction];
        
        //CCEaseOut动作
        
        //    id easeOutAction =[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)] rate:2.0];
        //    [mySprite runAction:easeOutAction];
        
        //CCEaseRateAction动作
        
        //    id easeRateAction = [CCEaseRateAction actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)] rate:2.0];
        //    [mySprite runAction:easeRateAction];
        
        //CCEaseSineIn动作
        
        //    id easeSineInAction =[CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)]];
        //    [mySprite runAction:easeSineInAction];
        
        //CCEaseSineInOut动作
        
        //    id easeSineInOutAction =[CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)]];
        //    [mySprite runAction:easeSineInOutAction];
        
        //CCEaseSineOut动作
        
        //    id easeSineOutAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:5.0 position:ccp(100+size.width/2,size.height/2)]];
        //    [mySprite runAction:easeSineOutAction];
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
