//
//  MenuScene.h
//  VerticalShootingGame
//
//  Created by guanghui qu on 6/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MenuLayer : CCLayer {
    
}
+(id) scene;

-(void) highScoreScene;
-(void) settingsScene;
-(void) gameScene;
@end
