//
//  DragonWeapon.m
//  IAPGame
//
//  Created by Ricky on 11/5/12.
//  Copyright 2012 eseedo. All rights reserved.
//

#import "DragonWeapon.h"
#import "GameData.h"
#import "HelloWorldLayer.h"

@implementation DragonWeapon

+(CCScene *)scene{
    
    CCScene *scene = [CCScene node];
    DragonWeapon *layer = [DragonWeapon node];
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


-(void)showWeapons{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    [CCMenuItemFont setFontSize:25];
    
    CCSprite *dragonClothes = [CCSprite spriteWithFile:@"dragonclothes.png"];
    dragonClothes.position = ccp(size.width *0.2,size.height*0.5);
    [self addChild:dragonClothes];
    
    CCSprite *dragonFan = [CCSprite spriteWithFile:@"dragonfan.png"];
    dragonFan.position = ccp(size.width *0.5,size.height*0.5);
    [self addChild:dragonFan];
    
    CCSprite *dragonHat = [CCSprite spriteWithFile:@"dragonhat.png"];
    dragonHat.position = ccp(size.width *0.8,size.height*0.5);
    [self addChild:dragonHat];
    
    
    
    CCMenuItemFont *product1Item = [CCMenuItemFont itemWithString:@"购买"  target:self selector:@selector(buyClothes)];
    
    CCMenuItemFont *product2Item = [CCMenuItemFont itemWithString:@"购买"  target:self selector:@selector(buyFan)];
    
    CCMenuItemFont *product3Item = [CCMenuItemFont itemWithString:@"购买"  target:self selector:@selector(buyHat)];
    
    
    
    CCMenu *menu = [CCMenu menuWithItems:product1Item,product2Item,product3Item, nil];
    [menu alignItemsHorizontallyWithPadding:90];
    menu.position = ccp(size.width*0.5,size.height*0.22);
    
    [self addChild:menu z:0];
    
    
}

-(void)buyClothes{
    
    [self updateDragonCoins];
    if(dragonCoinsLeft < 10000){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您拥有的天龙币少于10000，无法购买天龙战甲" delegate:self cancelButtonTitle:@"知道了，我会尽快成为高富帅" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已成功购得天龙战甲！" delegate:self cancelButtonTitle:@"高富帅就是爽！" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [GameData sharedData].currentDragonCoins -= 10000;
    }
    
}

-(void)buyFan{
    
    [self updateDragonCoins];
    if(dragonCoinsLeft < 100000){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您拥有的天龙币少于100000，无法购买天龙宝扇" delegate:self cancelButtonTitle:@"知道了，我会尽快成为高富帅" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已成功购得天龙宝扇！" delegate:self cancelButtonTitle:@"高富帅就是爽！" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [GameData sharedData].currentDragonCoins -= 100000;
    }
}

-(void)buyHat{
    
    [self updateDragonCoins];
    if(dragonCoinsLeft < 500000){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您拥有的天龙币少于500000，无法购买天龙头盔" delegate:self cancelButtonTitle:@"知道了，我会尽快成为高富帅" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已成功购得天龙头盔！" delegate:self cancelButtonTitle:@"高富帅就是爽！" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [GameData sharedData].currentDragonCoins -= 500000;
    }
}

-(void)updateDragonCoins{
    
    dragonCoinsLeft = [GameData sharedData].currentDragonCoins;
    
}

-(id)init{
    if((self =[super init])){
        
        //添加返回按钮
        
        [self addButton];
        
        //显示可以购买的武器
        
        [self showWeapons];
    }
    return self;
    
}

@end