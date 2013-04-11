//
//  HelloWorldLayer.m
//  AnimationActions
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

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        //以下的内容会在此处添加代码，以生成动画效果。
        
        //  简单的动画实现方式
        
        //  创建精灵对象并将其添加为当前层的子节点
        
        //    CGSize size = [CCDirector sharedDirector].winSize;
        
        //    CCSprite *mySprite = [CCSprite spriteWithFile:@"pandawalk1.png"];
        //    mySprite.position = ccp(size.width/2,size.height/2);
        //    [self addChild:mySprite];
        
        //  创建CCAnimation动画，指定动画帧的内容
        
        //    CCAnimation *anim = [CCAnimation animation];
        //    [anim addFrameWithFilename:@"pandawalk1.png"];
        //    [anim addFrameWithFilename:@"pandawalk2.png"];
        //    [anim addFrameWithFilename:@"pandawalk3.png"];
        
        //  创建CCAnimate动画动作，并让精灵对象执行
        
        //    id animAction = [CCAnimate actionWithDuration:0.5f animation:anim restoreOriginalFrame:YES];
        //    id repeatanimAction = [CCRepeatForever actionWithAction:animAction];
        //    [mySprite runAction:repeatanimAction];
        
        
        //  以下的内容会在此处添加代码，以生成动画效果。
        //  1.使用plist文件将精灵帧和纹理添加到精灵帧缓存中
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"AnimPanda.plist"];
        
        
        //  2.创建一个CCSpriteBatchNode（精灵表单）对象
        CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"AnimPanda.png"];
        [self addChild:batchNode];
        
        //  3.创建图片帧列表
        
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        
        for(int i=1; i<3;i++){
            [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"pandawalk%d.png",i]]];
            
        }
        
        
        //  4.创建动画对象
         CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
        //使用下面的方法调用就不会产生警告，因为上面的方法调用形式以后可能会被废弃
        //CCAnimation *walkAnim =[CCAnimation animationWithSpriteFrames:animFrames delay:0.6f];
        
        //  5.创建精灵对象，并运行动画动作
        CGSize size = [CCDirector sharedDirector].winSize;
        CCSprite *panda = [CCSprite spriteWithSpriteFrameName:@"pandawalk1.png"];
        panda.position = ccp(size.width*0.8,size.height*0.4);
        
        
        id walkAction = [CCRepeatForever actionWithAction:
                         [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:YES]];
        
        [panda runAction:walkAction];
        id moveAction =[CCMoveTo actionWithDuration:20.0f position:ccp(size.width*0.2,size.height*0.4)];
        
        [panda runAction:moveAction];
        
        [batchNode addChild:panda];
        self.isTouchEnabled = YES;

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
