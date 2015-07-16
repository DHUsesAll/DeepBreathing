//
//  DHSegmentedProgressView.m
//  HealthManagement
//
//  Created by DreamHack on 14-11-3.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHSegmentedProgressView.h"
#import "DHVector.h"
#import "DHProgressAnimation.h"
#import "DHConvenienceAutoLayout.h"
#import "DHThemeSettings.h"
#import "DHFoundationTool.h"

#define ANIMATION_DURATION  0.65

@interface DHSegmentedProgressView ()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) NSMutableArray * layers;
@property (nonatomic, strong) NSMutableArray * endPositions;
@property (nonatomic, strong) NSMutableArray * endProgresses;
@property (nonatomic, strong) NSMutableArray * imageLayers;
@property (nonatomic, strong) NSMutableArray * progressLabels;

@property (nonatomic, assign) NSInteger animationItemIndex;
@property (nonatomic, strong) UILabel * infoLabel;

@property (nonatomic, assign) DHSegmentedProgressViewProgressLabelOption option;

@end

@implementation DHSegmentedProgressView

- (void)dealloc
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.layers = nil;
    self.endPositions = nil;
    self.endProgresses = nil;
    self.imageLayers = nil;
    self.progressLabels = nil;
    self.infoLabel = nil;
}

- (instancetype)initWithRadius:(CGFloat)radius center:(CGPoint)center lineWidth:(CGFloat)lineWidth dataSource:(id<DHSegmentedProgressViewDataSource>)dataSource progressLabelOption:(DHSegmentedProgressViewProgressLabelOption)option
{
    
    self = [super initWithFrame:[DHFoundationTool rectWithSize:CGSizeMake(radius*2, radius*2) center:center]];
    if (self) {
        self.dataSource = dataSource;
        self.radius = radius;
        self.center = center;
        self.lineWidth = lineWidth;
        self.option = option;
//        [self draw];
    }
    
    return self;
    
}

- (void)draw
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = [DHThemeSettings themeTextColor];
    [self addSubview:titleLabel];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInSegmentedProgressView:)] && [self.dataSource respondsToSelector:@selector(segmentedProgressView:colorForItemAtIndex:)] && [self.dataSource respondsToSelector:@selector(segmentedProgressView:headerImageForItemAtIndex:)] && [self.dataSource respondsToSelector:@selector(ratesForItemsInSegmentedProgressView:)]) {
        if ([self.dataSource numberOfItemsInSegmentedProgressView:self] == 0) {
            titleLabel.font = [DHThemeSettings themeFontOfSize:16*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
//            titleLabel.text = @"暂无数据";
            [titleLabel sizeToFit];
            titleLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            return;
        }
        
        titleLabel.font = [DHThemeSettings themeFontOfSize:13*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
        titleLabel.text = @"按量统计";
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.infoLabel = titleLabel;
        self.layers = [NSMutableArray arrayWithCapacity:0];
        self.endPositions = [NSMutableArray arrayWithCapacity:0];
        self.endProgresses = [NSMutableArray arrayWithCapacity:0];
        self.imageLayers = [NSMutableArray arrayWithCapacity:0];
        NSInteger itemNumber = [self.dataSource numberOfItemsInSegmentedProgressView:self];
        NSMutableArray * rates = [NSMutableArray arrayWithArray:[self.dataSource ratesForItemsInSegmentedProgressView:self]];
        _animationItemIndex = 0;
        NSAssert(itemNumber == rates.count, @"item number must be equal to rates' count");
        
        
        
        CGFloat lastEnd = 0;
        // 用向量旋转计算图片位置
        DHVector * originVector = [[DHVector alloc] initWithStartPoint:[DHVector openGLPointFromUIKitPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) referenceHeight:self.frame.size.height] endPoint:[DHVector openGLPointFromUIKitPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2) referenceHeight:self.frame.size.height]];
        for (int i = 0; i < itemNumber; i++) {
            
            if ([[rates objectAtIndex:i] floatValue] == 0) {
                continue;
            }
            CAShapeLayer * layer = [CAShapeLayer layer];
            layer.frame = self.bounds;
            layer.lineWidth = self.lineWidth;
            layer.strokeColor = [self.dataSource segmentedProgressView:self colorForItemAtIndex:i].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            [self.layer addSublayer:layer];
            UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
            
            layer.path = path.CGPath;
            layer.strokeStart = lastEnd;
            layer.strokeEnd = [[rates objectAtIndex:i] floatValue]+lastEnd;
            lastEnd += [[rates objectAtIndex:i] floatValue];
            [self.endProgresses addObject:[NSNumber numberWithFloat:lastEnd]];
            [self.layers addObject:layer];
            
            [originVector rotateClockwiselyWithRadian:M_PI*[[rates objectAtIndex:i] floatValue]];
            
            [self.endPositions addObject:[NSValue valueWithCGPoint:[DHVector uikitPointFromOpenGLPoint:[originVector endPoint] referenceHeight:self.frame.size.height]]];
            
            [originVector rotateClockwiselyWithRadian:M_PI*[[rates objectAtIndex:i] floatValue]];
            layer.strokeEnd = layer.strokeStart;
        }
//        NSLog(@"%@",self.endPositions);
        for (int i = 0; i < itemNumber; i++) {
            if ([[rates objectAtIndex:i] floatValue] == 0) {
                continue;
            }
            CALayer * imageLayer = [CALayer layer];
            imageLayer.contents = (__bridge id)[self.dataSource segmentedProgressView:self headerImageForItemAtIndex:i].CGImage;
            imageLayer.bounds = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 30, 30) adjustWidth:YES];
//            imageLayer.position = originVector.endPoint;
            [self.layer addSublayer:imageLayer];
            [self.imageLayers addObject:imageLayer];
            imageLayer.hidden = YES;
        }
        
        self.progressLabels = [NSMutableArray arrayWithCapacity:0];
        
        if (self.option == DHSegmentedProgressViewProgressLabelOptionInner) {
            for (int i = 0; i < itemNumber; i++) {
                if ([[rates objectAtIndex:i] floatValue] == 0) {
                    continue;
                }
                UILabel * label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:self.lineWidth/4];
                label.textColor = [UIColor whiteColor];
                label.text = [self.dataSource segmentedProgressView:self progressLabelTextForItemAtIndex:i];
                [label sizeToFit];
                label.center = [[self.endPositions objectAtIndex:i] CGPointValue];
                [self addSubview:label];
                [_progressLabels addObject:label];
            }
            
            
        } else if (self.option == DHSegmentedProgressViewProgressLabelOptionOutter) {
            for (int i = 0; i < itemNumber; i++) {
                if ([[rates objectAtIndex:i] floatValue] == 0) {
                    continue;
                }
                UILabel * label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:self.lineWidth/3*2];
                label.textColor = [self.dataSource segmentedProgressView:self colorForItemAtIndex:i];
                label.text = [self.dataSource segmentedProgressView:self progressLabelTextForItemAtIndex:i];
                [label sizeToFit];
                label.hidden = YES;
                [self addSubview:label];
                [_progressLabels addObject:label];
            }

        }
        
//        [_endProgresses removeLastObject];
//        [_endProgresses insertObject:@0 atIndex:0];
//        [self runAnimationWithRates:rates itemIndex:0];
        [self runAnimation];
    }
}

- (void)reloadData
{
//    NSArray * array = [NSArray arrayWithArray:self.subviews];
////    for (UIView * view in array) {
////        [UIView animateWithDuration:0.85 animations:^{
////            view.alpha = 0;
////        } completion:^(BOOL finished) {
////            [view removeFromSuperview];
////        }];
////    }
//    [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    array = [NSArray arrayWithArray:self.layer.sublayers];
//    for (CALayer * layer in array) {
//        
//        [UIView animateWithDuration:0.85 animations:^{
//            layer.opacity = 0;
//        } completion:^(BOOL finished) {
//            [layer removeFromSuperlayer];
//        }];
//    }
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self draw];
}

- (void)runAnimationWithRates:(NSArray *)rates itemIndex:(NSInteger)index
{
    if (index == [rates count]) {
        return;
    }
    DHProgressAnimation * animation = [[DHProgressAnimation alloc] initWithAnimationDuration:0.65 animationEaseOut:NO toProgress:100*[[rates objectAtIndex:index] floatValue] animationBlock:^(CGFloat progress) {
        [self setProgress:progress forItemAtIndex:index];
    } completionBlock:^{
        
        [self runAnimationWithRates:rates itemIndex:index+1];
        
    }];
    
    [animation runAnimation];

}

- (void)runAnimation
{
    NSArray * rates = [self.dataSource ratesForItemsInSegmentedProgressView:self];
    CAShapeLayer * layer = [self.layers objectAtIndex:_animationItemIndex];
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"strokeEnd";
    animation.delegate = self;
    animation.duration = ANIMATION_DURATION*[[rates objectAtIndex:_animationItemIndex] floatValue];
    animation.fromValue = [NSNumber numberWithFloat:layer.strokeStart];
    animation.toValue = [_endProgresses objectAtIndex:_animationItemIndex];
    animation.removedOnCompletion = NO;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :0.5 :0.5 :0.5];
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:@"key"];
//    layer.strokeEnd = [[_endProgresses objectAtIndex:_animationItemIndex] floatValue];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSArray * rates = [self.dataSource ratesForItemsInSegmentedProgressView:self];
    CGFloat startAngle = 0;
    if (_animationItemIndex > 0) {
        startAngle = 2*M_PI*[[_endProgresses objectAtIndex:_animationItemIndex-1] floatValue];
    }
    
    CGFloat endAngle = 2*M_PI*[[_endProgresses objectAtIndex:_animationItemIndex] floatValue];
    CALayer * layer = [self.imageLayers objectAtIndex:_animationItemIndex];
    
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2-layer.position.x, self.frame.size.height/2-layer.position.y) radius:_radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    layer.hidden = NO;
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.path = path.CGPath;
    animation.duration = ANIMATION_DURATION*[[rates objectAtIndex:_animationItemIndex] floatValue];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :0.5 :0.5 :0.5];
    animation.additive = YES;
    animation.calculationMode = kCAAnimationPaced;
    [layer addAnimation:animation forKey:@"image"];
    
    if (self.progressLabels.count>0 && self.option == DHSegmentedProgressViewProgressLabelOptionOutter) {
        layer = [[self.progressLabels objectAtIndex:_animationItemIndex] layer];
        
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2-layer.position.x, self.frame.size.height/2-layer.position.y) radius:_radius+35*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier] startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        [[self.progressLabels objectAtIndex:_animationItemIndex] setHidden:NO];
        animation.path = path.CGPath;
        [layer addAnimation:animation forKey:@"label"];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _animationItemIndex++;
    if (_animationItemIndex < [self.layers count]) {
        [self runAnimation];
    } else {
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.values = @[@0,@0.032,@0];
        animation.keyTimes = @[@0,@0.3,@1];
        animation.duration = 0.45;
        animation.additive = YES;
        [self.layer addAnimation:animation forKey:@"self"];
    }
}

- (void)setProgress:(CGFloat)progress forItemAtIndex:(NSInteger)index
{
    CAShapeLayer * layer = [self.layers objectAtIndex:index];
    layer.strokeEnd = (progress+[[self.endProgresses objectAtIndex:index] floatValue]*100)/100;
}

- (void)setInfoLabelHidden:(BOOL)hidden
{
    _infoLabel.hidden = hidden;
}

- (id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    } else {
        return hitView;
    }
}

@end
