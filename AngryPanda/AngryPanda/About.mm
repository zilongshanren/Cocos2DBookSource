//
//  About.m
//  AngryPanda
//
//  Created by Ricky Wang on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "About.h"
#import "StartGameScene.h"
#import "SimpleAudioEngine.h"
#import "GameData.h"
#import "Constants.h"


@implementation About



+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	About *layer = [About node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

#pragma mark 添加基本视觉元素

//获取设备类型
-(void)getDeviceType{
    
    if([GameData sharedData].isDeviceIphone5 == NO){
        deviceType = kDeviceTypeNotIphone5;
    }else{
        deviceType = kDeviceTypeIphone5OrNewTouch;
    }
}


//返回游戏开始界面
-(void)backToStart{
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0f scene:[StartGameScene scene]];
    [[CCDirector sharedDirector]replaceScene:trans];
    
}
//添加返回按钮
-(void)addBackItem{
    CGSize screenSize =[CCDirector sharedDirector].winSize;
    
    CCMenuItemImage* backButton = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"back.png" target:self selector:@selector(backToStart)];
    CCMenu *menuButton = [CCMenu menuWithItems:backButton,  nil];
    menuButton.position = ccp(70,screenSize.height*0.8);
    [self addChild:menuButton z:1];
    
}

//添加背景图片
-(void)addBg{
    
    CCSprite *finalBg;

    
    if(IS_IPHONE)
    {
        if(deviceType == kDeviceTypeNotIphone5){
            finalBg = [CCSprite spriteWithFile:@"bg_startgame.png"];

            
        }else if(deviceType == kDeviceTypeIphone5OrNewTouch){
            
            finalBg = [CCSprite spriteWithFile:@"bg_startgame-iphone5.png"];

        }
        
        
    }else if(IS_IPAD){
        
        finalBg = [CCSprite spriteWithFile:@"bg_startgame-ipad.png"];
        
    }

    finalBg.anchorPoint = CGPointZero;
    finalBg.position = ccp(0,0);
    [self addChild:finalBg];
    
}

//添加背景音乐
-(void)addBgMusic{
    
    GameData *data = [GameData sharedData];
    if ( data.backgroundMusicMuted == NO ) {
        
        if([SimpleAudioEngine sharedEngine].isBackgroundMusicPlaying == NO)
        {
            
            [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"bg_startgamescene.mp3" loop:YES];
        }
        
    }
    
}


//添加文字标签
-(void)addTextLabel{
    CGSize screenSize =[CCDirector sharedDirector].winSize;
    
    CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"本游戏教程仅用作学习目的" fontName:@"Arial-BoldMT" fontSize:16];
    

    label1.position =ccp(screenSize.width/2,screenSize.height*1.3);
    [label1 runAction:[CCSequence actions:[CCMoveTo actionWithDuration:6.0f position:ccp(screenSize.width/2,screenSize.height*0.7)], [CCScaleTo actionWithDuration:3.0f scale:1.0], nil]];
    [self addChild:label1];
    
}


//添加菜单选项，以访问作者的新浪微博链接（非微博sdk分享）

-(void)addSinaMicroBlogLinkMenu{
    CGSize screenSize =[CCDirector sharedDirector].winSize;
    CCMenuItem *microBlogLinkItem = [CCMenuItemImage itemWithNormalImage:@"weibo.png" selectedImage:@"weibo.png" target:self selector:@selector(visitMySinaMicroBlog)];
    microBlogLinkItem.position = ccp(screenSize.width*0.4,screenSize.height*0.2);
    [microBlogLinkItem runAction:[CCScaleTo actionWithDuration:3.0f scale:1.5]];
    
    
    CCMenu *menu = [CCMenu menuWithItems:microBlogLinkItem, nil];
    menu.position =CGPointZero;
    [self addChild:menu];
}

//添加菜单选项，以访问作者的博客链接

-(void)addSinaBlogLinkMenu{
    CGSize screenSize =[CCDirector sharedDirector].winSize;
    CCMenuItem *blogLinkItem = [CCMenuItemImage itemWithNormalImage:@"sinablog.png" selectedImage:@"sinablog.png" target:self selector:@selector(visitMySinaBlog)];
    blogLinkItem.position = ccp(screenSize.width*0.7,screenSize.height*0.2);
    [blogLinkItem runAction:[CCScaleTo actionWithDuration:3.0f scale:1.5]];
    
    CCMenu *menu = [CCMenu menuWithItems:blogLinkItem, nil];
    menu.position =CGPointZero;
    [self addChild:menu];
}

//添加菜单选项，给作者写电子邮件
-(void)addMailToMeMenu{
    CGSize screenSize =[CCDirector sharedDirector].winSize;
    CCMenuItem *mailToMeItem = [CCMenuItemImage itemWithNormalImage:@"email.png" selectedImage:@"email.png" target:self selector:@selector(mailToMe)];
    mailToMeItem.position = ccp(screenSize.width*0.8,screenSize.height*0.8);
    [mailToMeItem runAction:[CCScaleTo actionWithDuration:3.0f scale:1.1]];
    
    CCMenu *menu = [CCMenu menuWithItems:mailToMeItem, nil];
    menu.position =CGPointZero;
    [self addChild:menu];
    
}

#pragma mark 社交网络分享
-(void)addShareButton{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    //创建分享按钮
    CCMenuItem *shareButton = [CCMenuItemSprite  itemWithNormalSprite:[CCSprite spriteWithFile:@"button_share.png"]   selectedSprite:nil target:self selector:@selector(shareButtonTouched)];
    shareButton.position = ccp(size.width*0.5,size.height*0.4);
    
    CCMenu *menu = [CCMenu menuWithItems:shareButton, nil];
    menu.position = ccp(0,0);
    [self addChild:menu z:3];
    
    
    CCLabelTTF *shareText = [CCLabelTTF labelWithString:@"分享给好友" fontName:@"ArialRoundedMTBold" fontSize:20];
    shareText.position = ccp(size.width/2,size.height *0.2);
    [self addChild:shareText];
    
    
}


-(void)shareButtonTouched{
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5],[CCCallFunc actionWithTarget:self selector:@selector(shareToSocialNetwork)] ,nil]];
}

-(void)shareToSocialNetwork{
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    BOOL isSystemVersionAfter6 = NO;
    if([systemVersion isEqualToString:@"6.0"] || [systemVersion isEqualToString:@"6.0.1"] || [systemVersion isEqualToString:@"6.1"])  {
        isSystemVersionAfter6 = YES;
    }
    
    NSLog(@"systemversion is:%@",systemVersion);
    
    if(isSystemVersionAfter6){
        
        NSString *initialText = [NSString stringWithFormat:@"这是我的第一个Cocos2D游戏，来试试看吧~"];
        
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[initialText] applicationActivities:nil];
        [[[CCDirector sharedDirector]parentViewController]  presentViewController:activityViewController animated:YES completion:nil];
    }
    else{
        NSURL *url = [NSURL URLWithString:@"mailto://eseedo@gmail.com"];
        [[UIApplication sharedApplication]openURL:url];
    }
}



//访问作者的新浪微博链接（非微博sdk分享）
-(void)visitMySinaMicroBlog{
    
    NSURL *url = [NSURL URLWithString:@"http://weibo.com/eseedo"];
    [[UIApplication sharedApplication]openURL:url];
    
}

//访问作者的博客链接
-(void)visitMySinaBlog{
    NSURL *url = [NSURL URLWithString:@"http://blog.sina.com.cn/eseedo"];
    [[UIApplication sharedApplication]openURL:url];
    
}

//给作者写邮件
-(void)mailToMe{
    NSURL *url = [NSURL URLWithString:@"mailto://eseedo@gmail.com"];
  	[[UIApplication sharedApplication] openURL:url];
}


#pragma mark 场景初始化

//场景初始化


-(id)init{
    if((self = [super init])){
        
        [self getDeviceType];
        [self addBg];
        [self addBackItem];
        [self addBgMusic];
        [self addTextLabel];
        [self addShareButton];
        
//        [self addSinaBlogLinkMenu];
//        [self addSinaMicroBlogLinkMenu];        
//        [self addMailToMeMenu];
        
    
    }
    return self;
    
}



@end
