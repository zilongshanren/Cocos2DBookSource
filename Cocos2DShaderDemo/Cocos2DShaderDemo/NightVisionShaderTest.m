//
//  NightVisionShaderTest.m
//  Cocos2DShaderDemo
//
//  Created by guanghui on 7/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NightVisionShaderTest.h"
#import "BackLayer.h"

@implementation NightVisionShaderTest{
    CCSprite *sprite;
    float   _elapsedTime;
    int _elapsedTimeLocation;
}

-(id) init{
    if (self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // 1
        sprite = [CCSprite spriteWithFile:@"Default.png"];
        sprite.rotation = 90.0;
        sprite.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:sprite];
        
        // 2
        NSString *fragmentShaderFile = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:@"NightVisionShader.fsh"];
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:fragmentShaderFile encoding:NSUTF8StringEncoding
                                                                                error:nil] UTF8String];
        sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                          fragmentShaderByteArray:fragmentSource];
        [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        
        
        [sprite.shaderProgram link];
        
        [sprite.shaderProgram updateUniforms];
        
        //设置uniform一定要放在updateUniforms之后,放在use之前或者之后都可以
        _elapsedTimeLocation = glGetUniformLocation(sprite.shaderProgram->program_, "elapsedTime");
        _elapsedTime = 1.0f;
        
        int noiseLocation = glGetUniformLocation(sprite.shaderProgram->program_, "noiseTex");
        glUniform1i(noiseLocation, 1);
        
        // 4
        CCTexture2D *noiseTex = [[CCTextureCache sharedTextureCache] addImage:@"noise_tex6.png"];
        [noiseTex setAliasTexParameters];
        
        
        int binocularsLocation = glGetUniformLocation(sprite.shaderProgram->program_, "maskTex");
        glUniform1i(binocularsLocation, 2);
        CCTexture2D *binocularsTex = [[CCTextureCache sharedTextureCache] addImage:@"binoculars_mask.png"];
        [binocularsTex setAliasTexParameters];
        
                
        
        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, [binocularsTex name]);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, [noiseTex name]);
        //下面的语句一定要最后调用，它是用来显示原来纹理的
        glActiveTexture(GL_TEXTURE0);
        
        
        
        
        [self scheduleUpdate];
        
        
        BackLayer *layer = [BackLayer node];
        [self addChild:layer];
        
    }
    return self;
}

-(void) update:(ccTime)dt{
    _elapsedTime += 0.01f;
    if (_elapsedTime >= 2.0) {
        _elapsedTime = 1.0f;
    }
    [sprite.shaderProgram use];
    glUniform1f(_elapsedTimeLocation, _elapsedTime);
}

@end
