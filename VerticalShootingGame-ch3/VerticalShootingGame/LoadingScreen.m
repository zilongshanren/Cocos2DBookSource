//
//  LoadingScreen.m
//
//  Created by Six Foot Three Foot on 28/05/12.
//  Copyright 2012 Six Foot Three Foot. All rights reserved.
//

#import "LoadingScreen.h"
#import "SimpleAudioEngine.h"

//The next scene you wish to transition to.
#import "HelloWorldLayer.h"

@implementation LoadingScreen

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	
    NSString *className = NSStringFromClass([self class]); 
    // 'layer' is an autorelease object.
    id layer = [NSClassFromString(className) node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    
    if ( ( self = [ super init] ) )
    {
        
        winSize = [[CCDirector sharedDirector] winSize];
        winCenter = ccp(winSize.width / 2, winSize.height / 2);

        
        CCLabelTTF *loadingText = [CCLabelTTF labelWithString:@"Loading..." fontName:@"Arial" fontSize:20];
        loadingText.position = ccpAdd(winCenter, ccp(0,50));
        [self addChild:loadingText];
                        
    }
    
    return self;
}

-(void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:@"preloadAssetManifest.plist"];
    
    NSDictionary *manifest = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *spriteSheets   = [manifest objectForKey:@"SpriteSheets"];
    NSArray *images         = [manifest objectForKey:@"Images"];        
    NSArray *soundFX        = [manifest objectForKey:@"SoundFX"];
    NSArray *music          = [manifest objectForKey:@"Music"];
    NSArray *assets         = [manifest objectForKey:@"Assets"];
    
    assetCount = ([spriteSheets count] + [images count] + [soundFX count] + [music count] + [assets count]);
    
    if (soundFX)
        [self performSelectorOnMainThread:@selector(loadSounds:) withObject:soundFX waitUntilDone:YES];
    
    if (spriteSheets)
        [self performSelectorOnMainThread:@selector(loadSpriteSheets:) withObject:spriteSheets waitUntilDone:YES];
    
    if (images)
        [self performSelectorOnMainThread:@selector(loadImages:) withObject:images waitUntilDone:YES];
    
    if (music)
        [self performSelectorOnMainThread:@selector(loadMusic:) withObject:music waitUntilDone:YES];
    
    if (assets)
        [self performSelectorOnMainThread:@selector(loadAssets:) withObject:assets waitUntilDone:YES];

}

-(void) loadMusic:(NSArray *) musicFiles
{
    CCLOG(@"Start loading music");
    for (NSString *music in musicFiles)
    {
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:music];
        [self progressUpdate];
    }
}

-(void) loadSounds:(NSArray *) soundClips
{
    CCLOG(@"Start loading sounds");
    for (NSString *soundClip in soundClips)
    {
        [[SimpleAudioEngine sharedEngine] preloadEffect:soundClip];
        [self progressUpdate];

    }
    
}

-(void) loadSpriteSheets:(NSArray *) spriteSheets
{   
    for (NSString *spriteSheet in spriteSheets)
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:spriteSheet];
        [self progressUpdate];
    }
}

-(void) loadImages:(NSArray *) images
{
    CCLOG(@"LoadingScreen - loadImages : You need to tell me what to do.");
    for (NSString *image in images)
    {
        //Do something with the images
        [[CCTextureCache sharedTextureCache] addImage:image];
        [self progressUpdate];        
    }
}

-(void) loadAssets:(NSArray *) assets
{
    //Overwrite me
    CCLOG(@"LoadingScreen - loadAssets : You need to tell me what to do.");
    for (NSString *asset in assets)
    {
        //Do something with the assets
        [self progressUpdate];        
    }
    [self progressUpdate];        
}

-(void) progressUpdate
{
    if (--assetCount)
    {
        //留着后面显示进度条用
    }
    else {
        [self loadingComplete];
        CCLOG(@"All done loading assets.");
    }

}

-(void) loadingComplete
{
    CCDelayTime *delay = [CCDelayTime actionWithDuration:2.0f];
    CCCallBlock *swapScene = [CCCallBlock actionWithBlock:^(void) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f 
                                                                                     scene:[HelloWorldLayer scene]]];                
    }];
    
    CCSequence *seq = [CCSequence actions:delay, swapScene, nil];
    [self runAction:seq];
}

@end
