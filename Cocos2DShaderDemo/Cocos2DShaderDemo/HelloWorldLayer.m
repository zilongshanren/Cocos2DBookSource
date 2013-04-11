//
//  HelloWorldLayer.m
//  Cocos2DShaderDemo
//
//  Created by guanghui on 7/28/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "VertexShaderTest.h"
#import "FragmentShaderTest.h"
#import "SwirlEffectShader.h"
#import "PixelationShader.h"
#import "NightVisionShaderTest.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CGSize size = [[CCDirector sharedDirector] winSize];
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		
		CCMenuItem *itemVertexShader = [CCMenuItemFont itemWithString:@"VertexShaderTest" block:^(id sender)
        {
			CCScene *scene = [CCScene node];
            VertexShaderTest *layer = [VertexShaderTest node];
            [scene addChild:layer];
            
            [[CCDirector sharedDirector] replaceScene:scene];
			
		}];
        
        CCMenuItem *itemFragmentShader = [CCMenuItemFont itemWithString:@"FragmentShaderTest" block:^(id sender)
                                        {
                                            CCScene *scene = [CCScene node];
                                            FragmentShaderTest *layer = [FragmentShaderTest node];
                                            [scene addChild:layer];
                                            
                                            [[CCDirector sharedDirector] replaceScene:scene];
                                            
                                        }];
        
        CCMenuItem *itemSwirlShader = [CCMenuItemFont itemWithString:@"SwirlEffect" block:^(id sender)
                                          {
                                              CCScene *scene = [CCScene node];
                                              SwirlEffectShader *layer = [SwirlEffectShader node];
                                              [scene addChild:layer];
                                              
                                              [[CCDirector sharedDirector] replaceScene:scene];
                                              
                                          }];
        
        CCMenuItem *itemPixelationShader = [CCMenuItemFont itemWithString:@"Pixelation" block:^(id sender)
                                       {
                                           CCScene *scene = [CCScene node];
                                           PixelationShader *layer = [PixelationShader node];
                                           [scene addChild:layer];
                                           
                                           [[CCDirector sharedDirector] replaceScene:scene];
                                           
                                       }];

        CCMenuItem *itemNightVisionShader = [CCMenuItemFont itemWithString:@"NightVision" block:^(id sender)
                                            {
                                                CCScene *scene = [CCScene node];
                                                NightVisionShaderTest *layer = [NightVisionShaderTest node];
                                                [scene addChild:layer];
                                                
                                                [[CCDirector sharedDirector] replaceScene:scene];
                                                
                                            }];

		
		CCMenu *menu = [CCMenu menuWithItems:itemVertexShader,itemFragmentShader,itemSwirlShader,
                        itemPixelationShader,itemNightVisionShader, nil];
		
		[menu alignItemsVerticallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2)];
		
		// Add the menu to the layer
		[self addChild:menu];

	}
	return self;
}

@end
