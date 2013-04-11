//
//  Chapters.h
//

#import <Foundation/Foundation.h>

@interface Chapters : NSObject {
  
  // Declare variables with an underscore in front
  NSMutableArray *_chapters;
}

// Declare variable properties without an underscore
@property (nonatomic, retain) NSMutableArray *chapters;

@end
