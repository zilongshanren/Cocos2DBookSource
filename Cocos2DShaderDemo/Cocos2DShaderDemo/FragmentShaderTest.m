//
//  FragmentShaderTest.m
//  Cocos2DShaderDemo
//
//  Created by guanghui on 7/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FragmentShaderTest.h"
#import "BackLayer.h"

@implementation FragmentShaderTest{
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
        NSString *fragmentShaderFile = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:@"CustomFragmentShader.fsh"];
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:fragmentShaderFile encoding:NSUTF8StringEncoding
                                                                              error:nil] UTF8String];
        sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTexture_vert
                                                          fragmentShaderByteArray:fragmentSource];
        [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        
                   
        [sprite.shaderProgram link];
        
        [sprite.shaderProgram updateUniforms];
        
        //设置uniform一定要放在updateUniforms之后,放在use之前或者之后都可以
        int colorLocation = glGetUniformLocation(sprite.shaderProgram->program_, "u_left_color");
        glUniform4f(colorLocation, 1.0f, 0.0f,0.0f,1.0f);
        colorLocation = glGetUniformLocation(sprite.shaderProgram->program_, "u_right_color");
        glUniform4f(colorLocation, 0.0f, 1.0f,0.0f,1.0f);

               
        
        [sprite.shaderProgram use];
        
       
        
        
        
        BackLayer *layer = [BackLayer node];
        [self addChild:layer];
        
    }
    return self;
}



@end
