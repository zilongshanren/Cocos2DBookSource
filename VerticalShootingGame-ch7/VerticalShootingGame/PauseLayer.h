//
//  PauseLayer.h
//  VerticalShootingGame
//
//  Created by guanghui qu on 6/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class PauseLayer;

@protocol PauseLayerProtocol <NSObject>

@required
-(void) didRecieveResumeEvent:(PauseLayer*)layer;
-(void) didRecieveRestartEvent:(PauseLayer*)layer;

@end

@interface PauseLayer : CCLayerColor<CCTargetedTouchDelegate> {
    id<PauseLayerProtocol> delegate;
}
@property(nonatomic,assign)id<PauseLayerProtocol> delegate;

@end

@interface CustomMenu : CCMenu{
    
}

@end
