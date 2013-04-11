//
//  HelloWorldCocosBuilder.m
//  HelloWorldCocosBuilder
//
//  Created by guanghui on 7/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldCocosBuilder.h"
#import "CCBReader.h"

@implementation HelloWorldCocosBuilder

-(void) didLoadFromCCB{
    [_sprtBurst runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:4.0 angle:360]]];
}

-(void) onEnterGame:(id)sender{
    CCLOG(@"onEnterGame!");
    [self goCCBScene:@"GameMenu.ccbi"];
}

-(void) onAbout:(id)sender{
    CCLOG(@"onAbout");
    [self goCCBScene:@"About.ccbi"];
}

-(void) goCCBScene:(NSString*)ccbName{
    CCScene *scene = [CCBReader sceneWithNodeGraphFromFile:ccbName owner:self];
    
    [_lblTitle setString:ccbName];
    
    [[CCDirector sharedDirector] replaceScene:scene];
}
@end
