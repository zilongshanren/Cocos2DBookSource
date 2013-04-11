#import "cocos2d.h"

@interface SpriteArray : NSObject {
  CCArray * _array;
  int _nextItem;
}

@property (readonly) CCArray * array;

- (id)initWithCapacity:(int)capacity spriteFrameName:(NSString *)spriteFrameName batchNode:(CCSpriteBatchNode *)batchNode;
- (id)nextSprite;

@end
