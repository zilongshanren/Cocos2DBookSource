//
//  MenuScene.m
//  VerticalShootingGame
//
//  Created by guanghui qu on 6/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "GameLayer.h"
#import "SettingsLayer.h"
#import "HighScoreLayer.h"


@implementation MenuLayer

+(id) scene{
    CCScene *sc = [CCScene node];
    
    MenuLayer* layer = [MenuLayer node];
    
    [sc addChild:layer];
    
    return sc;
}


-(id) init{
    if ((self = [super init])) {
        CCMenuItem *highScoreItem = [CCMenuItemFont itemWithString:@"高分榜"
                                                            target:self 
                                                          selector:@selector(highScoreScene)];
        CCMenuItem *settingsItem = [CCMenuItemFont itemWithString:@"设置"
                                                           target:self
                                                         selector:@selector(settingsScene)];
        CCMenuItem *gameItem = [CCMenuItemFont itemWithString:@"进入游戏"
                                                       target:self 
                                                     selector:@selector(gameScene)];
        CCMenu *menu = [CCMenu menuWithItems:gameItem,highScoreItem,settingsItem, nil];
        menu.position = ccp(160,240);
        [self addChild:menu];
        
        [menu alignItemsVerticallyWithPadding:20];
    }
    return self;
}

-(void) highScoreScene{
    [[CCDirector sharedDirector] pushScene:[HighScoreLayer scene]];
}

-(void) settingsScene{
    [[CCDirector sharedDirector] pushScene:[SettingsLayer scene]];
}

-(void) gameScene{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                                                                 scene:[GameLayer scene]
                                                                             withColor:ccWHITE]];
}

@end
