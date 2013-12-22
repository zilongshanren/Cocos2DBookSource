//
//  CurrentCoins.m
//  IAPGame
//
//  Created by Ricky on 11/5/12.
//  Copyright 2012 eseedo. All rights reserved.
//

#import "CurrentCoins.h"
#import "HelloWorldLayer.h"
#import "GameData.h"


@implementation CurrentCoins


+(CCScene *)scene{
    
    CCScene *scene = [CCScene node];
    CurrentCoins *layer = [CurrentCoins node];
    [scene addChild:layer];
    return scene;
    
    
}

-(void)addButton{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    CCMenuItemFont *item = [CCMenuItemFont itemWithString:@"返回主界面" target:self selector:@selector(backToMain)];
    item.fontSize = 25;
    
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    
    menu.position = ccp(size.width*0.15,size.height*0.8);
    
    [self addChild:menu];
    
}

-(void)backToMain{
    
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:2.0f scene:[HelloWorldLayer scene]];
    [[CCDirector sharedDirector]pushScene:transition];
    
}


-(void)showCurrentCoins{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    CCLabelTTF *text = [CCLabelTTF labelWithString:@"您当前拥有的金龙币数量是" fontName:@"ArialMT" fontSize:25.0];
    text.position = ccp(size.width *0.5,size.height*0.6);
    [self addChild:text];
    
    NSString *currentCoins = [NSString stringWithFormat:@"%d",[GameData sharedData].currentDragonCoins];
    
    CCLabelTTF *coinNumber = [CCLabelTTF labelWithString:currentCoins fontName:@"ArialMT" fontSize:35.0];
    coinNumber.position = ccp(size.width *0.5,size.height*0.3);
    [self addChild:coinNumber];
    
}

-(id)init{
    if((self =[super init])){
        
        [self addButton];
        
        //显示天龙币余额
        [self showCurrentCoins];
    }
    return self;
    
}

@end
