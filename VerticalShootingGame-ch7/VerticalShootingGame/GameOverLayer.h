//
//  GameOverLayer.h
//  VerticalShootingGame
//
//  Created by guanghui qu on 7/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayer {
    
}
+(id) scene;

-(void) restartGame;
-(void) backToMainMenu;
@end
