//
//  MyParticle.m
//  ParticleEffect
//
//  Created by eseedo on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyParticle.h"

@implementation MyParticle

-(id)init{
  return [self initWithTotalParticles:150];
  
}

-(id)initWithTotalParticles:(NSUInteger)numberOfParticles{
  
  if((self =[super initWithTotalParticles:numberOfParticles])){
    
    //duration 
    duration =kCCParticleDurationInfinity;
    
    //gravity mode
    self.emitterMode =kCCParticleModeGravity;
    if(self.emitterMode == kCCParticleModeGravity){
      
      //gravity mode:gravity
      
      self.gravity = ccp(0,-90);
      
      //gravity mode:radial
      self.radialAccel = 0;
      self.radialAccelVar = 0;
      self.tangentialAccel = 120;
      self.tangentialAccelVar =10;
      //gravity mode: speed of particles
      self.speed = 180;
      self.speedVar = 50;
      
    } else if(self.emitterMode == kCCParticleModeRadius){
      self.startRadius = 100;
      self.startRadiusVar = 0;
      self.endRadius = 10;
      self.endRadiusVar = 0;
      self.rotatePerSecond = -180;
      self.rotatePerSecondVar = 0;
      
    }
    
    //emitter position
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self.position = ccp(winSize.width/2,winSize.height/2);
    self.posVar = CGPointZero;
    self.positionType = kCCPositionTypeFree;
    
    //angle
    angle = 90;
    angleVar =20;
    
    //life of particles
    life = 1.5f;
    lifeVar =1;
    
    //emits per frame
    emissionRate = totalParticles/life;
    
    //color of particles
    startColor.r = 0.5f;
		startColor.g = 0.5f;
		startColor.b = 0.5f;
		startColor.a = 1.0f;
		startColorVar.r = 0.5f;
		startColorVar.g = 0.5f;
		startColorVar.b = 0.5f;
		startColorVar.a = 0.1f;
		endColor.r = 0.1f;
		endColor.g = 0.1f;
		endColor.b = 0.1f;
		endColor.a = 0.2f;
		endColorVar.r = 0.1f;
		endColorVar.g = 0.1f;
		endColorVar.b = 0.1f;
		endColorVar.a = 0.2f;
		
		// size, in pixels
		startSize = 8.0f;
		startSizeVar = 2.0f;
		endSize = kCCParticleStartSizeEqualToEndSize;
    endSizeVar =0;
    
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
    
    //blendFunc
    self.blendFunc = (ccBlendFunc){GL_SRC_ALPHA,GL_DST_ALPHA};
    
		// additive
		self.blendAdditive = NO;
    
  }
  return self;
  
}

@end
