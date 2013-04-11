//
//  HelloWorldLayer.m
//  AccelEvents
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
		
        ball =[CCSprite spriteWithFile:@"ball.png"];
        
        CGSize size = [CCDirector sharedDirector].winSize;
        ball.position = ccp(size.width/2,size.height/2);
        
        [self addChild:ball];
        
        self.isAccelerometerEnabled = YES;
        [self scheduleUpdate];
        
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


-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    //最简单的使用加速计数据的方法，但不灵敏
    //  CGPoint pos = ball.position;
    //  pos.x += acceleration.x *10;
    //  pos.y += acceleration.y *10;
    //  ball.position = pos;
    //此处将添加更多代码
    
    
#define kFilteringFactor 0.1
#define kRestAccelY -0.6
#define kMaxDiffX 0.2
#define kMaxDiffY 0.2
#define kMaxPointsPerSecX (winSize.width*0.5)
#define kMaxPointsPerSecY (winSize.height*0.5)
    
    
    UIAccelerationValue rollingX,rollingY;
    //  UIAccelerationValue rollingZ;
    
    rollingX = (acceleration.x * kFilteringFactor) +(rollingX *(1.0 - kFilteringFactor));
    rollingY = (acceleration.y * kFilteringFactor) +(rollingY *(1.0 - kFilteringFactor));
    //  rollingZ = (acceleration.z * kFilteringFactor) +(rollingZ *(1.0 - kFilteringFactor));
    
    float accelX = acceleration.x - rollingX;
    float accelY = acceleration.y - rollingY;
    //  float accelZ = acceleration.z - rollingZ;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    float accelFractionX = accelX / kMaxDiffX;
    float pointsPerSecX = kMaxPointsPerSecX * accelFractionX;
    
    float accelDiffY = accelY - kRestAccelY;
    float accelFractionY = accelDiffY /kMaxDiffY;
    float pointsPerSecY = kMaxPointsPerSecY * accelFractionY;
    
    velocityX = pointsPerSecX;
    velocityY = pointsPerSecY;
    
    
}


-(void)update:(ccTime)delta{
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //设置小球在横向和纵向的移动边界
    
    float maxY = winSize.height -ball.contentSize.height/2;
    float minY = ball.contentSize.height/2;
    
    float maxX = winSize.width - ball.contentSize.width/2;
    float minX = ball.contentSize.width/2;
    
    //根据加速度数据计算出小球的最终y坐标，注意使用了一个简单的算法来确保小球不会超出边界
    
    float newY = ball.position.y + (velocityY *delta);
    newY = MIN(MAX(newY, minY),maxY);
    
    //根据加速度数据计算出小球的最终x坐标，注意使用了一个简单的算法来确保小球不会超出边界
    
    float newX = ball.position.x + (velocityX *delta);
    newX = MIN(MAX(newX, minX),maxX);
    
    //更新小球的位置
    ball.position = ccp(newX,newY);
    
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
