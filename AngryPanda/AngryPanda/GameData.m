
#import "GameData.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"

@implementation GameData


@synthesize notFirstTimePlayThisGame,notFirstTimeEnterStore;
@synthesize gamePaused;
@synthesize selectedChapter = _selectedChapter;
@synthesize selectedLevel = _selectedLevel;
@synthesize soundEffectMuted,backgroundMusicMuted;

@synthesize levelsCompleted,chaptersCompleted;
@synthesize currentLevelSolved;

@synthesize highScoreLevel1,highScoreLevel2,highScoreLevel3,highScoreLevel4,highScoreLevel5,highScoreLevel6,highScoreLevel7,highScoreLevel8,highScoreLevel9,highScoreLevel10;
@synthesize currentLevel,currentLevelScore;

@synthesize scoresToPassLevel,scoresForAllLevels,enemyNumberForCurrentLevel;

@synthesize isDeviceIphone5;



static GameData *sharedData = nil;

+(GameData*) sharedData {
    
    if (sharedData == nil) {
        sharedData = [[GameData alloc] init] ;
        
    }
    return  sharedData;
    
}


-(id) init
{
    
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        
        sharedData = self;
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        
        isDeviceIphone5 = [defaults boolForKey:@"isDeviceIphone5"];
  
        soundEffectMuted = [defaults boolForKey:@"soundEffectMuted"];   //默认值为NO
        backgroundMusicMuted = [defaults boolForKey:@"backgroundMusicMuted"];   //默认值为NO
        
        
        gamePaused = [defaults boolForKey:@"gamePaused"];
        
        
        
        notFirstTimePlayThisGame = [defaults boolForKey:@"notFirstTimePlayThisGame"];
        notFirstTimeEnterStore = [defaults boolForKey:@"notFirstTimeEnterStore"];
        
        
        levelsCompleted = [defaults integerForKey:@"levelsCompletedTotal"];
        chaptersCompleted = [defaults integerForKey:@"chaptersCompleted"];
        
        currentLevelSolved = [defaults boolForKey:@"currentLevelSolved"];
    
        
        //默认选择的关卡和场景
        _selectedChapter = 1;
        _selectedLevel =1;
   
        
    }
    
    return self;
}





#pragma mark 关卡的历史最高得分

//设置不同关卡的历史最高得分

-(void) setHighScoreForCurrentLevel:(int)theScore {
    
    switch (_selectedLevel) {
        case 0:
            // do nothing
            break;
        case 1:
            if (theScore > highScoreLevel1) {
                highScoreLevel1 = theScore;
                [defaults setInteger:highScoreLevel1 forKey:@"highScoreLevel1"];
            }
            break;
        case 2:
            if (theScore > highScoreLevel2) {
                highScoreLevel2 = theScore;
                [defaults setInteger:highScoreLevel2 forKey:@"highScoreLevel2"];
            }
            break;
        case 3:
            if (theScore > highScoreLevel3) {
                highScoreLevel3 = theScore;
                [defaults setInteger:highScoreLevel3 forKey:@"highScoreLevel3"];
            }
            break;
        case 4:
            if (theScore > highScoreLevel4) {
                highScoreLevel4 = theScore;
                [defaults setInteger:highScoreLevel4 forKey:@"highScoreLevel4"];
            }
            break;
        case 5:
            if (theScore > highScoreLevel5) {
                highScoreLevel5 = theScore;
                [defaults setInteger:highScoreLevel5 forKey:@"highScoreLevel5"];
            }
            break;
        case 6:
            if (theScore > highScoreLevel6) {
                highScoreLevel6 = theScore;
                [defaults setInteger:highScoreLevel6 forKey:@"highScoreLevel6"];
            }
            break;
        case 7:
            if (theScore > highScoreLevel7) {
                highScoreLevel7 = theScore;
                [defaults setInteger:highScoreLevel7 forKey:@"highScoreLevel7"];
            }
            break;
        case 8:
            if (theScore > highScoreLevel8) {
                highScoreLevel8 = theScore;
                [defaults setInteger:highScoreLevel8 forKey:@"highScoreLevel8"];
            }
            break;
        case 9:
            if (theScore > highScoreLevel9) {
                highScoreLevel9 = theScore;
                [defaults setInteger:highScoreLevel9 forKey:@"highScoreLevel9"];
            }
            break;
        case 10:
            if (theScore > highScoreLevel10) {
                highScoreLevel10 = theScore;
                [defaults setInteger:highScoreLevel10 forKey:@"highScoreLevel10"];
            }
            break;
            
        default:
            
            break;
    }
    
    
    
}


//返回不同关卡的历史最高得分

-(int) returnHighScoreForCurrentLevel {
    
    int highScore;
    
    switch (_selectedLevel) {
        case 0:
            highScore = 0;
            break;
        case 1:
            highScore = highScoreLevel1;
            break;
        case 2:
            highScore = highScoreLevel2;
            break;
        case 3:
            highScore = highScoreLevel3;
            break;
        case 4:
            highScore = highScoreLevel4;
            break;
        case 5:
            highScore = highScoreLevel5;
            break;
        case 6:
            highScore = highScoreLevel6;
            break;
        case 7:
            highScore = highScoreLevel7;
            break;
        case 8:
            highScore = highScoreLevel8;
            break;
        case 9:
            highScore = highScoreLevel9;
            break;
        case 10:
            highScore = highScoreLevel10;
            break;
            
            
        default:
            highScore = 0;
            break;
    }
    
    
    return highScore ;
}





@end
