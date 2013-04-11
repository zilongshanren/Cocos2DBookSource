//
//  PauseLayer.h
//  BeautifulLife
//
//  Created by eseedo on 8/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PauseLayerProtocol: CCNode

-(void)pauseLayerDidPause;

-(void)pauseLayerDidUnpause;

@end

@interface GamePause : CCLayerColor {
    
    PauseLayerProtocol * delegate;
    
    CGSize screenSize;
    
    
    CCSprite *bg;
    
    //设备类型
    int deviceType;

}

@property (nonatomic,assign)PauseLayerProtocol * delegate;

//+ (id) layerWithColor:(ccColor4B)color delegate:(PauseLayerProtocol *)_delegate;

//- (id) initWithColor:(ccColor4B)c delegate:(PauseLayerProtocol *)_delegate;

+ (id) layerWithColor:(ccColor4B)color delegate:(id)_delegate;
- (id) initWithColor:(ccColor4B)c delegate:(id)_delegate;


-(void)pauseDelegate;

@end
