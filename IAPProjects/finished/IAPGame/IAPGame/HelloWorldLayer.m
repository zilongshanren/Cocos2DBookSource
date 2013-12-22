//
//  HelloWorldLayer.m
//  IAPGame
//
//  Created by Ricky on 11/5/12.
//  Copyright eseedo 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "MyStore.h"
#import "CurrentCoins.h"
#import "SimpleAudioEngine.h"
#import "DragonWeapon.h"

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

#pragma mark 游戏界面相关

-(void)addBg{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    CCSprite *bg = [CCSprite spriteWithFile:@"dragon.png"];
    bg.position =ccp(size.width/2,size.height/2);
    
    [self addChild:bg z:-1];
    
}

-(void)addButton{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    [CCMenuItemFont setFontSize:25];
    
    CCMenuItemFont *item1 = [CCMenuItemFont itemWithString:@"进入商城" target:self selector:@selector(enterMyStore)];
    
    
    
    CCMenuItemFont *item2 = [CCMenuItemFont itemWithString:@"查看天龙币余额" target:self selector:@selector(checkCurrentCoins)];
    
    
    CCMenuItemFont *item3 =[CCMenuItemFont itemWithString:@"购买天龙装备" target:self selector:@selector(buyDragonWeapons)];
    
    CCMenu *menu = [CCMenu menuWithItems:item1,item2, item3,nil];
    
    menu.position = ccp(size.width/2,size.height*0.25);
    [menu alignItemsVerticallyWithPadding:15.0];
    
    [self addChild:menu];
    
}



-(void)enterMyStore{
    
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:2.0f scene:[MyStore scene]];
    [[CCDirector sharedDirector]pushScene:transition];
    
}

-(void)checkCurrentCoins{
    
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:2.0f scene:[CurrentCoins scene]];
    [[CCDirector sharedDirector]pushScene:transition];
    
    
}

-(void)buyDragonWeapons{
    
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:2.0f scene:[DragonWeapon scene]];
    [[CCDirector sharedDirector]pushScene:transition];
    
}

-(void)playBgMusic{
    
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"dragon.mp3" loop:YES];
}



#pragma mark 游戏初始化方法

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
		//添加背景图片
        [self addBg];
        
        //添加按钮
        [self addButton];
        
        //播放背景音乐
        [self playBgMusic];
        
        
        
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
