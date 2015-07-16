//
//  DHNormalProgressView.m
//  HealthManagement
//
//  Created by DreamHack on 14-11-27.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHNormalProgressView.h"
#import "DHConvenienceAutoLayout.h"
#import "DHThemeSettings.h"

@interface DHNormalProgressView ()

@property (nonatomic, strong) UIColor * tintColor;
@property (nonatomic, strong) UIView * progressView;
@property (nonatomic, strong) UILabel * progressLabel;

@end

@implementation DHNormalProgressView

- (void)dealloc
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.tintColor = nil;
    self.progressLabel = nil;
    self.progressView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = tintColor;
        self.layer.borderColor = tintColor.CGColor;
        self.layer.borderWidth = 1;
        
        self.progressView = [[UIView alloc] init];
        _progressView.backgroundColor = tintColor;
        [self addSubview:_progressView];
        
        self.progressLabel = [[UILabel alloc] init];
        _progressLabel.text = @"0%";
        _progressLabel.font = [DHThemeSettings themeFontOfSize:frame.size.height];
        _progressLabel.textColor = tintColor;
        [_progressLabel sizeToFit];
        _progressLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:_progressLabel];
        
    }
    return self;
}

- (void)setProgress:(NSInteger)progress
{
    if (progress == 0) {
        _progressLabel.text = @"0%";
        [_progressLabel sizeToFit];
        _progressLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _progressLabel.textColor = _tintColor;
    } else {
        _progressView.frame = CGRectMake(0, 0, (CGFloat)progress/100*self.frame.size.width, self.frame.size.height);
        _progressLabel.text = [NSString stringWithFormat:@"%ld%%",progress];
        [_progressLabel sizeToFit];
        if (_progressLabel.frame.size.width+2 >= _progressView.frame.size.width) {
            _progressLabel.center = CGPointMake(_progressView.frame.size.width, self.frame.size.height+_progressLabel.frame.size.height/2+2);
            _progressLabel.textColor = _tintColor;
        } else {
            _progressLabel.center = CGPointMake(_progressView.frame.size.width/2, self.frame.size.height/2);
            _progressLabel.textColor = [UIColor whiteColor];
        }
    }
}

@end
