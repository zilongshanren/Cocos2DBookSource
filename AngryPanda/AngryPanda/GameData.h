//
//  GameData.h


/*
 
 其中使用NSUserDefaults来存储玩家的数据，如关卡中的最高得分，已解锁的关卡等，玩家在退出游戏中再次打开时仍然会保存此类信息
 此外，其中还设置不同关卡的一些基本信息，如不同关卡的背景图片文件名，要抛投的熊猫数量，通过关卡的分值要求等等。
 该类在经过修改后可在其它项目中重用
 
 */


#import <Foundation/Foundation.h>
//#import "cocos2d.h"


@interface GameData : NSObject {
    

    
    //音效相关
    
    BOOL soundEffectMuted; //音效是否打开
    BOOL backgroundMusicMuted;//背景音乐是否打开
    
    
    
    //游戏相关
    
    //是否是第一次玩这款游戏
    BOOL notFirstTimeEnterStore;
    
    BOOL notFirstTimePlayThisGame;
    
    
    //是否暂停游戏
    BOOL gamePaused;
    
    //系统默认设置
    NSUserDefaults* defaults;
    
    
    //关卡相关
    
    int levelsCompleted; //已通过的关卡数量
    
    int chaptersCompleted;//已完成的场景数量
    
    BOOL currentLevelSolved;//当前关卡是否已通过
    

    
    //所选场景和关卡
    
    int _selectedChapter;
    int _selectedLevel;
    
    //当前关卡的评价（非历史最佳成绩，而是此次通关时的评价，历史最佳成绩保存在Levels-Chapter1.xml中）
    
    int currentLevelStars;

    //该游戏专用
    
    int enemyNumberForCurrentLevel;
    

    
    //当前关卡名称
    NSString* currentLevelName;
    
    
    //当前关卡要抛射的熊猫数量
    int pandasToTossThisLevel;
    
    int scoresToPassLevel;//通过该关卡所需的分数
    
    int bonusPerPanda; //剩下熊猫所得到的奖励分值
    
    int scoresForAllLevels; //所有关卡得分
    
    
    int levelsInLevelpack; //每个关卡部分包含多少子关卡
    
    //各关卡的历史最高得分
    
    int highScoreLevel1;
    int highScoreLevel2;
    int highScoreLevel3;
    int highScoreLevel4;
    int highScoreLevel5;
    int highScoreLevel6;
    int highScoreLevel7;
    int highScoreLevel8;
    int highScoreLevel9;
    int highScoreLevel10;
    
    
    //当前关卡得分
    int currentLevelScore;
    
    //判断设备类型
    
    BOOL isDeviceIphone5;
    
}


@property(nonatomic) NSInteger levelsCompleted,chaptersCompleted;

@property (nonatomic, assign) int selectedChapter;
@property (nonatomic, assign) int selectedLevel;

@property(nonatomic)BOOL soundEffectMuted,backgroundMusicMuted;
@property(nonatomic)BOOL notFirstTimePlayThisGame,notFirstTimeEnterStore;
@property(nonatomic)BOOL gamePaused;


@property(nonatomic) NSInteger highScoreLevel1,highScoreLevel2,highScoreLevel3,highScoreLevel4,highScoreLevel5,highScoreLevel6,highScoreLevel7,highScoreLevel8,highScoreLevel9,highScoreLevel10;

@property(nonatomic) NSInteger currentLevel,currentLevelScore,scoresToPassLevel,scoresForAllLevels;

@property(nonatomic)BOOL currentLevelSolved;
@property(nonatomic)NSInteger enemyNumberForCurrentLevel;

@property(nonatomic)BOOL isDeviceIphone5;

+(GameData*) sharedData;



//设置和返回当前关卡的历史最高得分
-(int) returnHighScoreForCurrentLevel ;
-(void) setHighScoreForCurrentLevel:(int)theScore;




+(GameData*) sharedData;


//初始化
-(id)init;

@end
