//
//  DHProgressAnimation.m
//  Test3D
//
//  Created by DreamHack on 14-10-14.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHProgressAnimation.h"

@interface DHProgressAnimation()

@property (nonatomic, strong) CADisplayLink * timer;
@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval timeOffset;
@property (nonatomic, assign) CFTimeInterval lastStep;

@property (nonatomic, assign) BOOL easeOutFlag;

@end

@implementation DHProgressAnimation

- (instancetype)initWithAnimationDuration:(CGFloat)duration
                         animationEaseOut:(BOOL)flag
                               toProgress:(CGFloat)progress
                           animationBlock:(AnimationBlock)block
                          completionBlock:(AnimationDidStopBlock)completion
{
    self = [super init];
    self.duration = duration;
    self.animationBlock = block;
    self.progress = progress;
    self.completionBlock = completion;
    self.easeOutFlag = flag;
    return self;
}

- (void)dealloc
{
    [_timer invalidate];
    self.timer = nil;
}

- (void)runAnimation
{
    self.timeOffset = 0.0;
    
    //stop the timer if it's already running
    [self.timer invalidate];
    //start the timer
    self.lastStep = CACurrentMediaTime();
    self.timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
}

- (void)removeAnimation
{
    self.animationBlock = nil;
    [_timer invalidate];
    self.timer = nil;
}

#pragma mark - private

- (void)step:(CADisplayLink *)step
{
    // calculate time delta
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    self.lastStep = thisStep;
    
    // update time offset
    self.timeOffset = MIN(self.timeOffset + stepDuration, self.duration);
    
    // get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;
    
    if (self.easeOutFlag) {
        time = easeOut(time);
    }
    
    
    
    // interpolate position
    CGFloat progress = interpolate(_fromProgress, self.progress, time);
    
    if (self.animationBlock) {
        self.animationBlock(progress);
    }
    
    
    // stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        if (self.completionBlock) {
            self.completionBlock();
        }
        [self.timer invalidate];
        self.timer = nil;
    }
}

float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}

float easeOut(float t)
{
    
        return -(t - 1) * (t - 1) + 1;
//    return sqrt(1-pow((t-1), 2));
}

@end
