//
//  DHSegmentedProgressView.h
//  Test3D
//
//  Created by DreamHack on 14-10-14.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHProgressAnimation.h"
#import "CABasicAnimation+AnimationCompletionBlock.h"
@interface DHSegmentedGradientProgressView : UIView

@property (nonatomic, strong) UIImage * progressImage;          // if set, gradientColors will not be used;

- (instancetype)initWithCenter:(CGPoint)center
                  circleRadius:(CGFloat)radius
                 progressWidth:(CGFloat)progressWidth
                gradientColors:(NSArray *)colors
             fromGradientPoint:(CGPoint)fromPoint
               toGradientPoint:(CGPoint)toPoint
                 segmentNumber:(NSInteger)number
                   startRadian:(CGFloat)radian
                     clockWise:(BOOL)flag;

- (void)setProgress:(CGFloat)progress forSegment:(NSInteger)segmentIndex animated:(BOOL)flag animationStopBlock:(AnimationCompletionBlock)completion;



- (void)setProgressBornGrooveHidden:(BOOL)hidden;

//- (CALayer *)progressLayer;

@end
