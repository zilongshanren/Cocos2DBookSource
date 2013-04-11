//
//  HelloWorldLayer.h
//  VerticalShootingGame
//
//  Created by guanghui qu on 5/28/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCArray *_enemySprites;
    CGPoint _playerVelocity;
    
    BOOL _isTouchToShoot;
    CCSprite *_bulletSprite;
    
    CCLabelTTF *_lifeLabel;
    CCLabelTTF *_scoreLabel;
    int     _totalLives;
    int     _totalScore;
    
    CCLabelTTF *_gameEndLabel;
    CCMenu  *_startGameMenu;
    BOOL    _isGameStarted;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
