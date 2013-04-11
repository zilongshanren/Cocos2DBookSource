//
//  LevelResult.h
//  AngryPanda
//
//  Created by Ricky Wang on 3/22/12.

//  该类用于显示当前关卡结束后的相关信息，如关卡得分，是否通关，历史最高得分，等等。

//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"

@interface LevelResult : CCLayer {
    
    //当前关卡名称
    NSString *levelName;
    //当前关卡得分
    int levelScore;
    //当前关卡的历史最高得分
    int highestScore;
    //当前关卡是否成功通过
    BOOL levelClear;
    //当前关卡的编号
    int levelNumber;
    //当前场景的编号
    int chapterNumber;
    
    //已通过的关卡数量
    int levelSolved;
    //背景精灵图片
    CCSprite *resultBg;
    
    //设备类型
    int deviceType;
}

+(CCScene *) scene;


@end