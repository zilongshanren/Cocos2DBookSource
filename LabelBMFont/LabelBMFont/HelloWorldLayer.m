//
//  HelloWorldLayer.m
//  LabelBMFont
//
//  Created by guanghui on 9/6/12.
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
		
        // 使用CCLabelBMFont的类方法创建了一个标签，并使用刚刚在Hiero中生成的myfont.fnt字符图集
        CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"Hello" fntFile:@"myfont.fnt"];
        
		// 获取屏幕的大小
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// 将标签放置在屏幕的中心位置
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// 将标签添加为当前层的子节点
		[self addChild: label];
        
        id labelAction = [CCSpawn actions:[CCScaleBy actionWithDuration:2.0f scale:4],[CCFadeIn actionWithDuration:2.0f], nil];
        [label runAction:labelAction];

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
