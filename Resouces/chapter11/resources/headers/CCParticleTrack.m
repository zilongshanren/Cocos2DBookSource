//
//  CCParticleTrack.m
//  Panda Shoot
//
//  Created by jone on 10-7-9.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CCParticleTrack.h"

@implementation CCParticleTrack

-(id) init
{
	return [self initWithTotalParticles:350];
}

-(id) initWithTotalParticles:(int) p
{
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// additive
	self.blendAdditive = YES;
	
	// duration
	duration = -1;
	
	// gravity
	self.gravity = CGPointZero;
	
	// angle
	angle = 0;
	angleVar = 0;
	
	// radial acceleration
	self.radialAccel = 0;
	self.radialAccelVar = 0;	
	
	// emitter position
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	self.position = ccp(winSize.width/2, winSize.height/2);
	posVar = CGPointZero;
	
	// life of particles
	life = 3.0f;
	lifeVar = 0.0f;
	
	// speed of particles
	self.speed = 10.0;
	self.speedVar = 0.0;
	
	// size, in pixels
	startSize = 50.0f;
	startSizeVar = 0.0f;
	endSize = kParticleStartSizeEqualToEndSize;
	
	// emits per seconds
	emissionRate = totalParticles/life;
	
	// color of particles
	startColor.r = 0.5f;
	startColor.g = 0.5f;
	startColor.b = 0.5f;
	startColor.a = 0.6f;
	startColorVar.r = 0.00f;
	startColorVar.g = 0.00f;
	startColorVar.b = 0.00f;
	startColorVar.a = 0.0f;
	endColor.r = 0.0f;
	endColor.g = 0.0f;
	endColor.b = 0.0f;
	endColor.a = 1.0f;
	endColorVar.r = 0.0f;
	endColorVar.g = 0.0f;
	endColorVar.b = 0.0f;
	endColorVar.a = 0.0f;
	
	self.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
	
	return self;
}
@end
