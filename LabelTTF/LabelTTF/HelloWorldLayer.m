//
//  HelloWorldLayer.m
//  LabelTTF
//
//  Created by guanghui on 9/6/12.
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
		
		// 创建并初始化标签对象
		CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"We Love Apple!" fontName:@"Marker Felt" fontSize:30];

        CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"We Love iPhone" fontName:@"ArialRoundedMTBold" fontSize:32 dimensions:CGSizeMake(150, 150) hAlignment:UITextAlignmentRight];
        
        
        CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"We Love iPad Mini" fontName:@"Chalkduster" fontSize:32 dimensions:CGSizeMake(150, 150)  hAlignment:UITextAlignmentLeft vAlignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap];
        
		// 获取屏幕大小
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// 设置标签的位置
		label1.position =  ccp( size.width /2 , size.height/2 );
        label2.position = ccp(size.width/2,150+size.height/2);
        label3.position = ccp(size.width/2, -150+size.height/2);
		
		// 将标签对象添加为当前层的子节点
		[self addChild: label1];
        [self addChild:label2];
        [self addChild:label3];
        
        //让label对象执行动作
        id label1Action = [CCSpawn actions:[CCScaleBy actionWithDuration:5.0 scale:1.3],[CCFadeIn actionWithDuration:5.0], nil];
        [label1 runAction:label1Action];
        
        id label2Action = [CCSpawn actions:[CCFadeIn actionWithDuration:5.0],[CCRotateBy actionWithDuration:5.0 angle:180], nil];
        [label2 runAction:label2Action];
        
        id label3Action = [CCSpawn actions:[CCFadeIn actionWithDuration:5.0],[CCRotateBy actionWithDuration:5.0 angle:180],nil];
        [label3 runAction:label3Action];
        
        //尝试设置不同的锚点值
        CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"对齐方式" fontName:@"Cochin" fontSize:20];
        label4.position = ccp(size.width/2,-120+size.height/2);
        
        //右对齐
        //    label4.anchorPoint = ccp(0,0.5f);
        
        //左对齐
        //    label4.anchorPoint = ccp(1,0.5f);
        
        //顶部对齐
        //    label4.anchorPoint = ccp(0.5f,0);
        
        //底部对齐
        //    label4.anchorPoint = ccp(0.5f,1.0f);
        
        //默认的几何中心位置
        label4.anchorPoint = ccp(0.5f,0.5f);
        
        // 将标签对象添加为当前层的子节点
        [self addChild:label4];
        
        //查看iOS当前版本所支持的字体
        NSMutableArray *fontNames = [[NSMutableArray alloc]init];
        NSArray *fontFamilyNames =[UIFont familyNames];
        for (NSString *familyName in fontFamilyNames){
            
            NSLog(@"Font Family Name = %@",familyName);
            NSArray *names = [UIFont fontNamesForFamilyName:familyName];
            NSLog(@"Font Names = %@",fontNames);
            [fontNames addObjectsFromArray:names];
            
        }
        [fontNames release];
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
