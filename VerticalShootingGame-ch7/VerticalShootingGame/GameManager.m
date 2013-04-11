//
//  GameManager.m
//  VerticalShootingGame
//
//  Created by guanghui qu on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"

#define kHightScoreKey      @"highScores"
#define kPlayTimesKey       @"playTimes"

static GameManager* singleton = nil;

@implementation GameManager
@synthesize highScores;
@synthesize isWin;
@synthesize score;
@synthesize playTimes;


+(GameManager*) sharedGameManager
{
    @synchronized(self)
    {
        // create our single instance
        if(singleton == nil)
            singleton = [[self alloc] init];
    }
    return singleton;
}

+(id) alloc
{
    @synchronized(self)
    {
        // assert that we are the only instance
        NSAssert(singleton == nil, @"There can only be one GameState");
        return [super alloc];
    }
    return nil;
}

+(void) purge
{
    @synchronized(self)
    {
        [singleton release];
    }
}

+(void) loadState
{
    @synchronized(self)
    {
        // release any existing instance
        [singleton release];
        
        // load our data
        NSString* savePath = [self makeSavePath];
        singleton = [[NSKeyedUnarchiver unarchiveObjectWithFile:savePath] retain];
        
        // couldn't load?
        if(singleton == nil)
        {
            NSLog(@"Couldn't load game state, so initialized with defaults");
            [self sharedGameManager];
        }
        
        NSLog(@"Loaded game state %@", singleton);
    }
}

+(void) saveState
{
    // save our data
    NSString* savePath = [self makeSavePath];
    [NSKeyedArchiver archiveRootObject:[GameManager sharedGameManager] toFile:savePath];
    
    NSLog(@"Saved game state %@ to file %@", singleton, savePath);
}

+(NSString*) makeSavePath
{
    // make save path from our document's directory
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* savePath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
    return savePath;
}

-(id) init
{
    self = [super init];
    if( self != nil )
    {
        [self clear];
        NSLog(@"gameState init %@", self);
    }
    return self;
}

-(void) dealloc
{
    [highScores release];
    highScores = nil;
    
    [super dealloc];
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"highScores=%@",highScores];
}

-(void) clear
{
    // erase all data
    [highScores release];
    highScores = nil;
    
    playTimes = 0;
    isWin = false;
    score = 0;
}


-(NSMutableArray*) top3Scores{
    if (nil == highScores) {
        highScores = [NSMutableArray arrayWithCapacity:3];
        [highScores retain];
    }
    while ([highScores count] < 3) {
        [highScores addObject:[NSNumber numberWithInt:0]];
    } 
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil 
                                                                 ascending:NO 
                                                                  selector:@selector(compare:)];
    [highScores sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
     return highScores;
}

-(void) addNewHighScore:(int)newScore{
    if (nil == highScores) {
        highScores = [NSMutableArray arrayWithCapacity:3];
        [highScores retain];
    }
    if ([highScores count] < 3) {
        [highScores addObject:[NSNumber numberWithInt:newScore]];
    }
    else{
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil 
                                                                     ascending:NO 
                                                                      selector:@selector(compare:)];
        [highScores sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
        
        int lastScore = [[highScores objectAtIndex:2] intValue];
        if (newScore > lastScore) {
            [highScores removeObjectAtIndex:2];
            [highScores addObject:[NSNumber numberWithInt:newScore]];
        }
    }
    
}


-(id) initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if( self != nil )
    {
        // decode data
        highScores = [[coder decodeObjectForKey:kHightScoreKey] retain];
        playTimes = [[coder decodeObjectForKey:kPlayTimesKey] intValue];
        NSLog(@"initWithCoder = %@",self);
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder*)coder
{
    // encode data
    [coder encodeObject:highScores forKey:kHightScoreKey];
    [coder encodeObject:[NSNumber numberWithInt:playTimes] forKey:kPlayTimesKey];
    NSLog(@"encodeWithCoder = %@",self);
}
@end
