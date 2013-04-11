//
//  HelloWorldLayer.m
//  CDSoundTest
//
//  Created by eseedo on 2/11/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"


// 使用以下宏定义来简化播放音乐的代码
/** CDAudioManager 支持左右两个声道
 typedef enum {
 kASC_Left = 0,
 kASC_Right = 1
 } tAudioSourceChannel;	*/
#define CGROUP_BG       kASC_Left    // 背景音乐所在的声道
#define CGROUP_EFFECTS  kASC_Right   // 音效所在的声道
#define SND_BG_LOOP 1     // 背景音乐的标识
#define SND_ROCKET   2     // 火箭炮音效的标识
#define SND_CANNON  3     //大炮音效的标识
#define SND_BLAST   4    //爆炸音效的标识
// 使用下面的宏来播放音乐
#define playEffect(__ID__)      [[CDAudioManager sharedManager].soundEngine playSound:__ID__ sourceGroupId:CGROUP_EFFECTS pitch:1.0f pan:0.0f gain:1.0f loop:NO]


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
        
		//创建大炮标签，当触碰该标签时，会调用shootCannon方法
		CCLabelBMFont *cannonLabel = [CCLabelBMFont labelWithString:@"Cannon" fntFile:fontName];
        CCMenuItemLabel  *cannonItem = [CCMenuItemLabel itemWithLabel:cannonLabel target:self selector:@selector(shootCannon:)];
        
        cannonItem.scale = 0.5;
        cannonItem.position = ccp(winSize.width/2,winSize.height *0.5);
        
        //创建火箭标签，当触碰该标签时，会调用shootRocket方法
        
        CCLabelBMFont *rocketLabel = [CCLabelBMFont labelWithString:@"Rocket" fntFile:fontName];
        CCMenuItemLabel  *rocketItem = [CCMenuItemLabel itemWithLabel:rocketLabel target:self selector:@selector(shootRocket:)];
        
        rocketItem.scale = 0.5;
        rocketItem.position = ccp(winSize.width/2,winSize.height *0.35);
        
        //创建爆炸标签，当触碰该标签时，会调用blast方法
        
        CCLabelBMFont *blastLabel = [CCLabelBMFont labelWithString:@"Blast" fntFile:fontName];
        CCMenuItemLabel  *blastItem = [CCMenuItemLabel itemWithLabel:blastLabel target:self selector:@selector(blast:)];
        
        blastItem.scale = 0.5;
        blastItem.position = ccp(winSize.width/2,winSize.height *0.7);
        
        //创建播放标签，当触碰该标签时，会调用playMusic方法
        
        CCLabelBMFont *playLabel = [CCLabelBMFont labelWithString:@"Play Music" fntFile:fontName];
        CCMenuItemLabel  *playItem = [CCMenuItemLabel itemWithLabel:playLabel target:self selector:@selector(playMusic:)];
        
        playItem.scale = 0.5;
        playItem.position = ccp(winSize.width/2,winSize.height *0.9);
        
        //创建控制菜单，并将以上标签添加进去
        
		CCMenu *menu =[CCMenu menuWithItems:cannonItem,rocketItem,blastItem,playItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
	}
	return self;
}

-(void)playMusic:(id)sender{
    
    [[CDAudioManager sharedManager] playBackgroundMusic:@"bgmusic.mp3" loop:YES];
    
}

-(void)blast:(id)sender{
    //   playEffect(SND_BLAST);
    [[CDAudioManager sharedManager].soundEngine playSound:SND_BLAST sourceGroupId:CGROUP_BG pitch:1.0f pan:0.0f gain:1.0f loop:NO];
}


-(void)shootCannon:(id)sender{
    playEffect(SND_CANNON);
}

-(void)shootRocket:(id)sender{
    playEffect(SND_ROCKET);
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
