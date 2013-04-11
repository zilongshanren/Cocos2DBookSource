//
//  BackLayer.m
//  Cocos2DShaderDemo
//
//  Created by guanghui on 7/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BackLayer.h"
#import "HelloWorldLayer.h"


@implementation BackLayer

-(id)init{
    if (self = [super init]) {
        // Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		CCMenuItem *backItem = [CCMenuItemFont itemWithString:@"MainMenu" block:^(id sender)
                                        {
                                            CCScene *scene = [CCScene node];
                                            HelloWorldLayer *layer = [HelloWorldLayer node];
                                            [scene addChild:layer];
                                            
                                            [[CCDirector sharedDirector] replaceScene:scene];
                                            
                                        }];
        backItem.position = ccp(80,280);
		
		CCMenu *menu = [CCMenu menuWithItems:backItem, nil];
		
        menu.position = CGPointZero;
		// Add the menu to the layer
		[self addChild:menu];

    }
    return self;
}
@end
