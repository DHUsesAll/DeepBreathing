//
//  DHCaptchaView.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-28.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHCaptchaView.h"
#import "DHFoundationTool.h"
#import "DHThemeSettings.h"

@implementation DHCaptchaView
{
    UIView * reEnableProgressView;
    UILabel * titleLabel;
    DHCaptchaActionBlock _actionBlock;
    NSTimer * timer;
    NSInteger timerInteger;
}

- (void)dealloc
{
    [timer invalidate];
    timer = nil;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (instancetype)initWithFrame:(CGRect)frame reEnableTimeInterval:(NSTimeInterval)interval actionBlock:(DHCaptchaActionBlock)actionBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.reEnableTimeInterval = interval;
        self.backgroundColor = [DHFoundationTool colorWith255Red:154 green:154 blue:154 alpha:1];
        reEnableProgressView = [[UIView alloc] initWithFrame:self.bounds];
        reEnableProgressView.backgroundColor = THEME_TEXT_COLOR;
//        reEnableProgressView.layer.cornerRadius = ZPFlexible(5.0);
        if (actionBlock) {
            _actionBlock = actionBlock;
        }
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:reEnableProgressView];
        titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        titleLabel.text = @"获取验证码";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        timerInteger = interval;
        [self addSubview:titleLabel];
    }
    return self;
}


- (void)tap
{
//    [self performAnimation];
    if (_actionBlock) {
        _actionBlock(self);
    }
    
}

- (void)change
{
    if (timerInteger == 0) {
        [timer invalidate];
        titleLabel.text = @"获取验证码";
        timerInteger = _reEnableTimeInterval;
        return;
    }
    timerInteger--;
    titleLabel.text = [NSString stringWithFormat:@"获取验证码(%ld)",(long)timerInteger];
}

- (void)performAnimation
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(change) userInfo:nil repeats:YES];
    [timer fire];
    self.userInteractionEnabled = NO;
    reEnableProgressView.frame = CGRectMake(0, 0, 0, reEnableProgressView.frame.size.height);
    [UIView animateWithDuration:self.reEnableTimeInterval animations:^{
        reEnableProgressView.frame = self.bounds;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    self.userInteractionEnabled = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.userInteractionEnabled = YES;
}


- (void)setTitleFont:(UIFont *)titleFont
{
    titleLabel.font = titleFont;
}

@end
