#import "SpriteArray.h"

@implementation SpriteArray
@synthesize array = _array;

- (id)initWithCapacity:(int)capacity spriteFrameName:(NSString *)spriteFrameName batchNode:(CCSpriteBatchNode *)batchNode {
  
  if ((self = [super init])) {
    
    _array = 
    [[CCArray alloc] initWithCapacity:capacity];
    for(int i = 0; i < capacity; ++i) {            
      CCSprite *sprite = [CCSprite 
                          spriteWithSpriteFrameName:spriteFrameName];
      sprite.visible = NO;
      [batchNode addChild:sprite];
      [_array addObject:sprite];            
    }
    
  }
  return self;
  
}

- (id)nextSprite {
  id retval = [_array objectAtIndex:_nextItem];
  _nextItem++;
  if (_nextItem >= _array.count) _nextItem = 0; 
  return retval;
}

- (void)dealloc {
  [_array release];
  _array = nil;
  [super dealloc];
}

@end
