//
//  HelloWorldLayer.m
//  TouchEvents
//
//  Created by eseedo on 2/11/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

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
	if( (self=[super init])) {
		
        ball = [CCSprite spriteWithFile:@"ball.png"];
        
        CGSize size = [CCDirector sharedDirector].winSize;
        ball.position = ccp(size.width/2,size.height/2);
        
        [self addChild:ball];
        
	}
	return self;
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


- (void)onEnter
{
	CCDirector *director =  [CCDirector sharedDirector];
    
	[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	CCDirector *director = [CCDirector sharedDirector];
    
	[[director touchDispatcher] removeDelegate:self];
	[super onExit];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    float velocity = 480.0/3.0;
    
    CGPoint moveDifference =ccpSub(touchLocation, ball.position);
    float moveDistance = ccpLength(moveDifference);
    
    float moveDuration = moveDistance/velocity;
    
    if(moveDifference.x < 0){
        ball.flipX = NO;
    }else{
        ball.flipX = YES;
    }
    
    
    id moveAction = [CCMoveTo actionWithDuration:moveDuration position:touchLocation];
    [ball runAction:moveAction];
    
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
