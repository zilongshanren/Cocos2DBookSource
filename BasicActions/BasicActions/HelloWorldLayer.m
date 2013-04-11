//
//  HelloWorldLayer.m
//  BasicActions
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
		
        //  请先注释或删除模板中自带的代码
        
        //  创建并初始化精灵对象
        CCSprite *ball = [CCSprite spriteWithFile:@"ball.png"];
        CCSprite *plane = [CCSprite spriteWithFile:@"plane.png"];
        
        //  获取屏幕大小并设置精灵的位置
        CGSize size = [CCDirector sharedDirector].winSize;
        ball.position = ccp(ball.contentSize.width,size.height/2);
        plane.position = ccp(-size.width/2,100+size.height/2);
        
        //  将精灵对象添加为当前层的子节点
        [self addChild:ball];
        [self addChild:plane];
        
        //  定义一个CCAction动作
        CCAction *moveAction = [CCMoveTo actionWithDuration:5.0 position:ccp(size.width*1.2,100+size.height/2)];
        
        //  让精灵对象执行该动作
        [plane runAction:moveAction];
        
        //  使用以下代码可以实现与上面两行代码相同的效果
        //  [plane runAction:[CCMoveTo actionWithDuration:5.0 position:ccp(size.width/2,100+size.height/2)]];
        
        //  基本动作示例
        //  要查看某种动作的效果，直接取消对相关代码的注释即可。
        //  CCMoveTo动作让节点对象在一定时间内移动到屏幕的某一位置
        //  [plane runAction:[CCMoveTo actionWithDuration:5.0 position:ccp(size.width/2,100+size.height/2)]];
        
        //  CCMoveBy:让节点对象在一定时间内从原位置相对移动一定的像素值
        //  [plane runAction:[CCMoveBy actionWithDuration:5.0 position:ccp(size.width,0)]];
        
        //  CCJumpTo:让节点对象在一定时间内沿抛物线移动到屏幕的某一特定位置
        //  [ball runAction:[CCJumpTo actionWithDuration:5.0 position:ccp(size.width-ball.contentSize.width,size.height/3) height:50 jumps:3]];
        
        //  CCJumpBy:让节点对象在一定时间内沿抛物线移动到屏幕的某一特定位置,和CCJumpTo的区别在于节点对象的位移是相对的
        //  [ball runAction:[CCJumpBy actionWithDuration:5.0 position:ccp(200,100) height:50 jumps:5]];
        
        //  CCBezierTo：让节点对象在一定时间内沿三次贝塞尔曲线移动到屏幕的某一位置
        //  ccBezierConfig c = {ccp(300, 200),ccp(50,50),ccp(-50,-50)};
        //  [ball runAction:[CCBezierTo actionWithDuration:3.0 bezier:c]];
        
        //  CCBezierBy：让节点对象在一定时间内沿三次贝塞尔曲线移动到屏幕的目标位置
        //  ccBezierConfig c = {ccp(200,100),ccp(50,50),ccp(-50,-50)};
        //  [ball runAction:[CCBezierBy actionWithDuration:3.0 bezier:c]];
        
        //  CCPlace:将节点对象直接放置在所需的位置
        //    [ball runAction:[CCPlace actionWithPosition:ccp(200,200)]];
        
        //  CCScaleTo:让节点对象在一定时间内缩放到某个特定的比例大小
        //    [ball runAction:[CCScaleTo actionWithDuration:2.0 scale:2]];
        //    [ball runAction:[CCScaleTo actionWithDuration:2.0 scaleX:1 scaleY:2]];
        
        //  CCScaleBy:让节点对象在一定时间内缩放某个特定的比例大小
        //    [ball runAction:[CCScaleBy actionWithDuration:2.0 scale:0.5]];
        //    [ball runAction:[CCScaleBy actionWithDuration:2.0 scaleX:0.5 scaleY:0.5]];
        
        //  CCRotateTo:让节点对象在一定时间内旋转到某个特定的角度
        //  [ball runAction:[CCRotateTo actionWithDuration:2.0 angle:270]];
        
        //  CCRotateBy：更改节点对象的角度属性，让节点对象在一定时间内旋转某个特定的角度
        //    [ball runAction:[CCRotateBy actionWithDuration:2.0 angle:100]];
        
        //  CCShow：立即显示节点对象
        //    [ball runAction:[CCShow action]];
        
        //  CCHide: 立即隐藏节点对象
        //    [ball runAction:[CCHide action]];
        
        //  CCToggleVisibility:切换节点对象的可视属性
        //    [ball runAction:[CCToggleVisibility action]];
        
        //  CCBlink:让节点对象在一定时间内闪动某个特定的次数
        //    [ball runAction:[CCBlink actionWithDuration:5.0 blinks:10]];
        
        //  CCFadeIn：让节点对象在一定时间内淡入（将其透明度从0调整为255）
        //    [ball runAction:[CCFadeIn actionWithDuration:3.0]];
        
        //  CCFadeOut:让节点对象在一定时间内淡出（将其透明度从255调整为0）
        //    [ball runAction:[CCFadeOut actionWithDuration:3.0]];
        
        //  CCFadeTo:在一定时间内修改节点对象的透明度到某一特定的数值
        //    [ball runAction:[CCFadeTo actionWithDuration:3.0 opacity:100]];
        
        //  CCTintTo:在一定时间内修改节点对象的色彩到某一特定的RGB色彩值
        //    [ball runAction:[CCTintTo actionWithDuration:5.0 red:200 green:150 blue:100]];
        
        //  CCTintBy:在一定时间内根据某一特定的RGB色彩值将节点着色
        //    [ball runAction:[CCTintBy actionWithDuration:5.0 red:200 green:150 blue:100]];
        
        //  CCFlipX:让节点对象沿着水平方向翻转
        //  [plane runAction:[CCPlace actionWithPosition:ccp(200,200)]];
        //  [plane runAction:[CCFlipX actionWithFlipX:YES]];
        
        //  CCFlipY：让节点对象沿着垂直方向翻转
        //  [plane runAction:[CCPlace actionWithPosition:ccp(200,200)]];
        //  [plane runAction:[CCFlipY actionWithFlipY:YES]];
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
