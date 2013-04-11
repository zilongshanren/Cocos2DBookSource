//
//  HelloWorldLayer.h
//  VerticalShootingGame
//
//  Created by guanghui qu on 5/28/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "PauseLayer.h"


// HelloWorldLayer
@interface GameLayer : CCLayer<PauseLayerProtocol>
{
    CCArray *_enemySprites;
    CGPoint _playerVelocity;
    
    BOOL _isTouchToShoot;
    CCSprite *_bulletSprite;
    
    CCLabelBMFont *_lifeLabel;
    CCLabelBMFont *_scoreLabel;
    int     _totalLives;
    int     _totalScore;
    
    CCLabelTTF *_gameEndLabel;
    CCMenu  *_startGameMenu;
    BOOL    _isGameStarted;
    
    CCParallaxNode *_backgroundNode;
    int     _totalSeconds; //游戏进行时长
    ccTime  _consumedTime;//已消耗的游戏时长
    CCLabelBMFont *_countdownLabel;
    
    id      _playerFlyAction; //玩家飞机飞行动画
    
    id      _playerBlowupAnimation; //玩家飞机爆炸动画
    id      _enemyBlowupAnimation; //敌机爆炸动画
    BOOL    _isEnemyCollidable; //敌机是否可以碰撞
    BOOL    _isPlayerCollidable; //玩家飞机是否可以碰撞
    
    //for game pause
    BOOL _isGamePause;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;



@end
