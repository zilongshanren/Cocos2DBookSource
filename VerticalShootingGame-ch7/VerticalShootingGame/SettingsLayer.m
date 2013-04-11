//
//  SettingsLayer.m
//  VerticalShootingGame
//
//  Created by guanghui qu on 6/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsLayer.h"
#import "SimpleAudioEngine.h"

#import "Constants.h"


@implementation SettingsLayer

+(id) scene{
    CCScene *sc = [CCScene node];
    CCLayer *layer = [SettingsLayer node];
    [sc addChild:layer];
    
    return sc;
}

-(id) init{
    if ((self = [super init])) {
        CCLabelTTF *musicLabel = [CCLabelTTF labelWithString:@"背景音乐:" fontName:@"Arial" fontSize:20];
        musicLabel.position = ccp(100,280);
        [self addChild:musicLabel];
        
        CCLabelTTF *audioLabel = [CCLabelTTF labelWithString:@"游戏音效:" fontName:@"Arial" fontSize:20];
        audioLabel.position = ccp(100,240);
        [self addChild:audioLabel];
        
        
        CCMenuItem *musicOnItem = [CCMenuItemFont itemWithString:@"开" target:self 
                                                        selector:nil];
        musicOnItem.tag = 1;
        CCMenuItem *musicOffItem = [CCMenuItemFont itemWithString:@"关" target:self
                                                         selector:nil];
        musicOnItem.tag = 0;
        CCMenuItemToggle *musicItem = [CCMenuItemToggle itemWithTarget:self
                                                              selector:@selector(toggleGameMusic:)
                                                                 items:musicOffItem,musicOnItem, nil];
        
        BOOL musicState = [[[NSUserDefaults standardUserDefaults] objectForKey:kMusicKey] boolValue];
        if (musicState) {
            CCLOG(@"init music on");
            musicItem.selectedIndex = 0;
        }else{
            musicItem.selectedIndex = 1;
        }
        
        
       
        
        musicItem.position = ccp(200,280);
        
        
        CCMenuItem *audioOnItem = [CCMenuItemFont itemWithString:@"开" target:self 
                                                        selector:nil];
        audioOnItem.tag = 1;
        CCMenuItem *audioOffItem = [CCMenuItemFont itemWithString:@"关" target:self 
                                                         selector:nil];
        audioOffItem.tag = 0;
        
        CCMenuItemToggle *audioItem = [CCMenuItemToggle itemWithTarget:self
                                                              selector:@selector(toggleGameSoundEffect:)
                                                                 items:audioOffItem,audioOnItem, nil];
        audioItem.position = ccp(200,240);
        
        
        BOOL audioState = [[[NSUserDefaults standardUserDefaults] objectForKey:kAudioKey] boolValue];
        if (audioState) {
            CCLOG(@"init audio on");
            audioItem.selectedIndex = 0;
        }else {
            audioItem.selectedIndex = 1;
        }
       
        
        CCMenuItem *backItem = [CCMenuItemFont itemWithString:@"返回" 
                                                       target:self 
                                                     selector:@selector(goBack)];
        backItem.position = ccp(50,400);
        
        CCMenu *menu = [CCMenu menuWithItems:musicItem,audioItem,backItem, nil];
        menu.position = ccp(0,0);
        [self addChild:menu];
                
    }
    
    return self;
}

-(void) toggleGameMusic:(id)sender{
    CCMenuItemToggle *item = (CCMenuItemToggle*)sender;
    if (item.selectedIndex == 1) {
        CCLOG(@"music on");
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kMusicKey];
    }else{
        CCLOG(@"music off");
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kMusicKey];
    }
}

-(void) toggleGameSoundEffect:(id)sender{
    CCMenuItemToggle *item = (CCMenuItemToggle*)sender;
    if (item.selectedIndex == 1) {
        CCLOG(@"audio on");
        [SimpleAudioEngine sharedEngine].effectsVolume = 1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kAudioKey];
    }else{
        CCLOG(@"audio off");
        [SimpleAudioEngine sharedEngine].effectsVolume = 0;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kAudioKey];
    }
}

-(void) goBack{
    [[CCDirector sharedDirector] popScene];
}

@end
