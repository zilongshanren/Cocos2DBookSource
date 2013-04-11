//
//  HelloWorldLayer.m
//  CallbackActions
//
//  Created by guanghui on 9/5/12.
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

-(void)moveSprite{
    [ball runAction:[CCMoveTo actionWithDuration:2 position:ccp(50,200)]];
    
}

-(void)removeSprite:(id)sender{
    CCNode *node =(CCNode *)sender;
    [self removeChild:node cleanup:YES];
}

-(void)tintSprite:(id)sender data:(void*)data{
    
    CCNode *node = (CCNode *)sender;
    [node runAction:[CCTintBy actionWithDuration:(NSInteger)data red:255 green:0 blue:255]];
}


-(void)rotateSprite:(id)sender object:(id)object {
    
    CCNode *node = (CCNode*)object;
    [node runAction:[CCSequence actions:[CCFadeIn actionWithDuration:2.0f],
                     [CCRotateBy actionWithDuration:3.0 angle:180],nil]];
    
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		//获取当前屏幕的大小
        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        //    创建第一个精灵，并将其添加为当前层的子节点
        
        apple = [CCSprite spriteWithFile:@"apple.png"];
        apple.position = ccp(50,100);
        apple.opacity = 0;
        [self addChild:apple];
        
        //    创建第二个精灵，并将其添加为当前层的子节点
        
        plane = [CCSprite spriteWithFile:@"plane.png"];
        plane.position = ccp(size.width/2,size.height/2);
        plane.opacity  = 0;
        [self addChild: plane];
        
        
        
        //    创建第三个精灵，并将其添加为当前层的子节点
        
        ball = [CCSprite spriteWithFile:@"ball.png"];
        ball.position = ccp(250,100);
        ball.opacity = 0;
        [self addChild:ball];
        
        //    创建第四个精灵，并将其添加为当前层的子节点
        
        orange = [CCSprite spriteWithFile:@"orange.png"];
        orange.position = ccp(250,300);
        orange.opacity = 0;
        [self addChild:orange];
        
        //    创建第五个精灵，并将其添加为当前层的子节点
        
        tomato = [CCSprite spriteWithFile:@"tomato.png"];
        tomato.position = ccp(250,200);
        tomato.opacity = 0;
        [self addChild:tomato];
        
        //    第一个精灵执行序列组合动作，其中最后一个动作调用了moveSprite方法
        
        [apple runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],
                          [CCSpawn actions:
                           [CCFadeIn actionWithDuration:1],
                           [CCScaleTo actionWithDuration:1 scale:1.5],
                           nil],
                          [CCDelayTime actionWithDuration:1],
                          [CCCallFunc actionWithTarget:self selector:@selector(moveSprite)],
                          nil]];
        
        //    第二个精灵执行序列组合动作，其中最后一个动作调用了removeSprite:方法，并将当前的节点对象传递给指定的方法，注意冒号不能省略
        
        [plane runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],
                          [CCSpawn actions:
                           [CCFadeIn actionWithDuration:1],
                           [CCScaleTo actionWithDuration:1 scale:1.5],
                           nil],
                          [CCDelayTime actionWithDuration:1],
                          [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)],
                          nil]];
        
        //    第三个精灵执行序列组合动作，其中最后一个动作调用了tintSprite:data:方法，并将当前的节点对象和数据传递给指定的方法，注意冒号和参数不能省略
        
        [ball runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],
                         [CCSpawn actions:
                          [CCFadeIn actionWithDuration:1],
                          [CCScaleTo actionWithDuration:1 scale:1.5],
                          nil],
                         [CCDelayTime actionWithDuration:1],
                         [CCCallFuncND actionWithTarget:self selector:@selector(tintSprite:data:)data:(void *)2],
                         nil]];
        
        //    第四个精灵执行序列组合动作，其中最后一个动作调用了tintSprite:data:方法，并将当前的节点对象和数据传递给指定的方法，注意冒号和参数不能省略
        
        [orange runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],
                           [CCSpawn actions:
                            [CCFadeIn actionWithDuration:1],
                            [CCScaleTo actionWithDuration:1 scale:1.5], 
                            nil], 
                           [CCDelayTime actionWithDuration:1],
                           [CCCallFuncO actionWithTarget:self selector:@selector(rotateSprite:object:) object:tomato],
                           nil]];
		
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
