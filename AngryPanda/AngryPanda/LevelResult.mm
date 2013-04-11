
#import "LevelResult.h"
#import "LevelSelection.h"
#import "MainScene.h"
#import "About.h"
#import "SimpleAudioEngine.h"

#import "Level.h"
#import "Levels.h"
#import "LevelParser.h"
#import "SceneManager.h"

#import "GameData.h"
#import "Constants.h"


@implementation LevelResult

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelResult *layer = [LevelResult node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//读取LevelManager中的数据

-(void)readData{
    
    GameData *data =[GameData sharedData];
    levelScore =    data.currentLevelScore;
    levelNumber =   data.selectedLevel;
    chapterNumber = data.selectedChapter ;
    
    levelSolved =   data.levelsCompleted;
    
    highestScore =  [[GameData sharedData]returnHighScoreForCurrentLevel];
    
    levelClear =    data.currentLevelSolved;
}

//获取设备类型
-(void)getDeviceType{
    
    if([GameData sharedData].isDeviceIphone5 == NO){
        
        deviceType = kDeviceTypeNotIphone5;
        
    }else{
        
        deviceType = kDeviceTypeIphone5OrNewTouch;
    }
}


//添加背景并设置透明度

-(void)addResultBg{
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    if(IS_IPHONE)
    {
        if(deviceType == kDeviceTypeNotIphone5){
            resultBg = [CCSprite spriteWithFile:@"bg_levelresult.png"];

            
        }else if(deviceType == kDeviceTypeIphone5OrNewTouch){
            
            resultBg = [CCSprite spriteWithFile:@"bg_levelresult-iphone5.png"];

            
        }
        
        
    }else if(IS_IPAD){
        
        resultBg = [CCSprite spriteWithFile:@"bg_levelresult-ipad.png"];
        
    }
    
    resultBg.opacity = 100;
    
    resultBg.position =ccp(screenSize.width/2,screenSize.height/2);
    [self addChild:resultBg z:-1];
    
}


//显示上面的方框

-(void)addTopBar{
    
    //获取屏幕大小
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //add topbar
    CCSprite *topbar;
    if(IS_IPHONE){
        
        topbar = [CCSprite spriteWithFile:@"levelbox1.png"];
        
    }else if(IS_IPAD){
        
        topbar = [CCSprite spriteWithFile:@"levelbox1-ipad.png"];
    }
    
    topbar.position = ccp(screenSize.width/2,screenSize.height*0.7);
    [self addChild:topbar];
}


//显示下面的方框

-(void)addDownBar{
    
    //获取屏幕大小
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //add downbar
    CCSprite *downbar;
    
    if(IS_IPHONE){
        
        downbar = [CCSprite spriteWithFile:@"levelbox2.png"];
    }else if(IS_IPAD){
        downbar = [CCSprite spriteWithFile:@"levelbox2-ipad.png"];
    }
    downbar.position = ccp(screenSize.width/2,screenSize.height*0.3);
    [self addChild:downbar];
}

//显示关卡名称和历史最高得分
-(void)addLevelTitle{
    
    //获取屏幕大小
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //显示关卡名称
    NSString *name = [NSString stringWithFormat:@"第%d关",levelNumber];
    CCLabelTTF *level = [CCLabelTTF labelWithString:name fontName:@"Courier-Bold" fontSize:25];
    level.position = ccp(screenSize.width*0.4,screenSize.height*0.65);
    [self addChild:level z:1];
    
    //显示文本
    CCLabelTTF *text = [CCLabelTTF labelWithString:@"历史最高得分" fontName:@"Courier" fontSize:20];
    text.position = ccp(screenSize.width*0.5,screenSize.height*0.8);
    [self addChild:text z:1];
    
    //显示历史最高得分
    NSString *highScore = [NSString stringWithFormat:@"%d",highestScore];
    CCLabelTTF *showScore = [CCLabelTTF labelWithString:highScore fontName:@"Courier" fontSize:25];
    showScore.position = ccp(screenSize.width*0.58,screenSize.height*0.65);
    [self addChild:showScore z:2];
    
}

//显示游戏结果

-(void)addResult{
    
    //获取屏幕大小
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    if(levelClear == FALSE){
        
        NSString *failure =@"当前关卡失败!";
        CCLabelTTF *showFailure = [CCLabelTTF labelWithString:failure fontName:@"ArialMT" fontSize:20];
        showFailure.position = ccp(screenSize.width*0.5,screenSize.height*0.35);
        [self addChild:showFailure];
        
    } else if(levelClear == YES){
        
        NSString *clear = @"当前关卡胜利!";
        CCLabelTTF *showClear = [CCLabelTTF labelWithString:clear fontName:@"ArialMT" fontSize:20];
        showClear.position = ccp(screenSize.width*0.45,screenSize.height*0.4);
        [self addChild:showClear z:2];
        
        CCLabelTTF *text = [CCLabelTTF labelWithString:@"得分" fontName:@"ArialMT" fontSize:20];
        text.position = ccp(screenSize.width*0.35,screenSize.height*0.3);
        [self addChild:text z:2];
        
        NSString *score = [NSString stringWithFormat:@"%d",levelScore];
        CCLabelTTF *showScore = [CCLabelTTF labelWithString:score fontName:@"ArialMT" fontSize:20];
        showScore.position = ccp(screenSize.width*0.55,screenSize.height*0.3);
        [self addChild:showScore z:2];
    }
    
}
//返回关卡选择界面

-(void)backToLevelSelection{
    
    //停止播放背景音乐
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    //创建一个场景切换效果
    
//    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0f scene:[LevelSelection scene]];
//    [[CCDirector sharedDirector]replaceScene:trans];
    
    //切换场景
    
    [SceneManager goLevelSelect];
    
    //  NSLog(@"back to level selection scene");
}

//重玩当前关卡
-(void)replayCurrentLevel{
    
    //停止播放背景音乐
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    //根据关卡编号的进入不同关卡场景
    
    [GameData sharedData].selectedLevel =levelNumber;
//    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0f scene:[MainScene scene]];
//    [[CCDirector sharedDirector]replaceScene:trans];
    
    [SceneManager goGameScene];
    
    
    
}

//进入下一个关卡
-(void)playNextLevel{
    
    //停止播放背景音乐
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    

    GameData *gamedata =[GameData sharedData];
    
    //判断是否下一个关卡已解锁
    if(levelClear ==YES && gamedata.selectedLevel < 10)
    {
        
        gamedata.selectedLevel++;
        
        
        [SceneManager goGameScene];
        
    }
    
    else if(gamedata.selectedLevel ==10 && gamedata.selectedChapter <3  && levelClear)
    {
        
        gamedata.selectedChapter ++;
        gamedata.selectedLevel =1;
        
        Levels *selectedLevels = [LevelParser loadLevelsForChapter:gamedata.selectedChapter];
        
        // Iterate through the array of levels
        for (Level *level in selectedLevels.levels)
        {
            
            // look for currently selected level
            
            if(level.number == gamedata.selectedLevel)
            {
                //新章节的关卡1解锁
                
                [level setUnlocked:YES];
            }else
            {
                
                //其它关卡锁定
                [level setUnlocked:NO];
            }
            
        }
        
        // Write the new xml
        [LevelParser saveData:selectedLevels forChapter:gamedata.selectedChapter];
        
        //进入新的场景
        [SceneManager goLevelSelect];
        
    }else if(chapterNumber >=3)
    {
        
        [SceneManager goChapterSelect];
    }

    
}

//显示三个菜单选项
-(void)addMenuItems{
    
    //获取屏幕大小
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    NSString *nextItemImage =@"button_nextlevel.png";
    if(levelClear == NO){
        nextItemImage = @"button_panda.png";
    }
    
    CCMenuItemImage *backItem = [CCMenuItemImage itemWithNormalImage:@"button_menu.png" selectedImage:nil target:self selector:@selector(backToLevelSelection)];
    
    CCMenuItemImage *replayItem = [CCMenuItemImage itemWithNormalImage:@"button_replay.png" selectedImage:nil target:self selector:@selector(replayCurrentLevel)];
    
    CCMenuItemImage *nextItem = [CCMenuItemImage itemWithNormalImage:nextItemImage selectedImage:nil target:self selector:@selector(playNextLevel)];
    
    backItem.position = ccp(screenSize.width*0.3,screenSize.height*0.15);
    replayItem.position = ccp(screenSize.width*0.5,screenSize.height*0.15);
    nextItem.position = ccp(screenSize.width*0.7,screenSize.height*0.15);
    
    CCMenu *menu = [CCMenu menuWithItems:backItem,replayItem,nextItem, nil];
    menu.position = ccp(0,0);
    [self addChild:menu];
    
}

-(void)playBgmusic{
    
    if(levelClear){
        
     
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"gamewin.mp3" loop:YES];
        
    }else{
        
      
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"fail.mp3" loop:YES];
    }
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        
        //读取LevelManager中的数据
        
        [self readData];
        
        //获取游戏关卡的背景并设置透明度
        
        [self addResultBg];
        
        //显示关卡名称
        [self addLevelTitle];
        
        //显示上面的方框
        [self addTopBar];
        
        
        //显示下面的方框
        [self addDownBar];
        
        
        //显示菜单选项
        
        [self addMenuItems];
        
        //显示游戏结果
        [self addResult];
        
        //播放背景音乐
        [self playBgmusic];
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


@end
