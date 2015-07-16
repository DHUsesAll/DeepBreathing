//
//  DHFunctionChartView.m
//  HealthManagement
//
//  Created by DreamHack on 14-12-2.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHFunctionChartView.h"
#import "DHVector.h"
#import "DHConvenienceAutoLayout.h"

@interface DHFunctionChartView ()

@property (nonatomic, copy) FunctionExpress functionExpress;
@property (nonatomic, strong) UIColor * lineColor;
@property (nonatomic, strong) CAShapeLayer * lineLayer;
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation DHFunctionChartView

- (void)dealloc
{
    self.functionExpress = nil;
    self.lineColor = nil;
    self.lineLayer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineColor = lineColor;
        self.lineWidth = lineWidth;
        self.layer.masksToBounds = YES;

        self.backgroundColor = [UIColor clearColor];
        CAShapeLayer * lineLayer = [CAShapeLayer layer];
        lineLayer.frame = self.bounds;
        lineLayer.lineWidth = _lineWidth;
        lineLayer.strokeColor = _lineColor.CGColor;
        lineLayer.backgroundColor = [UIColor clearColor].CGColor;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:lineLayer];
        self.lineLayer = lineLayer;
    }
    return self;
}


- (void)drawWithFunctionExpress:(FunctionExpress)express
{
    self.functionExpress = express;
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    //    CGFloat sub = (self.frame.size.height/7-1)*_functionExpress(0);
    [bezierPath moveToPoint:[DHVector uikitPointFromOpenGLPoint:CGPointMake(0, _functionExpress(0)) referenceHeight:self.frame.size.height]];
    CGFloat pointOffset = 1;
    for (float x = pointOffset; x <= self.frame.size.width; x+=pointOffset) {
        CGFloat y = _functionExpress(x);
        //        CGFloat y = _functionExpress(x)*times;
        CGPoint p = CGPointMake(x, y);
        
        [bezierPath addLineToPoint:[DHVector uikitPointFromOpenGLPoint:p referenceHeight:self.frame.size.height]];
        
    }
    
    _lineLayer.path = bezierPath.CGPath;
}

//- (void)drawRect:(CGRect)rect
//{
//    
//}

@end
