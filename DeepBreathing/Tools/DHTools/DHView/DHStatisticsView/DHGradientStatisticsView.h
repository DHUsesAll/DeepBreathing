//
//  DHStatisticsView.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-27.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHGradientStatisticsView;

@protocol DHGradientStatisticsViewDelegate <NSObject>

- (void)gradientStatisticsView:(DHGradientStatisticsView *)gradientStatisticsView didTapOnItemAtIndex:(NSInteger)index inView:(UIView *)view;

@end

@interface DHGradientStatisticsView : UIView

@property (nonatomic, copy) NSDictionary * valueAttributes;

@property (nonatomic, assign) NSInteger totalScore;
@property (nonatomic, strong) NSString * yUnit;
@property (nonatomic, weak) id <DHGradientStatisticsViewDelegate> delegate;


+ (NSDictionary *)valueAttributesWithXDescriptions:(NSArray *)xDescriptions yValues:(NSArray *)yValues;

- (instancetype)initWithFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor startValue:(CGFloat)startValue endValue:(CGFloat)endValue valueAttributes:(NSDictionary *)attributes;

- (instancetype)initWithFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor startValue:(CGFloat)startValue endValue:(CGFloat)endValue totalScore:(CGFloat)totalScore valueAttributes:(NSDictionary *)attributes yUnit:(NSString *)yUnit;

- (BOOL)draw;
- (BOOL)drawUsingScroll;

@end
