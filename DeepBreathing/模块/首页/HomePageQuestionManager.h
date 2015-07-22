//
//  HomePageQuestionManager.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-22.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageQuestionManager : NSObject

// 4个问题加载到该view上
@property (nonatomic, strong, readonly) UIView * questionContainerView;

// 单例
+ (HomePageQuestionManager *)defaultManager;
// 两个路径
// shapeLayer动画开始路径和结束路径
+ (CGPathRef)pathForStarting;
+ (CGPathRef)pathForEndding;

- (void)didTransitionToQuestion;

@end
