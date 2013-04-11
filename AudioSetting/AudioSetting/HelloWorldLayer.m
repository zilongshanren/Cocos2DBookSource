//
//  HelloWorldLayer.m
//  AudioSetting
//
//  Created by eseedo on 2/11/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SoundSetting.h"
#import "SimpleAudioEngine.h"

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
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        //使用CCDirector单例对象来获取屏幕大小
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //定义一个字体
        NSString *fontName = @"myfont.fnt";
        
		//创建播放标签，当触碰播放标签时，会调用playSong方法
		CCLabelBMFont *playLabel = [CCLabelBMFont labelWithString:@"Touch to play music" fntFile:fontName];
        CCMenuItemLabel  *playItem = [CCMenuItemLabel itemWithLabel:playLabel target:self selector:@selector(playSong:)];
        
        playItem.scale = 0.7;
        playItem.position = ccp(winSize.width/2,winSize.height *0.7);
        
        //创建设置标签，当触碰播放标签时，会调用settingSound方法
        
        CCLabelBMFont *settingLabel = [CCLabelBMFont labelWithString:@"Setting" fntFile:fontName];
        CCMenuItemLabel  *settingItem = [CCMenuItemLabel itemWithLabel:settingLabel target:self selector:@selector(settingSound:)];
        
        settingItem.position = ccp(winSize.width/2,winSize.height *0.35);
        
        
        //创建控制菜单，并将以上标签添加进去
        
		CCMenu *menu =[CCMenu menuWithItems:playItem,settingItem,nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
	}
	return self;
}

-(void)playSong:(id)sender{
    //添加一行代码以播放背景音乐：
    
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"bgmusic.mp3" loop:YES];
    
}

-(void)settingSound:(id)sender{
    
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    CCTransitionSlideInL *transitionScene = [CCTransitionSlideInL transitionWithDuration:3.0 scene:[SoundSetting scene]];
    [[CCDirector sharedDirector]replaceScene:transitionScene];
    
    
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
