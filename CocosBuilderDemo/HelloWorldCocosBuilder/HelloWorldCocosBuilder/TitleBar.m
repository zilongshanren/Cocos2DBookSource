//
//  TitleBar.m
//  HelloWorldCocosBuilder
//
//  Created by guanghui on 7/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleBar.h"
#import "CCBReader.h"

@implementation TitleBar

-(void) onBack:(id)sender{
    CCScene *scene = [CCBReader sceneWithNodeGraphFromFile:@"HelloWorldCocosBuilder.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}
@end
