//
//  HelloWorldLayer.m
//  ParticleEffect
//
//  Created by Ricky on 11/5/12.
//  Copyright eseedo 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "MyParticle.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

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
		
        //    //创建一个基本的下雪粒子系统
        //    CCParticleSnow *snow = [CCParticleSnow node];
        //
        //    //将该粒子系统添加到当前层的子节点
        //    [self addChild:snow z:1];
        
        self.isTouchEnabled = YES;

	}
	return self;
}

-(void)registerWithTouchDispatcher{
    CCDirector *director = [CCDirector sharedDirector];
    [[director touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    
    
    return YES;
    
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector]convertToGL:touchLocation];
    touchLocation =[self convertToNodeSpace:touchLocation];
    
//     MyParticle *myParticle =[MyParticle node];
//    [self addChild:myParticle z:1];
//    //  //
//     myParticle.position = touchLocation;
    
//    CCParticleSystemQuad *particle =[CCParticleSystemQuad particleWithFile:@"particle.plist"];
//CCParticleSystemQuad *particle = [CCParticleSystemQuad particleWithFile:@"pea.plist"];
//    [self addChild:particle z:1];
//    particle.position = touchLocation;
    
//    CCParticleSystemQuad *particle = [CCParticleSystemQuad particleWithFile:@"blue.plist"];
//    [self addChild:particle z:1];
//    particle.position = touchLocation;
    
    
//    CCParticleSystemQuad *particle2 = [CCParticleSystemQuad particleWithFile:@"emitter.plist"];
//    [self addChild:particle2 z:1];
//    particle2.position = touchLocation;
    
//    CCParticleSystemQuad *particle3 = [CCParticleSystemQuad particleWithFile:@"particle.plist"];
//    [self addChild:particle3 z:1];
//    particle3.position = touchLocation;
    
       CCParticleSnow *snow = [CCParticleSnow node];
    snow.position = touchLocation;
    snow.duration = 1;
  
    //    //将该粒子系统添加到当前层的子节点
    [self addChild:snow z:1];
}




// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
