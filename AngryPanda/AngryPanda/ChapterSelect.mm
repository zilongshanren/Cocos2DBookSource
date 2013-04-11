//
//  ChapterSelection.m
//  CrazyMonk
//
//  Created by eseedo on 7/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "SimpleAudioEngine.h"
#import "GameData.h"
#import "GameSounds.h"
#import "CCTouchDispatcher.h"
#import "CCScrollLayer.h"
#import "Chapter.h"
#import "Chapters.h"
#import "ChapterParser.h"
#import "Constants.h"
#import "SceneManager.h"



@implementation ChapterSelect

+(id)scene{
    
    CCScene *scene =[CCScene node];
    ChapterSelect *layer = [ChapterSelect node];
    [scene addChild:layer];
    return scene;
    
}



//获取屏幕大小

-(void)getScreenSize{
    
    size = [CCDirector sharedDirector].winSize;
    
}

//获取设备类型
-(void)getDeviceType{
    
    if([GameData sharedData].isDeviceIphone5 == NO){
        deviceType = kDeviceTypeNotIphone5;
    }else{
        deviceType = kDeviceTypeIphone5OrNewTouch;
    }
}


#pragma mark 设置菜单的位置

-(void)setMenuLocation{
    
    [self getScreenSize];
    
    backButtonLocation = ccp( size.width*0.85, size.height*0.1);
    
    storeButtonLocation = ccp(size.width*0.85,size.height*0.1);
    
    textLocation = ccp(size.width*0.5,size.height*0.75);
    
    chapterLocation = ccp(size.width*0.5,size.height*0.5);
    
    bgLocation = ccp(size.width*0.5,size.height*0.5);
    
}

//添加背景图片
-(void)addBackground{
    
    
    CCSprite *background;
    
    
    if(IS_IPHONE)
    {
        if(deviceType == kDeviceTypeNotIphone5){
            background = [CCSprite spriteWithFile:@"menu_background.png"];

        }else if(deviceType == kDeviceTypeIphone5OrNewTouch){
            
            background = [CCSprite spriteWithFile:@"menu_background-iphone5.png"];

        }
        
        
    }else if(IS_IPAD){
        
           background= [CCSprite spriteWithFile:@"menu_background-ipad.png"];
        
    }
    
    
    background.position = bgLocation;
    
        [self addChild:background z:zOrderChapterBg];
    
}


//添加背景音乐
-(void)playBackgroundMusic{
    
    GameData *data = [GameData sharedData];
    if ( data.backgroundMusicMuted == NO ) {
        
        if([SimpleAudioEngine sharedEngine].isBackgroundMusicPlaying == NO)
        {
            
            [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"bg_startgamescene.mp3" loop:YES];
        }
        
    }
    

    
}


#pragma mark 添加底部两个菜单选项

//返回起始画面
-(void)backToStart{
    
    //返回起始画面
    NSLog(@"返回起始画面");
    
    [SceneManager goStartGame];
    
    
}


//添加返回按钮
-(void)addBackButton{
    
    
    CGSize screenSize =[CCDirector sharedDirector].winSize;
  
    CCMenuItemImage* backButton = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"back.png" target:self selector:@selector(backToStart)];
    
    CCMenu *MenuButton = [CCMenu menuWithItems:backButton,  nil];
    MenuButton.position = ccp(70,screenSize.height*0.9);
    [self addChild:MenuButton z:1];
}





#pragma mark 选择关卡场景

//选中场景后调整到关卡选择界面

- (void)onSelectChapter:(CCMenuItemImage *)sender {
    
    //CCLOG(@"writing the selected stage to GameData.xml as %i", sender.tag);
    
    GameData *gameData = [GameData sharedData];
    gameData.selectedChapter = sender.tag;
    
    if(gameData.selectedChapter <=5){
        
        [SceneManager goLevelSelect];
    }
    else{
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"对不起" message:@"未知之地尚未开启，敬请期待" delegate:self cancelButtonTitle:@"难道是传说中的MOP？" otherButtonTitles:nil,nil];
        
        [alert show];
        [alert release];
    }
}

//初始化层
- (CCLayer*)layerWithChapterName:(NSString*)chapterName
                   chapterNumber:(int)chapterNumber
                 chapterUnlocked:(BOOL)chaterUnlocked
                      screenSize:(CGSize)screenSize {
    
    CCLayer *layer = [[CCLayer alloc] init];
    
    [self getScreenSize];
    
    if(chapterNumber ==1){
        
        
        
        CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"mini1_bg_iphone.png"
                                                        selectedImage:@"mini1_bg_iphone.png"
                                                               target:self
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        //    image.scale = 0.8;
        
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        [layer addChild: menu];
        
        
        //添加文字
        
        [CCMenuItemFont setFontSize:15];
        CCMenuItemFont *text = [CCMenuItemFont itemWithString:@"迷雾岛"];
        text.tag = chapterNumber;
        
        
        CCMenu *menu2 = [CCMenu menuWithItems:text, nil];
        //    [menu2 alignItemsVertically];
        menu2.anchorPoint = ccp(0,0);
        menu2.position = ccp(size.width*0.5,size.height*0.8);
        
        [layer addChild:menu2];
        
    }else if(chapterNumber ==2){
        
        CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"mini2_bg_iphone.png"
                                                        selectedImage:@"mini2_bg_iphone.png"
                                                               target:self
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        //    image.scale = 0.8;
        
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        [layer addChild: menu];
        
        //添加文字
        
        [CCMenuItemFont setFontSize:15];
        CCMenuItemFont *text = [CCMenuItemFont itemWithString:@"竹子林"];
        text.tag = chapterNumber;
        
        
        CCMenu *menu2 = [CCMenu menuWithItems:text, nil];
        //    [menu2 alignItemsVertically];
        menu2.anchorPoint = ccp(0,0);
        menu2.position = ccp(size.width*0.5,size.height*0.8);
        
        [layer addChild:menu2];
        
    }else if(chapterNumber ==3){
        
        
        CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"mini3_bg_iphone.png"
                                                        selectedImage:@"mini3_bg_iphone.png"
                                                               target:self
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        //    image.scale = 0.8;
        
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        [layer addChild: menu];
        
        //添加文字
        
        [CCMenuItemFont setFontSize:15];
        CCMenuItemFont *text = [CCMenuItemFont itemWithString:@"五风谷"];
        text.tag = chapterNumber;
        
        
        CCMenu *menu2 = [CCMenu menuWithItems:text, nil];
        //    [menu2 alignItemsVertically];
        menu2.anchorPoint = ccp(0,0);
        menu2.position = ccp(size.width*0.5,size.height*0.8);
        
        [layer addChild:menu2];
        
    }else if(chapterNumber ==4){
        
        CCMenuItemImage *imageBottom = [CCMenuItemImage itemWithNormalImage:@"mini4_bg_iphone.png"
                                                              selectedImage:@"mini4_bg_iphone.png"
                                                                     target:self
                                                                   selector:@selector(onSelectChapter:)];
        imageBottom.tag = chapterNumber;
        //    image.scale = 0.8;
        
        CCMenu *menuBottom = [CCMenu menuWithItems: imageBottom, nil];
        [menuBottom alignItemsVertically];
        [layer addChild: menuBottom];
        
        
        CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"mini_lock_iphone.png"
                                                        selectedImage:@"mini_lock_iphone.png"
                                                               target:self
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        //    image.scale = 0.8;
        
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        [layer addChild: menu z:2];
        
        //添加文字
        
        [CCMenuItemFont setFontSize:15];
        CCMenuItemFont *text = [CCMenuItemFont itemWithString:@"昆仑山"];
        text.tag = chapterNumber;
        
        
        CCMenu *menu2 = [CCMenu menuWithItems:text, nil];
        //    [menu2 alignItemsVertically];
        menu2.anchorPoint = ccp(0,0);
        menu2.position = ccp(size.width*0.5,size.height*0.8);
        
        [layer addChild:menu2];
        
    }else if(chapterNumber ==5){
        
        CCMenuItemImage *imageBottom = [CCMenuItemImage itemWithNormalImage:@"mini5_bg_iphone.png"
                                                              selectedImage:@"mini5_bg_iphone.png"
                                                                     target:self
                                                                   selector:@selector(onSelectChapter:)];
        imageBottom.tag = chapterNumber;
        //    image.scale = 0.8;
        
        CCMenu *menuBottom = [CCMenu menuWithItems: imageBottom, nil];
        [menuBottom alignItemsVertically];
        [layer addChild: menuBottom];
        
        CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"mini_lock_iphone.png"
                                                        selectedImage:@"mini_lock_iphone.png"
                                                               target:self
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        //    image.scale = 0.8;
        
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        [layer addChild: menu z:2];
        
        //添加文字
        
        [CCMenuItemFont setFontSize:15];
        CCMenuItemFont *text = [CCMenuItemFont itemWithString:@"欢乐谷"];
        text.tag = chapterNumber;
        
        
        
        CCMenu *menu2 = [CCMenu menuWithItems:text, nil];
        //    [menu2 alignItemsVertically];
        menu2.anchorPoint = ccp(0,0);
        menu2.position = ccp(size.width*0.5,size.height*0.8);
        
        [layer addChild:menu2];
    }
    
    
    return layer;
}

//set offset of the scroll layer
-(void)setScollLayerOffset{
    
    if(deviceType == kDeviceTypeIphone5OrNewTouch){
        scrollLayerOffset = 250;
    }else if(deviceType == kDeviceTypeNotIphone5){
        scrollLayerOffset = 180;
    }
}

//添加滑动选择
-(void)addChapters{
    
    [self getScreenSize];
    
    NSMutableArray *layers = [NSMutableArray new];
    
    Chapters *chapters = [ChapterParser loadData];
    
    for (Chapter *chapter in chapters.chapters) {
        // Create a layer for each of the stages found in Chapters.xml
        CCLayer *layer = [self layerWithChapterName:chapter.name chapterNumber:chapter.number chapterUnlocked:chapter.unlocked  screenSize:size];
        [layers addObject:layer];
    }
    
    [self setScollLayerOffset];
    
    // Set up the swipe-able layers
    CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:layers
                                                        widthOffset:scrollLayerOffset];
    
    
    //  GameData *gameData = [GameDataParser loadData];
    GameData *gameData = [GameData sharedData];
    
    [scroller selectPage:(gameData.selectedChapter -1)];
    
    [self addChild:scroller];
    
    [scroller release];
    [layers release];
  
    
}


#pragma mark 初始化当前场景

-(id)init{
    if((self = [super init])){
        
        [self getDeviceType];
        
        //设置位置
        
        [self setMenuLocation];
        
        //添加背景
        
        [self addBackground];
        
        //播放背景音乐
        [self playBackgroundMusic];
        
        //添加菜单选项
        [self addBackButton];
        

        
        //添加场景选择
        [self addChapters];
        
    }
    return self;
    
}

@end
