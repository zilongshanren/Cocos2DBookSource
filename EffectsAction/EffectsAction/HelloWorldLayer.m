//
//  HelloWorldLayer.m
//  EffectsAction
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
		
        //  创建并初始化精灵对象
        CCSprite *mySprite = [CCSprite spriteWithFile:@"panda.png"];
        CCSprite *ball = [CCSprite spriteWithFile:@"ball.png"];
        
        
        //  获取屏幕大小
        CGSize size = [CCDirector sharedDirector].winSize;
        mySprite.position = ccp(size.width/2,size.height/2);
        ball.position = ccp(200+size.width/2,size.height/2);
        
        
        //  将精灵对象添加为当前层的子节点
        [self addChild:mySprite];
        [self addChild:ball];
        
        //    下面是各种特效动作的实现代码
        //    如果要查看某种特效动作的效果，可以取消对相应代码的注释
        
        //    CCWaves:通过更改节点对象的网格属性，让节点对象产生类似波动的效果。
        
        //    id effect = [CCWaves actionWithWaves:10 amplitude:50 horizontal:YES vertical:YES grid:ccg(10,10) duration:5];
        //    [mySprite runAction:effect];
        
        //    CCWaves3D：通过更改节点对象的网格属性，让节点对象产生类似三维波动的效果。
        //    id effectWaves3D = [CCWaves3D actionWithWaves:10 amplitude:40 grid:ccg(12,12) duration:5];
        //    [mySprite runAction:effectWaves3D];
        
        
        //    CCFlipX3D:通过更改节点对象的网格属性，让节点对象沿着水平方向产生三维翻转效果。需要注意的是，虽然这里提供了ccg参数，但默认情况下只能使用ccg(1,1)。
        //    id effectFlipX3D = [CCFlipX3D actionWithSize:ccg(1,1) duration:2];
        //    id effectFlipX3Dback =[effectFlipX3D reverse];
        //    [mySprite runAction:[CCSequence actions:effectFlipX3D,[CCDelayTime actionWithDuration:2], effectFlipX3Dback,nil]];
        
        
        //    CCFlipY3D: 通过更改节点对象的网格属性，让节点对象沿着垂直方向产生三维翻转效果。
        //    id effectFlipY3D = [CCFlipY3D actionWithDuration:2];
        //    id effectFlipY3Dback = [effectFlipY3D reverse];
        //    [mySprite runAction:[CCSequence actions:effectFlipY3D,[CCDelayTime actionWithDuration:2], effectFlipY3Dback, nil]];
        
        //    CCLens3D: 通过更改节点对象的网格属性，让节点对象产生类似镜面三维效果。
        //    id effectLens3D = [CCLens3D actionWithPosition:ccp(size.width/2,size.height/2) radius:240 grid:ccg(15,10) duration:3];
        //    [mySprite runAction: effectLens3D];
        
        //    CCRipple3D: 通过更改节点对象的网格属性，让节点对象产生类似水面涟漪的三维波动效果。
        //    id effectRipple3D = [CCRipple3D  actionWithPosition:ccp(size.width/2,size.height/2) radius:240 waves:4 amplitude:160 grid:ccg(32,24) duration:5];
        //    [mySprite runAction:effectRipple3D];
        
        //    CCShaky3D: 通过更改节点对象的网格属性，让节点对象产生类似三维摇晃效果。
        //    id effectShaky3D = [CCShaky3D actionWithRange:5 shakeZ:YES grid:ccg(10,10) duration:3];
        //    [mySprite runAction:effectShaky3D];
        
        //    CCLiquid: 通过更改节点对象的网格属性，让节点对象产生类似液体流动的效果。
        //    id effectLiquid = [CCLiquid actionWithWaves:10 amplitude:22 grid:ccg(16,10) duration:5];
        //    [ball runAction:effectLiquid];
        
        //    CCTwirl: 通过更改节点对象的网格属性，让节点对象产生漩涡效果。
        //    id effectTwirl = [CCTwirl actionWithPosition:ccp(size.width/2, size.height/2) twirls:1 amplitude:2.5f grid:ccg(12,8) duration:5];
        //    [ball runAction:effectTwirl];
        
        //    CCShatteredTiles3D：通过更改节点对象的网格属性，让节点对象及其瓦片产生类似粉碎的三维效果。
        //    id effectShatteredTiles3D = [CCShatteredTiles3D actionWithRange:5 shatterZ:YES grid:ccg(16,12) duration:5];
        //    [mySprite runAction:effectShatteredTiles3D];
        
        //    CCShakyTiles3D：通过更改节点对象的网格属性，让节点对象及其瓦片产生类似晃动的三维效果。
        //    id effectShakyTiles3D = [CCShakyTiles3D actionWithRange:5 shakeZ:YES grid:ccg(16,12) duration:5];
        //    [mySprite runAction:effectShakyTiles3D];
        
        //    CCShuffleTiles：通过更改节点对象的网格属性，让节点对象及其瓦片产生类似洗牌的效果。
        //    id effectShuffleTiles = [CCShuffleTiles actionWithSeed:25 grid:ccg(16,12) duration:3];
        //    id shuffleBack = [effectShuffleTiles reverse];
        //    id delay = [CCDelayTime actionWithDuration:2];
        //    [mySprite runAction:[CCSequence actions:effectShuffleTiles,delay,shuffleBack, nil]];
        
        //    CCFadeOutTRTiles: 通过更改节点对象的网格属性，让节点对象及其瓦片产生从左下角到右上角淡出的效果。
        //    id effectFadeOutTRTiles = [CCFadeOutTRTiles actionWithSize:ccg(16,12) duration:5];
        //    id fadeouttrBack = [effectFadeOutTRTiles reverse];
        //    id trDelay = [CCDelayTime actionWithDuration:2];
        //    [mySprite runAction:[CCSequence actions:effectFadeOutTRTiles,trDelay,fadeouttrBack, nil]];
        
        //    CCFadeOutBLTiles: 通过更改节点对象的网格属性，让节点对象及其瓦片产生从右上角到左下角淡出的效果。
        //    id effectFadeOutBLTiles = [CCFadeOutBLTiles actionWithSize:ccg(16,12) duration:5];
        //    id fadeoutblBack = [effectFadeOutBLTiles reverse];
        //    id blDelay = [CCDelayTime actionWithDuration:2];
        //    [mySprite runAction:[CCSequence actions:effectFadeOutBLTiles,blDelay,fadeoutblBack, nil]];
        
        //    CCFadeOutUpTiles：通过更改节点对象的网格属性，让节点对象及其瓦片产生自下而上淡出的效果。
        //    id effectFadeOutUpTiles = [CCFadeOutUpTiles actionWithSize:ccg(10,10) duration:5];
        //    id fadeoutupBack = [effectFadeOutUpTiles reverse];
        //    id upDelay = [CCDelayTime actionWithDuration:2];
        //    [mySprite runAction:[CCSequence actions:effectFadeOutUpTiles,upDelay,fadeoutupBack, nil]];
        
        //    CCFadeOutDownTiles：通过更改节点对象的网格属性，让节点对象及其瓦片产生自上而下淡出的效果。
        //    id effectFadeOutDownTiles = [CCFadeOutDownTiles actionWithSize:ccg(10,10) duration:5];
        //    id fadeoutdownBack = [effectFadeOutDownTiles reverse];
        //    id downDelay = [CCDelayTime actionWithDuration:2];
        //    [mySprite runAction:[CCSequence actions:effectFadeOutDownTiles,downDelay,fadeoutdownBack, nil]];
        
        
        //    CCTurnOffTiles：通过更改节点对象的网格属性，产生瓦片逐渐消失的效果。
        //    id effectTurnOffTiles = [CCTurnOffTiles actionWithSeed:5 grid:ccg(10,10) duration:5];
        //    id turnoffBack = [effectTurnOffTiles reverse];
        //    id turnoffDelay = [CCDelayTime actionWithDuration:2];
        //    [mySprite runAction:[CCSequence actions:effectTurnOffTiles,turnoffDelay,turnoffBack, nil]];
        
        //    CCWavesTiles3D: 通过更改节点对象的网格属性，让节点对象及其瓦片产生类似三维波浪的效果。
        //    id effectWavesTiles3D = [CCWavesTiles3D actionWithWaves:10 amplitude:120 grid:ccg(15,12) duration:5];
        //    [ball runAction:effectWavesTiles3D];
        
        //    CCJumpTiles3D：通过更改节点对象的网格属性，瓦片产生跳动的三维效果。
        //    id effectJumpTiles3D = [CCJumpTiles3D actionWithJumps:10 amplitude:30 grid:ccg(12,12) duration:5];
        //    [mySprite runAction:effectJumpTiles3D];
        
        //    CCSplitRows：通过更改节点对象的网格属性，让节点对象产生分行分割并消失的效果。
        //    id effectSplitRows = [CCSplitRows actionWithRows:10 duration:5];
        //    [mySprite runAction:effectSplitRows];
        
        //    CCSplitCols：通过更改节点对象的网格属性，让节点对象产生分列分割并消失的效果。
        //    id effectSplitCols = [CCSplitCols actionWithCols:10 duration:5];
        //    [mySprite runAction:effectSplitCols];
        
        //    CCPageTurn3D：通过更改节点对象的网格属性，让节点对象产生三维翻页的效果。
        //    id effectPageTurn3D = [CCPageTurn3D actionWithSize:ccg(15,12) duration:5];
        //    [mySprite runAction:effectPageTurn3D];
        
        //    让节点对象在特效动作结束后恢复原貌
        
        id effect = [CCSequence actions:[CCWaves actionWithWaves:10 amplitude:30 horizontal:YES vertical:YES grid:ccg(10,10) duration:5], [CCStopGrid action], nil];
        [mySprite runAction:effect];
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
