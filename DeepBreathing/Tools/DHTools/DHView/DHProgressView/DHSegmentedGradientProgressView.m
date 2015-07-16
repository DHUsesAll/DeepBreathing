//
//  DHSegmentedProgressView.m
//  Test3D
//
//  Created by DreamHack on 14-10-14.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHSegmentedGradientProgressView.h"


@interface DHSegmentedGradientProgressView()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, strong) NSArray * colors;
@property (nonatomic, assign) CGPoint fromPoint;
@property (nonatomic, assign) CGPoint toPoint;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) CGFloat radian;
@property (nonatomic, assign) BOOL clockWise;


// layers
@property (nonatomic, strong) CALayer * progressLayer;
@property (nonatomic, strong) CALayer * bornGrooveLayer;

@end

@implementation DHSegmentedGradientProgressView

- (void)dealloc
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_progressLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_progressLayer removeFromSuperlayer];
    [_bornGrooveLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_bornGrooveLayer removeFromSuperlayer];
    self.progressImage = nil;
    self.progressLayer = nil;
    self.bornGrooveLayer = nil;
    self.colors = nil;
}

- (instancetype)initWithCenter:(CGPoint)center
                  circleRadius:(CGFloat)radius
                 progressWidth:(CGFloat)progressWidth
                gradientColors:(NSArray *)colors
             fromGradientPoint:(CGPoint)fromPoint
               toGradientPoint:(CGPoint)toPoint
                 segmentNumber:(NSInteger)number
                   startRadian:(CGFloat)radian
                     clockWise:(BOOL)flag
{
    
    self = [super init];
    self.progressWidth = progressWidth;
    self.radius = radius;
    self.center = center;
    self.colors = colors;
    self.fromPoint = fromPoint;
    self.toPoint = toPoint;
    self.number = number;
    self.radian = radian;
    
    self.clockWise = flag;
    
    [self setLayers];
    
    return self;
}

- (void)setProgress:(CGFloat)progress forSegment:(NSInteger)segmentIndex animated:(BOOL)flag animationStopBlock:(AnimationCompletionBlock)completion
{
    _progress = progress;
    if (!flag) {
        [self setProgress:progress forSegment:segmentIndex];
    } else {
        
//        DHProgressAnimation * animation = [[DHProgressAnimation alloc] initWithAnimationDuration:0.85 animationEaseOut:YES toProgress:_progress animationBlock:^(CGFloat progress) {
//            [self setProgress:progress forSegment:segmentIndex];
//        } completionBlock:^{
//            if (completion) {
//                completion(YES);
//            }
//        }];
//        
//        [animation runAnimation];
        CAGradientLayer * gradientLayer = [self.progressLayer.sublayers objectAtIndex:segmentIndex];
        CAShapeLayer * shapeLayer = (CAShapeLayer *)gradientLayer.mask;
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.keyPath = @"strokeEnd";
        animation.duration = 0.85;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        if (completion) {
            animation.completionBlock = completion;
        }
        animation.fromValue = @0;
        animation.toValue = [NSNumber numberWithFloat:progress/100];
        if (completion) {
            [animation setDelegate:self];
        }
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [shapeLayer addAnimation:animation forKey:@"stroke"];
//        shapeLayer.strokeEnd = progress/100;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isKindOfClass:[CABasicAnimation class]]) {
        CABasicAnimation * basicAnimation = (CABasicAnimation *)anim;
        if (basicAnimation.completionBlock) {
            basicAnimation.completionBlock(flag);
        }
    }
    
}

#pragma mark - setter
- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, radius*2+self.progressWidth*2, radius*2+self.progressWidth*2);
}


#pragma mark - private methods


- (void)setLayers
{
    self.progressLayer = [CALayer layer];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.backgroundColor = [UIColor colorWithRed:235.f/255 green:235.f/255 blue:235.f/255 alpha:1].CGColor;
    
    self.bornGrooveLayer = [CALayer layer];
    self.bornGrooveLayer.frame = self.bounds;
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.lineWidth = self.progressWidth;
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = [[UIColor clearColor]CGColor];
    shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:_radius+self.progressWidth/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    shapeLayer.path = path.CGPath;
    _progressLayer.mask = shapeLayer;
    [self.layer addSublayer:_progressLayer];
    [self.layer addSublayer:_bornGrooveLayer];
    
    for (int i = 0; i < _number; i++) {
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = self.progressWidth;
        shapeLayer.fillColor = [[UIColor clearColor]CGColor];
        shapeLayer.strokeColor = [[UIColor colorWithWhite:0.2 alpha:0.2] CGColor];
        shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
        shapeLayer.frame = self.bounds;
        UIBezierPath * path = [UIBezierPath bezierPath];
        CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [path addArcWithCenter:center radius:_radius+self.progressWidth/2 startAngle:-M_PI/_number+_radian+M_PI*2/_number*i endAngle:-M_PI/_number+_radian+M_PI*2/_number*i+M_PI/100 clockwise:YES];
        
        shapeLayer.path = path.CGPath;
        
        [_bornGrooveLayer addSublayer:shapeLayer];
    }
    
    for (int i = 0; i < _number; i++) {
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        
        gradientLayer.startPoint = self.fromPoint;
        gradientLayer.endPoint = self.toPoint;
        gradientLayer.colors = self.colors;
        
        gradientLayer.frame = self.bounds;
        
//        gradientLayer.hidden = YES;
        
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = self.progressWidth;
        shapeLayer.fillColor = [[UIColor clearColor]CGColor];
        shapeLayer.strokeColor = [[UIColor redColor] CGColor];
        shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
        shapeLayer.frame = self.bounds;
        shapeLayer.strokeEnd = 0;
        CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        CGFloat startAngle = -M_PI/_number+_radian+M_PI*2/_number*i;
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:_radius+self.progressWidth/2 startAngle:startAngle endAngle:startAngle+M_PI*2/_number clockwise:YES];
        
        shapeLayer.path = path.CGPath;
        
        gradientLayer.mask = shapeLayer;
        [_progressLayer addSublayer:gradientLayer];
    }
    
}

- (void)setProgressImage:(UIImage *)progressImage
{
    _progressImage = progressImage;
    for (CAGradientLayer * gradientLayer in self.progressLayer.sublayers) {
        gradientLayer.colors = nil;
        gradientLayer.contents = (__bridge id)(_progressImage.CGImage);
        
    }
}

- (void)setProgress:(CGFloat)progress forSegment:(NSInteger)segmentIndex
{
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CAGradientLayer * gradientLayer = [self.progressLayer.sublayers objectAtIndex:segmentIndex];
    gradientLayer.hidden = NO;
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = self.progressWidth;
    shapeLayer.fillColor = [[UIColor clearColor]CGColor];
    shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    shapeLayer.frame = self.bounds;
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:_radius+self.progressWidth/2 startAngle:-M_PI/_number+_radian+M_PI*2/_number*segmentIndex endAngle:-M_PI/_number+_radian+M_PI*2/_number*segmentIndex+M_PI*2/_number*progress/100 clockwise:_clockWise];
    
    
    shapeLayer.path = path.CGPath;
    gradientLayer.mask = shapeLayer;
    
}

- (void)setProgressBornGrooveHidden:(BOOL)hidden
{
    _bornGrooveLayer.hidden = hidden;
}

- (CALayer *)progressLayer
{
    return _progressLayer;
}


@end
