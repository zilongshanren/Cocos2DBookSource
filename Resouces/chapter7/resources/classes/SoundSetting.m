//
//  SoundSetting.m
//  AudioSetting
//
//  Created by eseedo on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundSetting.h"
#import "HelloWorldLayer.h"
#import "CDAudioManager.h"

@implementation SoundSetting


+(id)scene{
  
  CCScene *scene = [CCScene node];
  SoundSetting *layer = [SoundSetting node];
  [scene addChild:layer];
  return scene;
  
}

-(id)init{
  if((self = [super init])){
    
    //使用CCDirector单例对象来获取屏幕大小
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    
    //定义一个字体
    NSString *fontName = @"myfont.fnt";
    
    //设置字体和大小
    
    [CCMenuItemFont setFontName: @"Helvetica-Bold"];
    [CCMenuItemFont setFontSize:18];
    
		//设置切换音乐的选项。菜单状态：开和关
    
    CCMenuItemFont *musicTitle = [CCMenuItemFont itemFromString:@"触摸下面的标签开启或关闭音乐"];
    [musicTitle setIsEnabled:NO];
    musicTitle.position = ccp(winSize.width *0.5,winSize.height *0.7);
    
    CCMenuItemFont *musicOn = [CCMenuItemFont itemFromString:@"On"];
    CCMenuItemFont *musicOff = [CCMenuItemFont itemFromString:@"Off"];
    CCMenuItemToggle *music = [CCMenuItemToggle itemWithTarget:self selector:@selector(changeStatus:) items:musicOff, musicOn,nil];
    music.position = ccp(winSize.width *0.5,winSize.height *0.6);
    
    
    //创建返回标签，当触碰该标签时，会调用backToMainMenu方法
    
    CCLabelBMFont *returnLabel = [CCLabelBMFont labelWithString:@"Back to main menu" fntFile:fontName];
    CCMenuItemLabel  *returnItem = [CCMenuItemLabel itemWithLabel:returnLabel target:self selector:@selector(backToMainMenu:)];
    
    returnItem.scale = 0.7;
    returnItem.position = ccp(winSize.width*0.5,winSize.height *0.35);
    
    
    //创建控制菜单，并将以上标签添加进去
    
		CCMenu *menu =[CCMenu menuWithItems:musicTitle,music,returnItem,nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
    NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
    
		if([usrDef boolForKey:@"music"] == NO)
			music.selectedIndex = 1;
  }
  return self;
  
}

-(void)changeStatus:(CCMenuItemToggle *)sender{
  
  NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	
	if(sender.selectedIndex ==1)
		[usrDef setBool:NO forKey:@"music"];
	if(sender.selectedIndex ==0)
		[usrDef setBool:YES forKey:@"music"];
  
  if([CDAudioManager sharedManager].mute == TRUE){
    [CDAudioManager sharedManager].mute =FALSE;
  }else{
    [CDAudioManager sharedManager].mute = TRUE;
    
  }
  
  
}



-(void)backToMainMenu:(id)sender{
  
  CCTransitionFlipX *transitionScene = [CCTransitionFlipX transitionWithDuration:3.0 scene:[HelloWorldLayer scene]];
  [[CCDirector sharedDirector]replaceScene:transitionScene];
}

@end
