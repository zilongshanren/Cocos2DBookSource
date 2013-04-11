//
//  Levels.h
//

#import <Foundation/Foundation.h>

@interface Levels : NSObject {
  
  // Declare variables with an underscore in front
  NSMutableArray *_levels;
}

// Declare variable properties without an underscore
@property (nonatomic, retain) NSMutableArray *levels;

@end
