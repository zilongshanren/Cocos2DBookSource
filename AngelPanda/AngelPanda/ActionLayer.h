//
//  ActionLayer.h
//  learning
//
//  Created by eseedo on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpriteArray.h"


typedef enum {
  kEndReasonWin,
  kEndReasonLose
} EndReason;

@interface ActionLayer: CCLayer{
    

  
  CCParallaxNode *backgroundNode;
  CCSprite *mainBg;
  CCSprite *mainBg2;
  CCSprite *cloud1;
  CCSprite *cloud2;
  CCSprite *cloud3;
  
  CCSprite *player;
  
  CCLabelBMFont * titleLabel1;
  CCLabelBMFont * titleLabel2;
  CCMenuItemLabel *playItem;
  
  CCSpriteBatchNode *batchNode;
  
  
  SpriteArray *missleArray;
  SpriteArray *groundObjectsArray;
  SpriteArray *airObjectsArray;
  SpriteArray *coinsArray;
  SpriteArray *aidArray;
  
  double nextMissleSpawn;
  double nextGroundObstacleSpawn;
  double nextAirObstacleSpawn;
  double nextCoinSpawn;
  double nextAid;
  double curTime;

  float playerPointsPerSecY;
  
  int lives;
  int score;
  double gameOverTime;
  bool gameOver;
    
    BOOL isGameStarted;
    
    int offset;

  
}
+(id)scene;
@end
