//
//  DHGradientStepProgressView.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-28.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHGradientStepProgressView.h"
#import "DHFoundationTool.h"
#import "DHProgressAnimation.h"
#import "DHThemeSettings.h"
#import "DHConvenienceAutoLayout.h"

#define ANIMATION_DURATION  0.45
#define MAGIC_NUMBER    6

@interface DHGradientStepProgressView ()

@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * gradientColors;
@property (nonatomic, assign) CGFloat progressHeight;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIFont * titleFont;
// LAYERS
@property (nonatomic, strong) CALayer * backgroundLayer;
@property (nonatomic, strong) CALayer * maskLayer;
@property (nonatomic, strong) CAGradientLayer * gradientLayer;


@property (nonatomic, strong) CALayer * textBackgroundLayer;
@property (nonatomic, strong) CALayer * textMaskLayer;
@property (nonatomic, strong) CALayer * textLayer;

@end


@implementation DHGradientStepProgressView
{
    int currentStep ;
    BOOL stepAnimation;
    CGFloat fromProgress;
}

- (void)dealloc
{
    self.titles = nil;
    self.gradientColors = nil;
    self.titleFont = nil;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles gradientColors:(NSArray *)gradientColors progressHeight:(CGFloat)progressHeight titleFont:(UIFont *)titleFont
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        self.titleFont = titleFont;
        self.gradientColors = gradientColors;
        self.progressHeight = progressHeight;
        currentStep = 0;
        stepAnimation = YES;
        [self draw];
        self.backgroundColor = [UIColor clearColor];
//        [self setNeedsDisplay];
//        [self setProgress:0 animated:NO];
    }
    return self;
}

- (void)draw
{
    
    [self drawBackgroundLayer];
    [self drawGradientLayer];
    [self drawMaskLayer];
    [self drawTextLayers];
    [self drawNumbers];
    
}

- (void)drawGradientLayer
{
    self.gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = CGRectMake(0, 0, 0, _progressHeight);
    _gradientLayer.colors = self.gradientColors;
    _gradientLayer.startPoint = CGPointMake(0, 0.5);
    _gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    [self.layer addSublayer:_gradientLayer];
}

- (void)drawBackgroundLayer
{
    self.backgroundLayer = [CALayer layer];
    self.backgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width, _progressHeight);
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.maskLayer.bounds;
    shapeLayer.strokeColor = [DHFoundationTool colorWith255Red:187 green:187 blue:187 alpha:1].CGColor;
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 4;
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _progressHeight/2)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, _progressHeight/2)];
    shapeLayer.path = path.CGPath;
    [self.backgroundLayer addSublayer:shapeLayer];
    
    for (int i = 0; i < _titles.count; i++) {
        CGFloat x = self.frame.size.width/(_titles.count * 2) * (i*2+1);
        CGFloat y = _progressHeight/2;
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, 0, _progressHeight, _progressHeight);
        layer.position = CGPointMake(x, y);
        layer.strokeColor = [DHFoundationTool colorWith255Red:187 green:187 blue:187 alpha:1].CGColor;
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.lineWidth = _progressHeight;
        layer.cornerRadius = _progressHeight/2;
        layer.masksToBounds = YES;
        UIBezierPath * aPath = [UIBezierPath bezierPath];
        [aPath moveToPoint:CGPointMake(0, _progressHeight/2)];
        [aPath addLineToPoint:CGPointMake(_progressHeight, _progressHeight/2)];
        
        layer.path = aPath.CGPath;
        [self.backgroundLayer addSublayer:layer];
    }
    
    [self.layer addSublayer:self.backgroundLayer];
}

- (void)drawMaskLayer
{
    self.maskLayer = [CALayer layer];
    self.maskLayer.frame = CGRectMake(0, 0, self.frame.size.width, _progressHeight);
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.maskLayer.bounds;
    shapeLayer.strokeColor = [DHFoundationTool colorWith255Red:187 green:187 blue:187 alpha:1].CGColor;
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 4;
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _progressHeight/2)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, _progressHeight/2)];
    shapeLayer.path = path.CGPath;
    [self.maskLayer addSublayer:shapeLayer];
    for (int i = 0; i < _titles.count; i++) {
        CGFloat x = self.frame.size.width/(_titles.count * 2) * (i*2+1);
        CGFloat y = _progressHeight/2;
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, 0, _progressHeight, _progressHeight);
        layer.position = CGPointMake(x, y);
        layer.strokeColor = [DHFoundationTool colorWith255Red:187 green:187 blue:187 alpha:1].CGColor;
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.lineWidth = _progressHeight;
        layer.cornerRadius = _progressHeight/2;
        layer.masksToBounds = YES;
        UIBezierPath * aPath = [UIBezierPath bezierPath];
        [aPath moveToPoint:CGPointMake(0, _progressHeight/2)];
        [aPath addLineToPoint:CGPointMake(_progressHeight, _progressHeight/2)];
//        layer.strokeEnd = 1;
        layer.path = aPath.CGPath;
        [self.maskLayer addSublayer:layer];
    }
    [self.maskLayer addSublayer:shapeLayer];
    _gradientLayer.mask = self.maskLayer;
}

- (void)drawTextLayers
{
    self.textBackgroundLayer = [CALayer layer];
    _textBackgroundLayer.frame = CGRectMake(0, _progressHeight, self.frame.size.width, self.frame.size.height-_progressHeight);
    [self.layer addSublayer:_textBackgroundLayer];

    self.textLayer = [CALayer layer];
    _textLayer.frame = CGRectMake(0, _progressHeight, 0, self.frame.size.height-_progressHeight);
    _textLayer.backgroundColor = [DHThemeSettings themeTextColor].CGColor;
    [self.layer addSublayer:_textLayer];
    
    self.textMaskLayer = [CALayer layer];
    _textMaskLayer.frame = _textBackgroundLayer.bounds;
    
    for (int i = 0; i < _titles.count; i++) {
        
        CFStringRef fontName = (__bridge CFStringRef)_titleFont.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        
        CGFloat x = self.frame.size.width/(_titles.count * 2) * (i*2+1);
        CGFloat y = (_textBackgroundLayer.frame.size.height+8)/2;
        CATextLayer * textLayer = [CATextLayer layer];
        textLayer.bounds = CGRectMake(0, 0, self.frame.size.width/_titles.count, _textBackgroundLayer.frame.size.height);
        textLayer.position = CGPointMake(x, y);
        textLayer.wrapped = YES;
        textLayer.font = fontRef;
        textLayer.fontSize = _titleFont.pointSize;
        textLayer.string = [_titles objectAtIndex:i];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.foregroundColor = [DHFoundationTool colorWith255Red:187 green:187 blue:187 alpha:1].CGColor;
        textLayer.alignmentMode = kCAAlignmentCenter;
        [_textBackgroundLayer addSublayer:textLayer];
        
        
        CATextLayer * maskLayer = [CATextLayer layer];
        maskLayer.bounds = CGRectMake(0, 0, self.frame.size.width/_titles.count, _textLayer.frame.size.height);
        maskLayer.position = CGPointMake(x, y);
        maskLayer.font = fontRef;
        maskLayer.fontSize = _titleFont.pointSize;
        maskLayer.string = [_titles objectAtIndex:i];
        maskLayer.contentsScale = [UIScreen mainScreen].scale;
        maskLayer.alignmentMode = kCAAlignmentCenter;
        [_textMaskLayer addSublayer:maskLayer];
        CGFontRelease(fontRef);
    }
    _textLayer.mask = _textMaskLayer;
}

- (void)drawNumbers
{
    for (int i = 0; i < _titles.count; i++) {
        
        CFStringRef fontName = (__bridge CFStringRef)[UIFont fontWithName:@"Avenir Next Condensed" size:16*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]].fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        
        CGFloat x = self.frame.size.width/(_titles.count * 2) * (i*2+1);
        CGFloat y = _progressHeight/2;
        CATextLayer * textLayer = [CATextLayer layer];
        textLayer.bounds = CGRectMake(0, 0, self.frame.size.width/_titles.count, 22);
        textLayer.position = CGPointMake(x, y);
        textLayer.wrapped = YES;
        textLayer.font = fontRef;
        textLayer.fontSize = _titleFont.pointSize;
        textLayer.string = [NSString stringWithFormat:@"0%d",i+1];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.foregroundColor = [UIColor whiteColor].CGColor;
        textLayer.alignmentMode = kCAAlignmentCenter;
        
        [self.layer addSublayer:textLayer];
        CGFontRelease(fontRef);
    }
}

- (void)setCompletionStep:(NSInteger)completionStep
{
    if (completionStep > _titles.count) {
        _completionStep = _titles.count;
    } else {
        _completionStep = completionStep;
    }
    CGFloat toProgress = (CGFloat)completionStep / _titles.count * 100;
    _progress = toProgress;
    DHProgressAnimation * animation = [[DHProgressAnimation alloc] initWithAnimationDuration:ANIMATION_DURATION animationEaseOut:YES toProgress:toProgress animationBlock:^(CGFloat progress) {
        [self setProgress:progress];
    } completionBlock:nil];
    animation.fromProgress = fromProgress;
    fromProgress = toProgress;
    [animation runAnimation];
    
}

- (void)setProgress:(CGFloat)progress forStep:(NSInteger)step
{
    CGFloat x = self.frame.size.width/(_titles.count * 2) + _progressHeight/2;

    CGFloat totalProgress = x/self.frame.size.width*100;
    CGFloat stepProgress = progress/100*totalProgress+100/_titles.count*(step - 1);
    
    DHProgressAnimation * animation = [[DHProgressAnimation alloc] initWithAnimationDuration:ANIMATION_DURATION animationEaseOut:YES toProgress:stepProgress animationBlock:^(CGFloat progress) {
        [self setProgress:progress];
    } completionBlock:^{
        
    }];
    animation.fromProgress = fromProgress;
    fromProgress = stepProgress;
    [animation runAnimation];
}

- (void)setProgress:(CGFloat)progress
{
//    CAShapeLayer * shapeLayer = [_maskSubLayers objectAtIndex:0];
//    shapeLayer.strokeEnd = progress/100;
//
    
    CGFloat unitWidth = self.frame.size.width/100;
    CGFloat currentWidth = progress * unitWidth;
//    CGFloat stepWidth = (currentStep * 2 + 1) * self.frame.size.width/(_titles.count*2);
//    if (currentWidth > stepWidth  /*填充误差*/) {
//        currentStep++;
//        
//        CGFloat expectedWidth = _progress * unitWidth;
//        CGFloat velocity = expectedWidth / ANIMATION_DURATION;
//        CGFloat stepDuration = _progressHeight/velocity;
//        if (stepAnimation) {
//            stepAnimation = NO;
//            DHProgressAnimation * animation = [[DHProgressAnimation alloc] initWithAnimationDuration:stepDuration animationEaseOut:NO toProgress:100 animationBlock:^(CGFloat progress) {
//                [self setStepProgress:progress atStep:currentStep];
//            } completionBlock:^{
//                stepAnimation = YES;
//            }];
//            
//            [animation runAnimation];
//            
//        }
//    }
    
    _gradientLayer.frame = CGRectMake(_gradientLayer.frame.origin.x, _gradientLayer.frame.origin.y, currentWidth, _gradientLayer.frame.size.height);
    _gradientLayer.startPoint = CGPointMake(0, 0.5);
    _gradientLayer.endPoint = CGPointMake(self.frame.size.width/currentWidth, 0.5);
    _textLayer.frame = CGRectMake(_textLayer.frame.origin.x, _textLayer.frame.origin.y, currentWidth, _textLayer.frame.size.height);
}

//- (void)setStepProgress:(CGFloat)progress atStep:(NSInteger)step
//{
//    CAShapeLayer * shapeLayer = [_maskSubLayers objectAtIndex:step];
//    shapeLayer.strokeEnd = progress/100;
//}

- (void)drawRect:(CGRect)rect
{
    [self draw];
}

@end
