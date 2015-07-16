//
//  DHCaptchaView.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-28.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHCaptchaView;

typedef void(^DHCaptchaActionBlock)(DHCaptchaView * captchaView);
@interface DHCaptchaView : UIView

@property (nonatomic, assign) NSTimeInterval reEnableTimeInterval;

- (instancetype)initWithFrame:(CGRect)frame reEnableTimeInterval:(NSTimeInterval)interval actionBlock:(DHCaptchaActionBlock)actionBlock;
- (void)setTitleFont:(UIFont *)titleFont;
- (void)performAnimation;
@end
