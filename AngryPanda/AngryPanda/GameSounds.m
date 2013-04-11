//
//  GameSounds.mm


#import "GameSounds.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "GameData.h"



@implementation GameSounds


static GameSounds *sharedGameSounds = nil;

//场景初始化

-(id) init
{
    
    if ((self = [super init] ))
    {
        
    }
    return self;
    
}

//单例类方法

+(GameSounds*) sharedGameSounds {
    
    if (sharedGameSounds == nil) {
        sharedGameSounds = [[GameSounds alloc] init];
        
    }
    
    return sharedGameSounds;
}


//禁用音效
-(void) disableSoundEffect {
    
    
    [GameData sharedData].soundEffectMuted = YES;
    
}
//启用音效
-(void) enableSoundEffect {
    
    
    [GameData sharedData].soundEffectMuted = NO;
}

-(void) playBackgroundMusic{
    [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusicIfNoOtherAudio];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    if ( [GameData sharedData].backgroundMusicMuted  == NO ) {
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"birds.mp3" loop:YES];
        [CDAudioManager sharedManager].backgroundMusic.volume = 0.15f;
    }
}

-(void) stopBackgroundMusic {
    
    [[CDAudioManager sharedManager] setMode:kAMM_FxOnly];
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic ];
    
    [GameData sharedData].backgroundMusicMuted  = YES;
    
}


@end
