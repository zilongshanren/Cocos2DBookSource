//
//  Chapters.m
//

#import "Chapters.h"

@implementation Chapters

@synthesize chapters = _chapters;

-(id)init {
  
  if ((self = [super init])) {
    
    self.chapters = [[[NSMutableArray alloc] init] autorelease];
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

@end