//
//  HighScoreLayer.m
//  VerticalShootingGame
//
//  Created by guanghui qu on 7/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HighScoreLayer.h"
#import "GameManager.h"


@implementation HighScoreLayer

+(id) scene{
    CCScene *sc = [CCScene node];
    CCLayer *layer = [HighScoreLayer node];
    [sc addChild:layer];
    return sc;
}

-(id) init{
    if ((self = [super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"前三名:" fontName:@"Arial" fontSize:20];
        titleLabel.position = ccp(winSize.width / 2, winSize.height - 50);
        [self addChild:titleLabel];
        
        //根据游戏存档显示前三名的分数
        const int SCORE_POS_X = winSize.width / 2;
        const int SCORE_POS_Y = winSize.height - 100;
        const int VERTICAL_PADDING = 50;
        NSArray *highScores = [GameManager sharedGameManager].top3Scores;
        for (int i=0; i < [highScores count]; ++i) {
            int score = [[highScores objectAtIndex:i] intValue];
            NSString *scoreString = [NSString stringWithFormat:@"%d",score];
            CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Arial" fontSize:20];
            scoreLabel.position = CGPointMake(SCORE_POS_X, SCORE_POS_Y - i * VERTICAL_PADDING);
            [self addChild:scoreLabel];
        }
        
        CCMenuItem *backItem = [CCMenuItemFont itemWithString:@"返回主菜单" target:self selector:@selector(goBack)];
        backItem.position = CGPointMake(100, 50);
        
        CCMenu *menu = [CCMenu menuWithItems:backItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
    }
    return self;
}

-(void) goBack{
    [[CCDirector sharedDirector] popScene];
}

@end
