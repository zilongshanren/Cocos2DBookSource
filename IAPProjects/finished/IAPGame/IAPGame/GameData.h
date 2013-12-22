//
//  GameData.h
//  IAPGame
//
//  Created by Ricky on 11/5/12.
//  Copyright 2012 eseedo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject{
    
    int currentDragonCoins;
    
    //道具数量
    int dragonClothes;
    int dragonFan;
    int dragonHat;
    
    //系统默认设置
    NSUserDefaults* defaults;
    
}

@property(nonatomic,assign) NSInteger currentDragonCoins;
@property(nonatomic,assign) NSInteger dragonClothes;
@property(nonatomic,assign) NSInteger dragonFan;
@property(nonatomic,assign) NSInteger dragonHat;

+(GameData*) sharedData;

@end
