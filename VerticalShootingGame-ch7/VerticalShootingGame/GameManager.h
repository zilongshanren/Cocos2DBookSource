//
//  GameManager.h
//  VerticalShootingGame
//
//  Created by guanghui qu on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject<NSCoding>{
    NSMutableArray *highScores;
    
    BOOL    isWin;  //游戏结束时设置，如果赢了则为YES
    int     score;  //当前游戏分数
    int     playTimes; //总共玩了几把游戏.如果超过3次，则在玩家第3次打开游戏的时候弹出提示，请玩家为游戏评分
}
@property(nonatomic,copy)NSMutableArray* highScores;
@property(nonatomic,assign)BOOL isWin;
@property(nonatomic,assign)int score;
@property(nonatomic,assign)int playTimes;

+(GameManager*) sharedGameManager;
+(void) purge;
+(void) loadState;
+(void) saveState;
+(NSString*) makeSavePath;

-(void) clear;
-(NSMutableArray*) top3Scores;
-(void) addNewHighScore:(int)newScore;
@end
