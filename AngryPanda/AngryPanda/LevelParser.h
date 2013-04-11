//
//  LevelParser.h
//

#import <Foundation/Foundation.h>

@class Levels;

@interface LevelParser : NSObject {}

+ (Levels *)loadLevelsForChapter:(int)chapter;
+ (void)saveData:(Levels *)saveData
      forChapter:(int)chapter;

@end
