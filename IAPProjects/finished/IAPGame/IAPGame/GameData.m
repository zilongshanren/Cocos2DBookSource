//
//  GameData.m
//  IAPGame
//
//  Created by Ricky on 11/5/12.
//  Copyright 2012 eseedo. All rights reserved.
//

#import "GameData.h"

@implementation GameData

@synthesize currentDragonCoins;
@synthesize dragonClothes,dragonHat,dragonFan;

static GameData *sharedData = nil;

+(GameData*) sharedData {
    
    if (sharedData == nil) {
        sharedData = [[GameData alloc] init] ;
        
    }
    return  sharedData;
    
}

-(id)init{
    
    
    if((self = [super init])){
        
        sharedData = self;
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        currentDragonCoins = [defaults integerForKey:@"currentDragonCoins"];
        
        dragonClothes = [defaults integerForKey:@"dragonClothes"];
        
        dragonFan = [defaults integerForKey:@"dragonFan"];
        
        dragonHat = [defaults integerForKey:@"dragonHat"];
    }
    return self;
    
}


@end
