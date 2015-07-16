//
//  DHProgressAnimation.h
//  Test3D
//
//  Created by DreamHack on 14-10-14.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^AnimationBlock)(CGFloat progress);
typedef void(^AnimationDidStopBlock)(void);

@interface DHProgressAnimation : NSObject


@property (nonatomic, copy) AnimationBlock animationBlock;
@property (nonatomic, copy) AnimationDidStopBlock completionBlock;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat fromProgress;

- (instancetype)initWithAnimationDuration:(CGFloat)duration
                         animationEaseOut:(BOOL)flag
                               toProgress:(CGFloat)progress
                           animationBlock:(AnimationBlock)block
                          completionBlock:(AnimationDidStopBlock)completion;

- (void)runAnimation;
- (void)removeAnimation;

@end
