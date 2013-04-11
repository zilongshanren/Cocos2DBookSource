//
//  SwirlEffectShader.m
//  Cocos2DShaderDemo
//
//  Created by guanghui on 7/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SwirlEffectShader.h"
#import "BackLayer.h"


@implementation SwirlEffectShader{
    CCSprite *sprite;
    float   _angle;
    int _angleLocation;
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
        NSString *fragmentShaderFile = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:@"SwirlEffectShader.fsh"];
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:fragmentShaderFile encoding:NSUTF8StringEncoding
                                                                                error:nil] UTF8String];
        sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTexture_vert
                                                          fragmentShaderByteArray:fragmentSource];
        [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        
        
        [sprite.shaderProgram link];
        
        [sprite.shaderProgram updateUniforms];
        
        //设置uniform一定要放在updateUniforms之后,放在use之前或者之后都可以
        int colorLocation = glGetUniformLocation(sprite.shaderProgram->program_, "rt_w");
        glUniform1f(colorLocation, 480.0);
        colorLocation = glGetUniformLocation(sprite.shaderProgram->program_, "rt_h");
        glUniform1f(colorLocation, 320.0);
        
        _angleLocation = glGetUniformLocation(sprite.shaderProgram->program_, "angle");
        _angle = 0.01f;
        
        
        
        
        [self scheduleUpdate];
        
        
        BackLayer *layer = [BackLayer node];
        [self addChild:layer];
        
    }
    return self;
}

-(void) update:(ccTime)dt{
    _angle += 0.01f;
    if (_angle >= 2.0) {
        _angle = 0.01f;
    }
    [sprite.shaderProgram use];
    glUniform1f(_angleLocation, _angle);
}


@end
