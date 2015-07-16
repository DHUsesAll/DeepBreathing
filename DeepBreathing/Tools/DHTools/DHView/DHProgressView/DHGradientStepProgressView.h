//
//  DHGradientStepProgressView.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-28.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHGradientStepProgressView : UIView

@property (nonatomic, assign) NSInteger completionStep;


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles gradientColors:(NSArray *)gradientColors progressHeight:(CGFloat)progressHeight titleFont:(UIFont *)titleFont;;

- (void)setCompletionStep:(NSInteger)completionStep;

- (void)setProgress:(CGFloat)progress forStep:(NSInteger)step;

@end
