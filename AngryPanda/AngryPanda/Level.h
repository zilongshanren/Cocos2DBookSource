//
//  Level.h
//

#import <Foundation/Foundation.h>

@interface Level : NSObject {
  
  // Declare variables with an underscore
  
  //关卡名称
  NSString *_name;
  
  //关卡编号
  
  int _number;
  
  //关卡是否已解锁
  BOOL _unlocked;
  
  //关卡星级评价
  int _stars;
  
  //其它数据
  NSString *_data;
  
  //关卡是否通过
  BOOL _levelClear;
  
  
  
  
}

// Declare variable properties without an underscore
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) BOOL unlocked;
@property (nonatomic, assign) int stars;
@property (nonatomic, copy) NSString *data;
@property(nonatomic,assign) BOOL levelClear;




// Custom init method interface
- (id)initWithName:(NSString *)name
            number:(int)number
          unlocked:(BOOL)unlocked
             stars:(int)stars
              data:(NSString *)data
        levelClear:(BOOL)levelClear;



@end
