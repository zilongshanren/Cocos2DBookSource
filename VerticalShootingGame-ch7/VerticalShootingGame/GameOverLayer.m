//
//  GameOverLayer.m
//  VerticalShootingGame
//
//  Created by guanghui qu on 7/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameManager.h"
#import "GameLayer.h"
#import "MenuLayer.h"


@implementation GameOverLayer

+(id) scene{
    CCScene *sc = [CCScene node];
    CCLayer *layer = [GameOverLayer node];
    [sc addChild:layer];
    
    return sc;
}

-(id) init{
    if ((self = [super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:20];
        BOOL isGameWin = [GameManager sharedGameManager].isWin;
        if (isGameWin) {
            [titleLabel setString:@"恭喜你！成功过关。"];
        }else{
            [titleLabel setString:@"很遗憾！您没能成功过关。"];
        }
        titleLabel.position = CGPointMake(winSize.width/2, winSize.height - 50);
        [self addChild:titleLabel];
        
    
        int score = [GameManager sharedGameManager].score;
        NSString *scoreString = [NSString stringWithFormat:@"您的分数是:%d",score];
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Arial" fontSize:20];
        scoreLabel.position = ccpSub(titleLabel.position, ccp(0,50));
        [self addChild:scoreLabel];
        
        NSString *promtStr = nil;
        if (isGameWin) {
            promtStr = @"重新开始";
        }else{
            promtStr = @"再来一盘";
        }
        
        //初始化菜单项
        CCMenuItem *restartItem = [CCMenuItemFont itemWithString:promtStr 
                                                          target:self 
                                                        selector:@selector(restartGame)];
        CCMenuItem *backItem = [CCMenuItemFont itemWithString:@"回到主菜单" 
                                                       target:self 
                                                     selector:@selector(backToMainMenu)];
        CCMenu *menu = [CCMenu menuWithItems:restartItem,backItem, nil];
        menu.position = ccp(winSize.width/2,winSize.height / 2);
        [menu alignItemsVerticallyWithPadding:20];
        [self addChild:menu];
        
    }
    return self;
}

-(void) restartGame{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                                                                 scene:[GameLayer scene]
                                                                             withColor:ccWHITE]];
}

-(void) backToMainMenu{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                                                                 scene:[MenuLayer scene]
                                                                             withColor:ccWHITE]];
}
@end
