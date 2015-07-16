//
//  DHGradiantProgressView.h
//  Test3D
//
//  Created by DreamHack on 14-10-11.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHGradientRoundedProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIImage * innerImage;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat startRadian;


@property (nonatomic, strong) UIColor * startColor;
@property (nonatomic, strong) UIColor * endColor;

@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, strong) NSString * title;

@property (nonatomic, assign, getter=isRoundedEnd) BOOL roundedEnd;

- (void)setProgress:(CGFloat)progress animated:(BOOL)flag;

- (instancetype)initWithCenter:(CGPoint)center
                    startColor:(UIColor *)sColor
                      endColor:(UIColor *)eColor
                        radius:(CGFloat)radius
                    innerImage:(UIImage *)innerImage
                   startRadian:(CGFloat)sRadian
                 progressWidth:(CGFloat)width
                         title:(NSString *)title
                    roundedEnd:(BOOL)flag ;

- (UIImageView *)imageView;

@end
