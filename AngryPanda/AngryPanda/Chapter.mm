//
//  Chapter.m
//

#import "Chapter.h"

@implementation Chapter

// Synthesize variables
@synthesize name = _name;
@synthesize number = _number;
@synthesize unlocked = _unlocked;

-(id)initWithName:(NSString*)name number:(int)number unlocked:(BOOL)unlocked{
  
  if ((self = [super init])) {
    
    // Set class instance variables based on values
    // given to this method
    self.name = name;
    self.number = number;
    self.unlocked = unlocked;
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

@end