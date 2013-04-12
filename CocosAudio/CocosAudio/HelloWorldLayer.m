//
//  HelloWorldLayer.m
//  SimpleAudio
//
//  Created by eseedo on 2/11/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
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
	if( (self=[super init])) {
        //使用CCDirector单例对象来获取屏幕大小
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //定义一个字体
        NSString *fontName = @"myfont.fnt";
        
		//创建播放标签，当触碰播放标签时，会调用playSong方法
		CCLabelBMFont *playLabel = [CCLabelBMFont labelWithString:@"Play" fntFile:fontName];
        CCMenuItemLabel  *playItem = [CCMenuItemLabel itemWithLabel:playLabel target:self selector:@selector(playSong:)];
        
        playItem.position = ccp(winSize.width/2,winSize.height *0.5);
        
        //创建停止标签，当触碰播放标签时，会调用stopPlaying方法
        
        CCLabelBMFont *stopLabel = [CCLabelBMFont labelWithString:@"Stop" fntFile:fontName];
        CCMenuItemLabel  *stopItem = [CCMenuItemLabel itemWithLabel:stopLabel target:self selector:@selector(stopPlaying:)];
        
        stopItem.scale = 0.5;
        stopItem.position = ccp(winSize.width/2,winSize.height *0.35);
        
        //创建暂停标签，当触碰播放标签时，会调用pausePlaying方法
        
        CCLabelBMFont *pauseLabel = [CCLabelBMFont labelWithString:@"Pause" fntFile:fontName];
        CCMenuItemLabel  *pauseItem = [CCMenuItemLabel itemWithLabel:pauseLabel target:self selector:@selector(pausePlaying:)];
        
        pauseItem.scale = 0.5;
        pauseItem.position = ccp(winSize.width/2,winSize.height *0.2);
        
        //创建继续标签，当触碰播放标签时，会调用resumePlaying方法
        
        CCLabelBMFont *resumeLabel = [CCLabelBMFont labelWithString:@"Resume" fntFile:fontName];
        CCMenuItemLabel  *resumeItem = [CCMenuItemLabel itemWithLabel:resumeLabel target:self selector:@selector(resumePlaying:)];
        
        resumeItem.scale = 0.5;
        resumeItem.position = ccp(winSize.width/2,winSize.height *0.85);
        
        //创建重放标签，当触碰重放标签时，会调用rewindPlaying方法
        
        CCLabelBMFont *rewindLabel = [CCLabelBMFont labelWithString:@"Rewind" fntFile:fontName];
        CCMenuItemLabel  *rewindItem = [CCMenuItemLabel itemWithLabel:rewindLabel target:self selector:@selector(rewindPlaying:)];
        
        rewindItem.scale = 0.5;
        rewindItem.position = ccp(winSize.width/2,winSize.height *0.65);
        
        //创建播放音效标签，当触碰播放音效标签时，会调用soundEffect方法
        
        CCLabelBMFont *soundEffectLabel = [CCLabelBMFont labelWithString:@"SoundEffect" fntFile:fontName];
        CCMenuItemLabel  *soundEffectItem = [CCMenuItemLabel itemWithLabel:soundEffectLabel target:self selector:@selector(soundEffect:)];
        
        soundEffectItem.scale = 0.3;
        soundEffectItem.position = ccp(winSize.width*0.2,winSize.height *0.5);
        
        //创建控制菜单，并将播放标签和停止标签添加进去
        
		CCMenu *menu =[CCMenu menuWithItems:playItem,stopItem,pauseItem, resumeItem,rewindItem, soundEffectItem, nil];
        
        menu.position = CGPointZero;
        [self addChild:menu];
        
        //    //让播放标签执行一个动作，出现在屏幕中
        //
        //    [playItem runAction:
        //     [CCSequence actions:
        //      [CCDelayTime actionWithDuration:3.0],
        //      [CCEaseIn actionWithAction:
        //       [CCScaleTo actionWithDuration:2.0 scale:0.9]rate:4.0],
        //      nil]];
        //
        //    //让停止标签执行一个动作，出现在屏幕中
        //    [stopItem runAction:
        //     [CCSequence actions:
        //      [CCDelayTime actionWithDuration:3.0],
        //      [CCEaseIn actionWithAction:
        //       [CCScaleTo actionWithDuration:2.0 scale:0.8]rate:4.0],
        //      nil]];
        
        [self scheduleUpdate];
        
        
	}
	return self;
}

-(void)playSong:(id)sender{
    //添加一行代码以播放背景音乐：
    
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"bgmusic.mp3" loop:YES];
    
}

-(void)stopPlaying:(id)sender{
    //停止播放背景音乐
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
}

-(void)pausePlaying:(id)sender{
    //暂停播放背景音乐
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    
}

-(void)resumePlaying:(id)sender{
    //继续播放背景音乐
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

-(void)rewindPlaying:(id)sender{
    //从开始处重放背景音乐
    [[SimpleAudioEngine sharedEngine] rewindBackgroundMusic];
    
}

-(void)soundEffect:(id)sender{
    //播放音效
    [[SimpleAudioEngine sharedEngine]playEffect:@"soundeffect01.mp3" pitch:12.0 pan:2.0 gain:5.0];
    
}

-(void)update:(ccTime)dt{
    isPlaying = [[SimpleAudioEngine sharedEngine]isBackgroundMusicPlaying];
    
    if(isPlaying){
        if(label !=nil){
            [label removeFromParentAndCleanup:YES];
        }
        label = [CCLabelTTF labelWithString:@"Now it's playing the music" fontName:@"Marker Felt" fontSize:24];
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        label.position = ccp(screenSize.width/2,screenSize.height *0.1);
        [self addChild:label];
        
    }
    else{
        if(label !=nil){
            [label removeFromParentAndCleanup:YES];
        }
        label = [CCLabelTTF labelWithString:@"Touch Play to start" fontName:@"Marker Felt" fontSize:24];
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        label.position = ccp(screenSize.width/2,screenSize.height *0.1);
        [self addChild:label];
        
    }
    
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
