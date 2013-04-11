//
//  LevelSelect.m
//

#import "LevelSelection.h"
#import "Level.h"
#import "Levels.h"
#import "LevelParser.h"
#import "GameData.h"
#import "SimpleAudioEngine.h"
#import "Chapter.h"
#import "Chapters.h"
#import "ChapterParser.h"
#import "Constants.h"
#import "SceneManager.h"

@implementation LevelSelection



#pragma mark 设置视觉元素的位置

//获取屏幕大小

-(void)getScreenSize{
    
    screenSize = [CCDirector sharedDirector].winSize;
    
}


//获取设备类型
-(void)getDeviceType{
    
    if([GameData sharedData].isDeviceIphone5 == NO){
        deviceType = kDeviceTypeNotIphone5;
    }else{
        deviceType = kDeviceTypeIphone5OrNewTouch;
    }
}


//设置各视觉元素的位置

-(void)setMenuLocation{
    
    [self getScreenSize];
    
    backButtonLocation = ccp( screenSize.width*0.85, screenSize.height*0.1);
    
    
    levelMenuLocation = ccp(screenSize.width*0.5,screenSize.height*0.45);
    bgLocation = ccp(screenSize.width*0.5,screenSize.height*0.5);
    
    chapterIntroLocation = ccp(screenSize.width*0.5,screenSize.height*0.75);
    chapterTitleLocation = ccp(screenSize.width*0.5,screenSize.height*0.85);
    
}


//添加章节的文字介绍
-(void)addChapterIntro{
    
    switch (currentChapter) {
        case 1:
            
            chapterTitle = [CCLabelTTF labelWithString:@"迷雾岛" fontName:@"ArialMT" fontSize:16];
            
            chapterIntro = [CCLabelTTF labelWithString:@"迷雾重重，熊猫人喜欢在这里探索神秘的世界。" fontName:@"ArialMT" fontSize:12];
            
            chapterIntro.position = chapterIntroLocation;
            chapterTitle.position = chapterTitleLocation;
            
            [self addChild:chapterIntro];
            [self addChild:chapterTitle];
            
            break;
            
        case 2:
            
            chapterTitle = [CCLabelTTF labelWithString:@"竹子林" fontName:@"ArialMT" fontSize:16];
            
            chapterIntro = [CCLabelTTF labelWithString:@"在海滩上生长着一片郁郁葱葱的竹林，是熊猫人嬉戏玩耍的乐土。" fontName:@"ArialMT" fontSize:12];
            
            chapterIntro.position = chapterIntroLocation;
            chapterTitle.position = chapterTitleLocation;
            
            [self addChild:chapterIntro];
            [self addChild:chapterTitle];
            
            
            break;
        case 3:
            
            
            chapterTitle = [CCLabelTTF labelWithString:@"五风谷" fontName:@"ArialMT" fontSize:16];
            
            chapterIntro = [CCLabelTTF labelWithString:@"透过那挂满葡萄的枝条间隐约可以看见星星点点的繁华农场和集市。" fontName:@"ArialMT" fontSize:12];
            
            chapterIntro.position = chapterIntroLocation;
            chapterTitle.position = chapterTitleLocation;
            
            [self addChild:chapterIntro];
            [self addChild:chapterTitle];
            break;
            
        case 4:
            
            
            chapterTitle = [CCLabelTTF labelWithString:@"昆仑山" fontName:@"ArialMT" fontSize:16];
            
            chapterIntro = [CCLabelTTF labelWithString:@"昆仑山脉北部陡峭的山峰之巅，传说中神仙聚集之地。" fontName:@"ArialMT" fontSize:12];
            
            chapterIntro.position = chapterIntroLocation;
            chapterTitle.position = chapterTitleLocation;
            
            [self addChild:chapterIntro];
            [self addChild:chapterTitle];
            break;
            
        case 5:
            
            
            chapterTitle = [CCLabelTTF labelWithString:@"欢乐谷" fontName:@"ArialMT" fontSize:16];
            
            chapterIntro = [CCLabelTTF labelWithString:@"这里升腾着迷离的浓雾，周围群山环绕。" fontName:@"ArialMT" fontSize:12];
            
            chapterIntro.position = chapterIntroLocation;
            chapterTitle.position = chapterTitleLocation;
            
            [self addChild:chapterIntro];
            [self addChild:chapterTitle];
            break;
            
        default:
            
            chapterTitle = [CCLabelTTF labelWithString:@"迷雾岛" fontName:@"ArialMT" fontSize:16];
            
            chapterIntro = [CCLabelTTF labelWithString:@"迷雾重重，熊猫人喜欢在这里探索神秘的世界。" fontName:@"ArialMT" fontSize:12];
            
            chapterIntro.position = chapterIntroLocation;
            chapterTitle.position = chapterTitleLocation;
            
            [self addChild:chapterIntro];
            [self addChild:chapterTitle];
            break;
    }
    
    
    
}


//从Gamedata类获取数据

-(void)readData{
    
    currentChapter =[GameData sharedData].selectedChapter;
    
}


#pragma mark 添加按钮


//添加返回按钮
-(void)addBackButton{
    
    
    screenSize =[CCDirector sharedDirector].winSize;
    
    
    CCMenuItemImage* backButton = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"back.png" target:self selector:@selector(backToStart)];
    CCMenu *MenuButton = [CCMenu menuWithItems:backButton,  nil];
    MenuButton.position = ccp(70,screenSize.height*0.9);
    [self addChild:MenuButton z:1];
}

//返回起始画面
-(void)backToStart{
    //返回场景选择画面
    
    [SceneManager goChapterSelect];
    
    
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


#pragma mark 添加关卡选择的背景

//添加菜单背景
-(void)addLevelSelectBg{
    

    
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
    
    [self addChild:background z:zOrderLevelBg];
    
}


#pragma mark 添加关卡选择菜单

//添加关卡选择菜单

-(void)addLevelMenu{
    

    
    // 从GameData中获取所选场景编号:
    GameData *gameData = [GameData sharedData];
    int selectedChapter = gameData.selectedChapter;
    
    
    // 获取场景名称，用于后续为不同场景设置不同的背景
    NSString *selectedChapterName = nil;
    Chapters *selectedChapters = [ChapterParser loadData];
    for (Chapter *chapter in selectedChapters.chapters) {
        if ([[NSNumber numberWithInt:chapter.number] intValue] == selectedChapter) {
            CCLOG(@"Selected Chapter is %@ (ie: number %i)", chapter.name, chapter.number);
            selectedChapterName = chapter.name;
        }
    }
    
    
    // Read in selected chapter levels
    CCMenu *levelMenu = [CCMenu menuWithItems: nil];
    NSMutableArray *overlay = [NSMutableArray new];
    
    Levels *selectedLevels = [LevelParser loadLevelsForChapter:gameData.selectedChapter];
    
    
    // Create a button for every level
    for (Level *level in selectedLevels.levels) {
        
        NSString *normal =   [NSString stringWithFormat:@"level_bg_iphone.png"];
        NSString *selected = [NSString stringWithFormat:@"level_bg_iphone.png"];
        
        CCMenuItemImage *item = [CCMenuItemImage itemWithNormalImage:normal
                                                       selectedImage:selected
                                                              target:self
                                                            selector:@selector(onPlay:)];
        [item setTag:level.number]; // note the number in a tag for later usage
        [item setIsEnabled:level.unlocked];  // ensure locked levels are inaccessible
        [levelMenu addChild:item];
        
        if (!level.unlocked) {
            
            NSString *overlayImage = [NSString stringWithFormat:@"level_lock_iphone.png"];
            CCSprite *overlaySprite = [CCSprite spriteWithFile:overlayImage];
            [overlaySprite setTag:level.number];
            [overlay addObject:overlaySprite];
        }
        else {
            
            NSString *stars = [[NSNumber numberWithInt:level.stars] stringValue];
            NSString *overlayImage = [NSString stringWithFormat:@"%@Star-Normal-iPhone.png",stars];
            
            CCSprite *overlaySprite = [CCSprite spriteWithFile:overlayImage];
            [overlaySprite setTag:level.number];
            [overlay addObject:overlaySprite];
        }
        
    }
    
    [levelMenu alignItemsInColumns:
     [NSNumber numberWithInt:5],
     [NSNumber numberWithInt:5],
     nil];
    
    // Move the whole menu up by a small percentage so it doesn't overlap the back button
    //  CGPoint newPosition = levelMenu.position;
    //  newPosition.y = newPosition.y + (newPosition.y / 10);
    //  [levelMenu setPosition:newPosition];
    //
    
    levelMenu.position = levelMenuLocation;
    [self addChild:levelMenu];
    
    
    // Create layers for star/padlock overlays & level number labels
    CCLayer *overlays = [[CCLayer alloc] init];
    CCLayer *labels = [[CCLayer alloc] init];
    
    
    for (CCMenuItem *item in levelMenu.children) {
        
        // create a label for every level
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",item.tag]
                                               fontName:@"Marker Felt"
                                               fontSize:25];
        
        [label setAnchorPoint:item.anchorPoint];
        [label setPosition:item.position];
        [labels addChild:label z:zOrderLevelText];
        
        
        // set position of overlay sprites
        
        for (CCSprite *overlaySprite in overlay) {
            if (overlaySprite.tag == item.tag) {
                [overlaySprite setAnchorPoint:item.anchorPoint];
                [overlaySprite setPosition:item.position];
                [overlays addChild:overlaySprite z:zOrderLevelText];
            }
        }
    }
    
    // Put the overlays and labels layers on the screen at the same position as the levelMenu
    
    [overlays setAnchorPoint:levelMenu.anchorPoint];
    [labels setAnchorPoint:levelMenu.anchorPoint];
    [overlays setPosition:levelMenu.position];
    [labels setPosition:levelMenu.position];
    [self addChild:overlays];
    [self addChild:labels];
    [overlays release];
    [labels release];
    
}

#pragma mark 选中关卡后跳转到游戏主场景
//选中关卡后跳转到游戏主场景
- (void) onPlay: (CCMenuItemImage*) sender {
    
    // the selected level is determined by the tag in the menu item
    int selectedLevel = sender.tag;
    
    // store the selected level in GameData
    GameData *gameData = [GameData sharedData];
    gameData.selectedLevel = selectedLevel;
    
    // load the game scene
    [SceneManager goGameScene];
}

#pragma mark 类方法
+(CCScene*)scene{
    
    CCScene *scene = [CCScene node];
    LevelSelection *layer =[LevelSelection node];
    [scene addChild:layer];
    return scene;
    
}

#pragma mark 初始化

//初始化方法

- (id)init {
    
    if( (self=[super init])) {
        
        [self getDeviceType];
        
        //读取数据
        [self readData];
        
        //设置位置
        [self setMenuLocation];
        
        //添加关卡选择菜单
        
        [self addLevelMenu];
        
        //添加返回按钮
        
        [self addBackButton];
        
        
        
        //播放背景音乐
        [self playBackgroundMusic];
        
        //添加背景
        [self addLevelSelectBg];
        
        //添加场景简介
        [self addChapterIntro];
        
    }
    return self;
}

@end
