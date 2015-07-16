//
//  DHGradiantProgressView.m
//  Test3D
//
//  Created by DreamHack on 14-10-11.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHGradientRoundedProgressView.h"
#import "DHProgressAnimation.h"

@interface DHGradientRoundedProgressView ()

@property (nonatomic, strong) CAShapeLayer * firstShapeLayer;
@property (nonatomic, strong) CAShapeLayer * secondShapeLayer;
@property (nonatomic, strong) CAGradientLayer * firstHalfLayer;
@property (nonatomic, strong) CAGradientLayer * secondHalfLayer;

@property (nonatomic, strong) CALayer * progressLayer;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIColor * midColor;

@end

@implementation DHGradientRoundedProgressView
{
    UIImageView * _innerImageView;
    CGFloat fromProgress;
}

- (void)dealloc
{
    
    [_progressLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [_progressLayer removeFromSuperlayer];
    
    self.firstHalfLayer = nil;
    self.secondHalfLayer = nil;
    self.firstShapeLayer = nil;
    self.secondShapeLayer = nil;
    self.progressLayer = nil;
    self.title = nil;
    self.startColor = nil;
    self.endColor = nil;
    self.titleLabel = nil;
    self.midColor = nil;
    self.innerImage = nil;
}

- (UIImageView *)imageView
{
    return _innerImageView;
}

- (instancetype)initWithCenter:(CGPoint)center startColor:(UIColor *)sColor endColor:(UIColor *)eColor radius:(CGFloat)radius innerImage:(UIImage *)innerImage startRadian:(CGFloat)sRadian progressWidth:(CGFloat)width title:(NSString *)title roundedEnd:(BOOL)flag
{
    self = [self init];
    self.center = center;
    _innerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.progressWidth = width;
    self.radius = radius;
    self.innerImage = innerImage;
    
    self.roundedEnd = flag;
    
    [self setLayerMask];
    [self setLayerGradient];
    
    self.startColor = sColor;
    self.endColor = eColor;
    self.startRadian = sRadian;
    self.title = title;
    [self addSubview:_innerImageView];
    return self;
}

- (void)setLayerMask
{
    CAShapeLayer * shapelayer = [CAShapeLayer layer];
    shapelayer.lineWidth = self.progressWidth;
    shapelayer.fillColor = [[UIColor clearColor]CGColor];
    shapelayer.strokeColor = [[UIColor redColor] CGColor];
    shapelayer.backgroundColor = [[UIColor clearColor] CGColor];
    if (self.roundedEnd) {
//        shapelayer.lineJoin = kCALineJoinRound;
        shapelayer.lineCap = kCALineCapRound;
    }
    
    self.firstShapeLayer = shapelayer;
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = self.progressWidth;
    shapeLayer.fillColor = [[UIColor clearColor]CGColor];
    shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    
    if (self.roundedEnd) {
//        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
    }
    self.secondShapeLayer = shapeLayer;
}

- (void)setLayerGradient
{
    self.progressLayer = [CALayer layer];
    
    self.firstHalfLayer = [CAGradientLayer layer];
    
    self.secondHalfLayer = [CAGradientLayer layer];
    self.firstHalfLayer.frame = self.bounds;
    self.secondHalfLayer.frame = self.bounds;
    _innerImageView.bounds = CGRectMake(_innerImageView.bounds.origin.x, _innerImageView.bounds.origin.y, _radius*2, self.radius*2);
    _innerImageView.center = self.firstHalfLayer.position;
//    _innerImageView.backgroundColor = [UIColor blackColor];
    _innerImageView.layer.cornerRadius = _radius;
    _progressLayer.frame = self.bounds;
    [self.progressLayer addSublayer:self.firstHalfLayer];
    [self.progressLayer addSublayer:self.secondHalfLayer];
    
    _firstHalfLayer.hidden = YES;
    _secondHalfLayer.hidden = YES;
    
    [self.layer addSublayer:_progressLayer];
}

- (void)setTitle:(NSString *)title
{
    if (title == _title) {
        return;
    }
    _title = title;
    if (!_titleLabel) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_radius+_progressWidth, 10/4, 0, 0)];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textColor = [UIColor whiteColor];
        [_progressLayer addSublayer:_titleLabel.layer];
        
    }
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    return self;
}

- (void)setRadius:(CGFloat)radius
{
    
    _radius = radius;
    
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, radius*2+self.progressWidth*2, radius*2+self.progressWidth*2);
    self.firstHalfLayer.frame = self.bounds;
    self.secondHalfLayer.frame = self.bounds;
    _innerImageView.bounds = CGRectMake(_innerImageView.bounds.origin.x, _innerImageView.bounds.origin.y, radius*2, radius*2);
    _innerImageView.center = _firstHalfLayer.position;
    _innerImageView.layer.cornerRadius = radius;
    
    
}

- (void)setProgress:(CGFloat)progress
{
    _firstHalfLayer.hidden = YES;
    _secondHalfLayer.hidden = YES;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (progress <= 50) {
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:_radius+self.progressWidth/2 startAngle:_startRadian endAngle:_startRadian+M_PI*2*progress/100 clockwise:YES];
        
        _firstShapeLayer.frame = self.bounds;
        _firstShapeLayer.path = path.CGPath;
        _firstShapeLayer.strokeEnd = 1;
        self.firstHalfLayer.mask = _firstShapeLayer;
        _firstHalfLayer.hidden = NO;
    } else {
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:_radius+self.progressWidth/2 startAngle:_startRadian endAngle:_startRadian+M_PI*2*50/100 clockwise:YES];
        
        _firstShapeLayer.frame = self.bounds;
        _firstShapeLayer.path = path.CGPath;
        _firstShapeLayer.strokeEnd = 1;
        self.firstHalfLayer.mask = _firstShapeLayer;
        path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:_radius+self.progressWidth/2 startAngle:_startRadian+M_PI*2*50/100 endAngle:_startRadian+M_PI*2*50/100+M_PI*2*(progress-50)/100 clockwise:YES];
        
        _secondShapeLayer.frame = self.bounds;
        _secondShapeLayer.path = path.CGPath;
        _secondShapeLayer.strokeEnd = 1;
        self.secondHalfLayer.mask = _secondShapeLayer;
        
        _firstHalfLayer.hidden = NO;
        _secondHalfLayer.hidden = NO;
    }
}



- (void)setInnerImage:(UIImage *)innerImage
{
    _innerImage = innerImage;
    _innerImageView.image = innerImage;
}

- (void)setStartColor:(UIColor *)startColor
{
    _startColor = startColor;
    if (startColor) {
        if (_endColor) {
            [self decideMidColor];
            self.firstHalfLayer.colors = @[(__bridge id)_startColor.CGColor,(__bridge id)_midColor.CGColor];
            self.secondHalfLayer.colors = @[(__bridge id)_midColor.CGColor,(__bridge id)_endColor.CGColor];
        }
    }
    
}

- (void)setEndColor:(UIColor *)endColor
{
    _endColor = endColor;
    if (endColor) {
        if (_startColor) {
            [self decideMidColor];
            self.firstHalfLayer.colors = @[(__bridge id)_startColor.CGColor,(__bridge id)_midColor.CGColor];
            self.secondHalfLayer.colors = @[(__bridge id)_midColor.CGColor,(__bridge id)_endColor.CGColor];
        }
    }
    
}

- (void)setStartRadian:(CGFloat)startRadian
{
    _startRadian = startRadian;
    
    CGFloat x = self.radius + cos(startRadian) * self.radius;
    CGFloat y = self.radius + sin(startRadian) * self.radius;
    self.firstHalfLayer.startPoint = CGPointMake(x/(self.radius * 2), y/(self.radius * 2));
    self.secondHalfLayer.endPoint = CGPointMake(x/(self.radius * 2), y/(self.radius * 2));
    
    x = self.radius - cos(startRadian) * self.radius;
    y = self.radius - sin(startRadian) * self.radius;
    self.firstHalfLayer.endPoint = CGPointMake(x/(self.radius * 2), y/(self.radius * 2));
    self.secondHalfLayer.startPoint = CGPointMake(x/(self.radius * 2), y/(self.radius * 2));
}

- (void)decideMidColor
{
    CGFloat firstComponents[4];
    CGFloat secondComponents[4];
    
    [self getRGBComponents:firstComponents forColor:_startColor];
    [self getRGBComponents:secondComponents forColor:_endColor];
    
    CGFloat r = (firstComponents[0] + secondComponents[0])/2;
    CGFloat g = (firstComponents[1] + secondComponents[1])/2;
    CGFloat b = (firstComponents[2] + secondComponents[2])/2;
    CGFloat a = (firstComponents[3] + secondComponents[3])/2;
    
    self.midColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (void)getRGBComponents:(CGFloat [4])components forColor:(UIColor *)color
{
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 4; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

#pragma mark - animated progress
- (void)setProgress:(CGFloat)progress animated:(BOOL)flag
{
    if (progress > 100) {
        progress = 100;
    }
    fromProgress = _progress;
    _progress = progress;
    if (flag) {
        DHProgressAnimation * animation = [[DHProgressAnimation alloc] initWithAnimationDuration:0.85 animationEaseOut:YES toProgress:_progress animationBlock:^(CGFloat progress) {
            [self setProgress:progress];
        } completionBlock:nil];
        animation.fromProgress = fromProgress;
        
        [animation runAnimation];
    } else {
        [self setProgress:progress];
    }
    
}


@end
