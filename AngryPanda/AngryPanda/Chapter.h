//
//  Chapter.h
//

#import <Foundation/Foundation.h>

@interface Chapter : NSObject {
  
  // Declare variables with an underscore in front
  NSString *_name;
  int _number;
  BOOL _unlocked;
}

// Declare variable properties without an underscore
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) BOOL unlocked;

// Put your custom init method interface here:
-(id)initWithName:(NSString*)name number:(int)number  unlocked:(BOOL)unlocked;

@end