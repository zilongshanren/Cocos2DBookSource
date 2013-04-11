//
//  SettingsLayer.h
//  VerticalShootingGame
//
//  Created by guanghui qu on 6/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SettingsLayer : CCLayer {
    
}
+(id) scene;

-(void) toggleGameMusic:(id)sender;
-(void) toggleGameSoundEffect:(id)sender;
-(void) goBack;
@end
