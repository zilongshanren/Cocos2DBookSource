//
//  LevelSelect.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface LevelSelection : CCLayer {
    
    int currentChapter;
    
    //按钮的位置
    
    CGPoint backButtonLocation;
    
    CGPoint storeButtonLocation;
    
    //场景文字描述的位置
    CGPoint textLocation;
    
    //章节的位置
    CGPoint levelMenuLocation;
    
    //背景图片的位置
    CGPoint bgLocation;
    
    //章节标题的位置
    CGPoint chapterTitleLocation;
    
    //章节简介的位置
    CGPoint chapterIntroLocation;
    
    //屏幕大小
    CGSize screenSize;
    
    //章节标题
    CCLabelTTF *chapterTitle;
    
    //章节简介
    CCLabelTTF *chapterIntro;
    
    //设备类型
    int deviceType;
    

    
}

+(CCScene*)scene;

@end
