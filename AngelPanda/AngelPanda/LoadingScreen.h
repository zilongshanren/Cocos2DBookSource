//
//  LoadingScreen.h
//
//  Created by Six Foot Three Foot on 28/05/12.
//  Copyright 2012 Six Foot Three Foot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadingScreen : CCLayer {
    CGSize      winSize;
    CGPoint     winCenter;
    
    CCProgressTimer *progress;
    float           progressInterval;
    int             assetCount;
}
+(CCScene *) scene;

/** Called if there is any music to load, it loads the files one by one via the NSArray */
-(void) loadMusic:(NSArray *) musicFiles;

/** Called if there are any sfx to load, it loads the files one by one via the NSArray */
-(void) loadSounds:(NSArray *) soundClips;

/** Called if there are any Sprite Sheets to load, it loads the files one by one via the NSArray */
-(void) loadSpriteSheets:(NSArray *) spriteSheets;

/** Called if there are any images to load, it loads the files one by one via the NSArray.
 Images can be a cache of backgrounds or anything else.  You can add to this method
 to have it do whatever you want with the list.
 */
-(void) loadImages:(NSArray *) images;

/** Called if there are any assets to load, it loads the files one by one via the NSArray.
 Assets basically are anything not of the above.  This pretty much should be modified
 to your needs.  (Such as models, etc)
 */
-(void) loadAssets:(NSArray *) assets;

/** updates the progress bar with the next step.  When progress bar reaches 100%
 It calls loadingComplete which can change scenes, or do anything else you wish.
 */
-(void) progressUpdate;

/** Called by progressUpdate when all assets are loaded from the manifest. */
-(void) loadingComplete;
@end
