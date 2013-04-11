//
//  Levels.m
//

#import "Levels.h"

@implementation Levels

@synthesize levels = _levels;

-(id)init {
  
  if ((self = [super init])) {
    
    self.levels = [[[NSMutableArray alloc] init] autorelease];
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

@end