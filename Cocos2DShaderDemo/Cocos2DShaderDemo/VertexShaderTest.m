//
//  VertexShaderTest.m
//  Cocos2DShaderDemo
//
//  Created by guanghui on 7/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "VertexShaderTest.h"
#import "BackLayer.h"


@implementation VertexShaderTest{
    CCSprite *sprite;
}

-(id) init{
    if (self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // 1
        sprite = [CCSprite spriteWithFile:@"Icon.png"];
        sprite.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:sprite];
        
        
        // 2
        NSString *vertexShaderFile = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:@"CustomVertexShader.vsh"];
        const GLchar * vertexSource = (GLchar*) [[NSString stringWithContentsOfFile:vertexShaderFile encoding:NSUTF8StringEncoding
                                                                               error:nil] UTF8String];
        sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:vertexSource
                                                          fragmentShaderByteArray:ccPositionTexture_frag];
        
        //3
        [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        
        
        //4
        [sprite.shaderProgram link];
        [sprite.shaderProgram updateUniforms];
        
        //5.set uniform
        int scaleLocation = glGetUniformLocation(sprite.shaderProgram->program_, "u_scale");
        glUniform1f(scaleLocation, 2.0f);
        int moveLocation = glGetUniformLocation(sprite.shaderProgram->program_, "u_move");
        glUniform2f(moveLocation, 100, 0);
        int rotateLocation = glGetUniformLocation(sprite.shaderProgram->program_, "u_rotate");
        glUniform1f(rotateLocation, 30);
        
        //6.
        [sprite.shaderProgram use];
        
        BackLayer *layer = [BackLayer node];
        [self addChild:layer];

    }
    return self;
}

@end
