//
//  DHStatisticsView.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-27.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHGradientStatisticsView.h"

#import "DHFoundationTool.h"
#import "DHConvenienceAutoLayout.h"
#import "DateTools.h"
#import "DHThemeSettings.h"


#define LINE_COLOR [DHFoundationTool colorWith255Red:47 green:4 blue:73 alpha:1]
#define X_OFFSET    (0 * [DHConvenienceAutoLayout iPhone5HorizontalMutiplier])
#define LINE_OFFSET (40 * [DHConvenienceAutoLayout iPhone5HorizontalMutiplier])
#define TEXT_HEIGHT ([DHConvenienceAutoLayout iPhone5VerticalMutiplier]*12)
#define LINE_WIDTH  2.6
#define ITEM_TAG        2345

@interface DHGradientStatisticsView ()

@property (nonatomic, strong) UIColor * startColor;
@property (nonatomic, strong) UIColor * endColor;
@property (nonatomic, assign) CGFloat startValue;
@property (nonatomic, assign) CGFloat endValue;


@property (nonatomic, strong) CAGradientLayer * textGradientLayer;
@property (nonatomic, strong) CAGradientLayer * lineGradientLayer;


@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation DHGradientStatisticsView

- (void)dealloc
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.startColor = nil;
    self.endColor = nil;
    self.valueAttributes = nil;
    self.textGradientLayer = nil;
    self.lineGradientLayer = nil;
    self.scrollView = nil;
}

+ (NSDictionary *)valueAttributesWithXDescriptions:(NSArray *)xDescriptions yValues:(NSArray *)yValues
{
    NSAssert(xDescriptions.count == yValues.count, @"x values' count should equal to y values' count");
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    for (int i = 0; i < xDescriptions.count; i++) {
        
        [dictionary setObject:[yValues objectAtIndex:i] forKey:[xDescriptions objectAtIndex:i]];
        
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (instancetype)initWithFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor startValue:(CGFloat)startValue endValue:(CGFloat)endValue valueAttributes:(NSDictionary *)attributes
{
    self = [super initWithFrame:frame];
    if (self) {
        self.startColor = startColor;
        self.endColor = endColor;
        self.startValue = startValue;
        self.endValue = endValue;
        self.valueAttributes = attributes;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor startValue:(CGFloat)startValue endValue:(CGFloat)endValue totalScore:(CGFloat)totalScore valueAttributes:(NSDictionary *)attributes yUnit:(NSString *)yUnit
{
    self = [super initWithFrame:frame];
    if (self) {
        self.startColor = startColor;
        self.endColor = endColor;
        self.startValue = startValue;
        self.endValue = endValue;
        self.valueAttributes = attributes;
        self.backgroundColor = [UIColor clearColor];
        self.totalScore = totalScore;
        self.yUnit = yUnit;
//        [self draw];
    }
    return self;
}

- (BOOL)draw
{
    self.textGradientLayer = [CAGradientLayer layer];
    _textGradientLayer.frame = self.bounds;
    _textGradientLayer.colors = @[(__bridge id)self.startColor.CGColor, (__bridge id)self.endColor.CGColor];
    _textGradientLayer.startPoint = CGPointMake(0.5, 1-self.startValue);
    _textGradientLayer.endPoint = CGPointMake(0.5, 1-self.endValue);
    [self.layer addSublayer:_textGradientLayer];
    
    CALayer * layer = [CALayer layer];
    layer.frame = self.bounds;
    layer.masksToBounds = NO;
    
    UIFont * font = [UIFont boldSystemFontOfSize:14*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    
    CATextLayer * layer1 = [CATextLayer layer];
    layer1.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 34, 14) adjustWidth:YES];
    layer1.wrapped = YES;
    layer1.font = fontRef;
    layer1.fontSize = font.pointSize;
    layer1.string = [NSString stringWithFormat:@"%ld",self.totalScore];
    if (_yUnit) {
        layer1.string = [layer1.string stringByAppendingString:_yUnit];
    }
    layer1.contentsScale = [UIScreen mainScreen].scale;
    layer1.alignmentMode = kCAAlignmentRight;
    [layer addSublayer:layer1];
    
    CATextLayer * layer2 = [CATextLayer layer];
    layer2.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, (self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])/[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 34, 14) adjustWidth:YES];
    layer2.position = CGPointMake(layer2.position.x, self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
    layer2.wrapped = YES;
    layer2.font = fontRef;
    layer2.fontSize = font.pointSize;
    layer2.string = @"0";
    layer2.contentsScale = [UIScreen mainScreen].scale;
    layer2.alignmentMode = kCAAlignmentRight;
    [layer addSublayer:layer2];
    
    CATextLayer * layer3 = [CATextLayer layer];
    layer3.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, (self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])/[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 34, 14) adjustWidth:YES];
    layer3.position = CGPointMake(layer3.position.x, (self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])*2/3);
    layer3.wrapped = YES;
    layer3.font = fontRef;
    layer3.fontSize = font.pointSize;
    layer3.string = [NSString stringWithFormat:@"%ld",self.totalScore/3];
    if (_yUnit) {
        layer3.string = [layer3.string stringByAppendingString:_yUnit];
    }
    layer3.contentsScale = [UIScreen mainScreen].scale;
    layer3.alignmentMode = kCAAlignmentRight;
    [layer addSublayer:layer3];
    
    CATextLayer * layer4 = [CATextLayer layer];
    layer4.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, (self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])/[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 34, 14) adjustWidth:YES];
    layer4.position = CGPointMake(layer4.position.x, (self.frame.size.height-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])/3);
    layer4.wrapped = YES;
    layer4.font = fontRef;
    layer4.fontSize = font.pointSize;
    layer4.string = [NSString stringWithFormat:@"%ld",self.totalScore/3*2];
    if (_yUnit) {
        layer4.string = [layer4.string stringByAppendingString:_yUnit];
    }
    layer4.contentsScale = [UIScreen mainScreen].scale;
    layer4.alignmentMode = kCAAlignmentRight;
    [layer addSublayer:layer4];
    
    _textGradientLayer.mask = layer;
    CGFontRelease(fontRef);
    // 画坐标系
//    [self setNeedsDisplay];
    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(X_OFFSET, 0, self.frame.size.width-X_OFFSET, self.frame.size.height)];
////    _scrollView.backgroundColor = [UIColor blackColor];
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    [self addSubview:_scrollView];
    
    CAGradientLayer * lineGradientLayer = [CAGradientLayer layer];
    lineGradientLayer.frame = CGRectMake(X_OFFSET, 0, self.frame.size.width-X_OFFSET, self.frame.size.height);
    lineGradientLayer.colors = @[(__bridge id)self.startColor.CGColor, (__bridge id)self.endColor.CGColor];
    lineGradientLayer.startPoint = CGPointMake(0.5, 1-self.startValue);
    lineGradientLayer.endPoint = CGPointMake(0.5, 1-self.endValue);
    [self.layer addSublayer:lineGradientLayer];
    
    CALayer * shapeContainerLayer = [CALayer layer];
    shapeContainerLayer.frame = lineGradientLayer.bounds;
    
    // 确定虚线如何画
    NSMutableArray * dateArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 7; i++) {
        
        NSDate * date = [[NSDate date] dateBySubtractingDays:7-i-1];
        [dateArray addObject:[DHFoundationTool dateDescriptionWithFormat:@"yyyy-MM-dd" date:date]];
    }
    
    // 0 表示没有该天数据
    NSMutableArray * isDashArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString * dateStr in dateArray) {
        
        if ([[_valueAttributes allKeys] containsObject:dateStr]) {
            [isDashArray addObject:[NSNumber numberWithInt:1]];
        } else {
            [isDashArray addObject:[NSNumber numberWithInt:0]];
        }
        
    }
    
    if (![isDashArray containsObject:@1]) {
        // 最近7天没有数据，则显示一条虚线
        
//        CGFloat height = _scrollView.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier];
        CGFloat height = self.frame.size.height;
        CGFloat y = height - height*[[_valueAttributes objectForKey:[[_valueAttributes allKeys] objectAtIndex:0]] floatValue];

        CGPoint lastPoint = CGPointMake(6*40*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]+LINE_OFFSET, y);
        
        CAShapeLayer * lineShapeLayer = [CAShapeLayer layer];
        lineShapeLayer.frame = lineGradientLayer.bounds;
        lineShapeLayer.lineDashPattern = @[@4,@1];
        lineShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        lineShapeLayer.strokeColor = [UIColor redColor].CGColor;
        lineShapeLayer.fillColor = [UIColor clearColor].CGColor;
        lineShapeLayer.lineWidth = LINE_WIDTH;
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(LINE_OFFSET, y)];
        [path addLineToPoint:CGPointMake(6*40*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]+LINE_OFFSET, y)];
        
        lineShapeLayer.path = path.CGPath;
        lineGradientLayer.mask = lineShapeLayer;
        
//        UILabel * dateLabel = [[UILabel alloc] init];
//        dateLabel.textColor = [DHThemeSettings themeTextColor];
//        dateLabel.text = [[_valueAttributes allKeys] objectAtIndex:0];
//        dateLabel.font = [DHThemeSettings themeFontOfSize:13*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
//        [dateLabel sizeToFit];
//        dateLabel.center = CGPointMake(lastPoint.x,self.frame.size.height - dateLabel.frame.size.height/2);
//        [self addSubview:dateLabel];
        
        CAShapeLayer * circleLayer = [CAShapeLayer layer];
        circleLayer.bounds = CGRectMake(0, 0, 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
        circleLayer.backgroundColor = [UIColor clearColor].CGColor;
        circleLayer.fillColor = [UIColor whiteColor].CGColor;
        circleLayer.strokeColor = [DHFoundationTool colorInterpolateWithRate:[[_valueAttributes objectForKey:[[_valueAttributes allKeys] objectAtIndex:0]] floatValue] fromColor:self.startColor toColor:self.endColor].CGColor;
        UIBezierPath * circlePath = [UIBezierPath bezierPathWithOvalInRect:circleLayer.bounds];
        circleLayer.position = lastPoint;

        circleLayer.lineDashPattern = @[@2,@1];
        
        circleLayer.path = circlePath.CGPath;
        [self.layer addSublayer:circleLayer];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(gradientStatisticsView:didTapOnItemAtIndex:inView:)]) {
            
            UIView * tapView = [[UIView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 30, 30) adjustWidth:YES]];
            tapView.center = lastPoint;
            [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnItem:)]];
            tapView.tag = ITEM_TAG;
            [self addSubview:tapView];
            
        }
        
        return NO;
    }
    
    // 先找到第一个1
    
    int preZeroCount = 0;
    
    for (int i = 0; i < isDashArray.count; i++) {
        if ([[isDashArray objectAtIndex:i] integerValue] == 1) {
            break;
        } else {
            preZeroCount++;
        }
    }
    
    
    NSMutableArray * dashPointArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < preZeroCount; i++) {
        [dashPointArray addObject:@0];
    }
    CGFloat currentY = 0;
    for (int i = preZeroCount; i < isDashArray.count; i++) {
        
        if ([[isDashArray objectAtIndex:i] integerValue] == 1) {
            currentY = [[_valueAttributes objectForKey:[dateArray objectAtIndex:i]] floatValue];
            [dashPointArray addObject:[NSNumber numberWithFloat:currentY]];
        } else {
            [dashPointArray addObject:[NSNumber numberWithFloat:currentY]];
        }
    }
    
    for (int i = 0; i < preZeroCount; i++) {
        [dashPointArray replaceObjectAtIndex:i withObject:[dashPointArray objectAtIndex:preZeroCount]];
    }
    
    
    CGFloat height = self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier];
    CGFloat y = height;
    if ([[isDashArray objectAtIndex:0] integerValue] != 0) {
        y = height - height*[[dashPointArray objectAtIndex:0] floatValue];
    }
    CGPoint lastPoint = CGPointMake(LINE_OFFSET, y);
//    UILabel * dateLabel = [[UILabel alloc] init];
//    dateLabel.textColor = [DHThemeSettings themeTextColor];
//    dateLabel.text = [dateArray objectAtIndex:0];
//    dateLabel.font = [DHThemeSettings themeFontOfSize:13*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
//    [dateLabel sizeToFit];
//    dateLabel.center = CGPointMake(dateLabel.frame.size.width/2,self.frame.size.height - dateLabel.frame.size.height/2);
//    [_scrollView addSubview:dateLabel];
    
    CAShapeLayer * circleLayer = [CAShapeLayer layer];
    circleLayer.bounds = CGRectMake(0, 0, 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    circleLayer.fillColor = [UIColor whiteColor].CGColor;
    circleLayer.strokeColor = [DHFoundationTool colorInterpolateWithRate:[[dashPointArray objectAtIndex:0] floatValue] fromColor:self.startColor toColor:self.endColor].CGColor;
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithOvalInRect:circleLayer.bounds];
    circleLayer.position = lastPoint;
    if ([[isDashArray objectAtIndex:0] integerValue] != 0) {
        y = height - height*[[dashPointArray objectAtIndex:0] floatValue];
        
    } else {
        circleLayer.lineDashPattern = @[@2,@1];
        circleLayer.strokeColor = [DHFoundationTool colorInterpolateWithRate:0 fromColor:self.startColor toColor:self.endColor].CGColor;
    }
    
    circleLayer.path = circlePath.CGPath;
    
    
    [self.layer addSublayer:circleLayer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gradientStatisticsView:didTapOnItemAtIndex:inView:)]) {
        
        UIView * tapView = [[UIView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 30, 30) adjustWidth:YES]];
        tapView.center = lastPoint;
        tapView.tag = ITEM_TAG;
        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnItem:)]];
        [self addSubview:tapView];
        
    }
    
    for (int i = 1; i < dashPointArray.count; i++) {
        // x坐标：日期
//        dateLabel = [[UILabel alloc] init];
//        dateLabel.textColor = [DHThemeSettings themeTextColor];
//        dateLabel.text = [dateArray objectAtIndex:i];
//        dateLabel.font = [DHThemeSettings themeFontOfSize:13*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
//        [dateLabel sizeToFit];
//        dateLabel.center = CGPointMake(i*(dateLabel.frame.size.width+LINE_OFFSET)+LINE_OFFSET,self.frame.size.height - dateLabel.frame.size.height/2);
//        [_scrollView addSubview:dateLabel];
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        
        [path moveToPoint:lastPoint];
        CAShapeLayer * lineShapeLayer = [CAShapeLayer layer];
        lineShapeLayer.frame = lineGradientLayer.bounds;
        lineShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        lineShapeLayer.strokeColor = [UIColor redColor].CGColor;
        lineShapeLayer.fillColor = [UIColor clearColor].CGColor;
        lineShapeLayer.lineWidth = LINE_WIDTH;
        lineGradientLayer.mask = lineShapeLayer;
//        if ([[isDashArray objectAtIndex:i] integerValue] == 0) {
//           // 画虚线
//            lineShapeLayer.lineDashPattern = @[@3,@1.5];
//
//        }
        CGFloat height = self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier];
        CGFloat y = height;
        CAShapeLayer * circleLayer = [CAShapeLayer layer];
        circleLayer.bounds = CGRectMake(0, 0, 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
        circleLayer.backgroundColor = [UIColor clearColor].CGColor;
        circleLayer.fillColor = [UIColor whiteColor].CGColor;
        circleLayer.strokeColor = [DHFoundationTool colorInterpolateWithRate:[[dashPointArray objectAtIndex:i] floatValue] fromColor:self.startColor toColor:self.endColor].CGColor;
        UIBezierPath * circlePath = [UIBezierPath bezierPathWithOvalInRect:circleLayer.bounds];
        
        if ([[isDashArray objectAtIndex:i] integerValue] != 0) {
            y = height - height*[[dashPointArray objectAtIndex:i] floatValue];
            
        } else {
            circleLayer.lineDashPattern = @[@2,@1];
            circleLayer.strokeColor = [DHFoundationTool colorInterpolateWithRate:0 fromColor:self.startColor toColor:self.endColor].CGColor;
        }
        
        circleLayer.path = circlePath.CGPath;
        
        
        [self.layer addSublayer:circleLayer];
        [path addLineToPoint:CGPointMake(i*40*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]+LINE_OFFSET, y)];
        lastPoint = CGPointMake(i*40*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]+LINE_OFFSET, y);
        circleLayer.position = lastPoint;
        if (self.delegate && [self.delegate respondsToSelector:@selector(gradientStatisticsView:didTapOnItemAtIndex:inView:)]) {
            
            UIView * tapView = [[UIView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 30, 30) adjustWidth:YES]];
            tapView.center = lastPoint;
            [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnItem:)]];
            tapView.tag = ITEM_TAG+i;
            [self addSubview:tapView];
            
        }
        lineShapeLayer.path = path.CGPath;
        
        [shapeContainerLayer addSublayer:lineShapeLayer];
    }
//    NSLog(@"%@",NSStringFromCGSize(_scrollView.contentSize));
    lineGradientLayer.mask = shapeContainerLayer;
//    [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width-_scrollView.frame.size.width, 0)];
    return YES;
}

- (void)tapOnItem:(UIGestureRecognizer *)sender
{
    [self.delegate gradientStatisticsView:self didTapOnItemAtIndex:sender.view.tag-ITEM_TAG inView:sender.view];
}


#pragma mark - 滚动统计
- (BOOL)drawUsingScroll
{
    self.textGradientLayer = [CAGradientLayer layer];
    _textGradientLayer.frame = self.bounds;
    _textGradientLayer.colors = @[(__bridge id)self.startColor.CGColor, (__bridge id)self.endColor.CGColor];
    _textGradientLayer.startPoint = CGPointMake(0.5, 1-self.startValue);
    _textGradientLayer.endPoint = CGPointMake(0.5, 1-self.endValue);
    [self.layer addSublayer:_textGradientLayer];
    
    CALayer * layer = [CALayer layer];
    layer.frame = self.bounds;
    layer.masksToBounds = NO;
    
    
    UIFont * font = [UIFont boldSystemFontOfSize:14*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    
    CATextLayer * layer1 = [CATextLayer layer];
    layer1.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 30, 14) adjustWidth:YES];
    layer1.wrapped = YES;
    layer1.font = fontRef;
    layer1.fontSize = font.pointSize;
    layer1.string = [NSString stringWithFormat:@"%ld",self.totalScore];
    layer1.contentsScale = [UIScreen mainScreen].scale;
    layer1.alignmentMode = kCAAlignmentRight;
    [layer addSublayer:layer1];
    
    CATextLayer * layer2 = [CATextLayer layer];
    layer2.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, (self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])/[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 30, 14) adjustWidth:YES];
    layer2.position = CGPointMake(layer2.position.x, self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
    layer2.wrapped = YES;
    layer2.font = fontRef;
    layer2.fontSize = font.pointSize;
    layer2.string = @"0";
    layer2.contentsScale = [UIScreen mainScreen].scale;
    layer2.alignmentMode = kCAAlignmentRight;
    [layer addSublayer:layer2];
    
    _textGradientLayer.mask = layer;
    CGFontRelease(fontRef);
    // 画坐标系
    //    [self setNeedsDisplay];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(X_OFFSET, 0, self.frame.size.width-X_OFFSET, self.frame.size.height)];
    //    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    
    CAGradientLayer * lineGradientLayer = [CAGradientLayer layer];
    lineGradientLayer.frame = _scrollView.bounds;
    lineGradientLayer.colors = @[(__bridge id)self.startColor.CGColor, (__bridge id)self.endColor.CGColor];
    lineGradientLayer.startPoint = CGPointMake(0.5, 1-self.startValue);
    lineGradientLayer.endPoint = CGPointMake(0.5, 1-self.endValue);
    [_scrollView.layer addSublayer:lineGradientLayer];
    
    CALayer * shapeContainerLayer = [CALayer layer];
    shapeContainerLayer.frame = lineGradientLayer.bounds;
    
    // 确定虚线如何画
    NSMutableArray * dateArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 7; i++) {
        
        NSDate * date = [[NSDate date] dateBySubtractingDays:7-i-1];
        [dateArray addObject:[DHFoundationTool dateDescriptionWithFormat:@"yyyy-MM-dd" date:date]];
    }
    
    // 0 表示没有该天数据
    NSMutableArray * isDashArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString * dateStr in dateArray) {
        
        if ([[_valueAttributes allKeys] containsObject:dateStr]) {
            [isDashArray addObject:[NSNumber numberWithInt:1]];
        } else {
            [isDashArray addObject:[NSNumber numberWithInt:0]];
        }
        
    }
    
    if (![isDashArray containsObject:@1]) {
        // 最近7天没有数据，则显示一条虚线
        
        CGFloat height = _scrollView.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier];
        CGFloat y = height - height*[[_valueAttributes objectForKey:[[_valueAttributes allKeys] objectAtIndex:0]] floatValue];
        
        CGPoint lastPoint = CGPointMake(self.frame.size.width/2, y);
        
        CAShapeLayer * lineShapeLayer = [CAShapeLayer layer];
        lineShapeLayer.frame = lineGradientLayer.bounds;
        lineShapeLayer.lineDashPattern = @[@4,@1];
        lineShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        lineShapeLayer.strokeColor = [UIColor redColor].CGColor;
        lineShapeLayer.fillColor = [UIColor clearColor].CGColor;
        lineShapeLayer.lineWidth = LINE_WIDTH;
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, y)];
        [path addLineToPoint:CGPointMake(lineGradientLayer.frame.size.width, y)];
        
        lineShapeLayer.path = path.CGPath;
        lineGradientLayer.mask = lineShapeLayer;
        
        UILabel * dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = [DHThemeSettings themeTextColor];
        dateLabel.text = [[_valueAttributes allKeys] objectAtIndex:0];
        dateLabel.font = [DHThemeSettings themeFontOfSize:13*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
        [dateLabel sizeToFit];
        dateLabel.center = CGPointMake(lastPoint.x,self.frame.size.height - dateLabel.frame.size.height/2);
        [_scrollView addSubview:dateLabel];
        
        CAShapeLayer * circleLayer = [CAShapeLayer layer];
        circleLayer.bounds = CGRectMake(0, 0, 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
        circleLayer.backgroundColor = [UIColor clearColor].CGColor;
        circleLayer.fillColor = [UIColor whiteColor].CGColor;
        circleLayer.strokeColor = [DHFoundationTool colorInterpolateWithRate:[[_valueAttributes objectForKey:[[_valueAttributes allKeys] objectAtIndex:0]] floatValue] fromColor:self.startColor toColor:self.endColor].CGColor;
        UIBezierPath * circlePath = [UIBezierPath bezierPathWithOvalInRect:circleLayer.bounds];
        circleLayer.position = lastPoint;
        
        circleLayer.lineDashPattern = @[@2,@1];
        
        circleLayer.path = circlePath.CGPath;
        [_scrollView.layer addSublayer:circleLayer];
        
        
        
        return NO;
    }
    
    // 先找到第一个1
    
    int preZeroCount = 0;
    
    for (int i = 0; i < isDashArray.count; i++) {
        if ([[isDashArray objectAtIndex:i] integerValue] == 1) {
            break;
        } else {
            preZeroCount++;
        }
    }
    
    
    NSMutableArray * dashPointArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < preZeroCount; i++) {
        [dashPointArray addObject:@0];
    }
    CGFloat currentY = 0;
    for (int i = preZeroCount; i < isDashArray.count; i++) {
        
        if ([[isDashArray objectAtIndex:i] integerValue] == 1) {
            currentY = [[_valueAttributes objectForKey:[dateArray objectAtIndex:i]] floatValue];
            [dashPointArray addObject:[NSNumber numberWithFloat:currentY]];
        } else {
            [dashPointArray addObject:[NSNumber numberWithFloat:currentY]];
        }
    }
    
    for (int i = 0; i < preZeroCount; i++) {
        [dashPointArray replaceObjectAtIndex:i withObject:[dashPointArray objectAtIndex:preZeroCount]];
    }
    
    
    CGFloat height = _scrollView.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier];
    CGFloat y = height;
    if ([[isDashArray objectAtIndex:0] integerValue] != 0) {
        y = height - height*[[dashPointArray objectAtIndex:0] floatValue];
    }
    CGPoint lastPoint = CGPointMake(LINE_OFFSET, y);
    UILabel * dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = [DHThemeSettings themeTextColor];
    dateLabel.text = [dateArray objectAtIndex:0];
    dateLabel.font = [DHThemeSettings themeFontOfSize:13*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
    [dateLabel sizeToFit];
    dateLabel.center = CGPointMake(dateLabel.frame.size.width/2,self.frame.size.height - dateLabel.frame.size.height/2);
    [_scrollView addSubview:dateLabel];
    
    CAShapeLayer * circleLayer = [CAShapeLayer layer];
    circleLayer.bounds = CGRectMake(0, 0, 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    circleLayer.fillColor = [UIColor whiteColor].CGColor;
    circleLayer.strokeColor = [DHFoundationTool colorInterpolateWithRate:[[dashPointArray objectAtIndex:0] floatValue] fromColor:self.startColor toColor:self.endColor].CGColor;
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithOvalInRect:circleLayer.bounds];
    circleLayer.position = lastPoint;
    if ([[isDashArray objectAtIndex:0] integerValue] != 0) {
        y = height - height*[[dashPointArray objectAtIndex:0] floatValue];
        
    } else {
        circleLayer.lineDashPattern = @[@2,@1];
        circleLayer.strokeColor = [DHFoundationTool colorInterpolateWithRate:0 fromColor:self.startColor toColor:self.endColor].CGColor;
    }
    
    circleLayer.path = circlePath.CGPath;
    
    
    [_scrollView.layer addSublayer:circleLayer];
    
    for (int i = 1; i < dashPointArray.count; i++) {
        // x坐标：日期
        dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = [DHThemeSettings themeTextColor];
        dateLabel.text = [dateArray objectAtIndex:i];
        dateLabel.font = [DHThemeSettings themeFontOfSize:13*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
        [dateLabel sizeToFit];
        dateLabel.center = CGPointMake(i*(dateLabel.frame.size.width+LINE_OFFSET)+LINE_OFFSET,self.frame.size.height - dateLabel.frame.size.height/2);
        [_scrollView addSubview:dateLabel];
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        
        [path moveToPoint:lastPoint];
        CAShapeLayer * lineShapeLayer = [CAShapeLayer layer];
        lineShapeLayer.frame = lineGradientLayer.bounds;
        lineShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        lineShapeLayer.strokeColor = [UIColor redColor].CGColor;
        lineShapeLayer.fillColor = [UIColor clearColor].CGColor;
        lineShapeLayer.lineWidth = LINE_WIDTH;
        lineGradientLayer.mask = lineShapeLayer;
        //        if ([[isDashArray objectAtIndex:i] integerValue] == 0) {
        //           // 画虚线
        //            lineShapeLayer.lineDashPattern = @[@3,@1.5];
        //
        //        }
        CGFloat height = self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier];
        CGFloat y = height;
        CAShapeLayer * circleLayer = [CAShapeLayer layer];
        circleLayer.bounds = CGRectMake(0, 0, 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
        circleLayer.backgroundColor = [UIColor clearColor].CGColor;
        circleLayer.fillColor = [UIColor whiteColor].CGColor;
        circleLayer.strokeColor = [DHFoundationTool colorInterpolateWithRate:[[dashPointArray objectAtIndex:i] floatValue] fromColor:self.startColor toColor:self.endColor].CGColor;
        UIBezierPath * circlePath = [UIBezierPath bezierPathWithOvalInRect:circleLayer.bounds];
        
        if ([[isDashArray objectAtIndex:i] integerValue] != 0) {
            y = height - height*[[dashPointArray objectAtIndex:i] floatValue];
            
        } else {
            circleLayer.lineDashPattern = @[@2,@1];
            circleLayer.strokeColor = [DHFoundationTool colorInterpolateWithRate:0 fromColor:self.startColor toColor:self.endColor].CGColor;
        }
        
        circleLayer.path = circlePath.CGPath;
        
        
        [_scrollView.layer addSublayer:circleLayer];
        
        [path addLineToPoint:CGPointMake(i * (dateLabel.frame.size.width+LINE_OFFSET)+LINE_OFFSET, y)];
        [path addLineToPoint:CGPointMake(i*self.frame.size.width/dashPointArray.count, y)];
        lastPoint = CGPointMake(i*self.frame.size.width/dashPointArray.count, y);
        circleLayer.position = lastPoint;
        lineShapeLayer.path = path.CGPath;
        
        [shapeContainerLayer addSublayer:lineShapeLayer];
        // [2]
        _scrollView.contentSize = CGSizeMake(i*(dateLabel.frame.size.width+LINE_OFFSET)+dateLabel.frame.size.width, _scrollView.frame.size.height);
        // [3]
        lineGradientLayer.frame = CGRectMake(lineGradientLayer.frame.origin.x, lineGradientLayer.frame.origin.y, i*(dateLabel.frame.size.width+LINE_OFFSET)+LINE_OFFSET, lineGradientLayer.frame.size.height);
        lineShapeLayer.frame = lineGradientLayer.frame;
    }
    NSLog(@"%@",NSStringFromCGSize(_scrollView.contentSize));
    lineGradientLayer.mask = shapeContainerLayer;
    //    [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width-_scrollView.frame.size.width, 0)];
    return YES;
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    CGContextSetLineWidth(context, 1);
//    CGContextSetStrokeColorWithColor(context, [LINE_COLOR CGColor]);
//    
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, X_OFFSET, self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
//    
//    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
//    
//    CGContextMoveToPoint(context, X_OFFSET, self.frame.size.height-TEXT_HEIGHT-5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
//    
//    CGContextAddLineToPoint(context, X_OFFSET, 0);
//    
//    CGContextStrokePath(context);
//    CGContextBeginPath(context);
//    for (int i = 0; i < 6; i++) {
//        
//        CGContextSetLineWidth(context, 0.5);
//        CGContextMoveToPoint(context, X_OFFSET, (i+1) * self.frame.size.height/7);
//        CGFloat lengths[2] = {3.5,1};
//        CGContextSetLineDash(context, 0, lengths, 2);
//        CGContextAddLineToPoint(context, self.frame.size.width, (i+1) * self.frame.size.height/7);
//    }
//    CGContextStrokePath(context);
//    CGContextBeginPath(context);
////    for (int i = 0; i < 6; i++) {
////        
////        CGContextSetLineWidth(context, 0.5);
////        CGContextMoveToPoint(context, X_OFFSET+(i+1) * (self.frame.size.width-X_OFFSET)/6, 0);
////        CGFloat lengths[2] = {1.5,1};
////        CGContextSetLineDash(context, 0, lengths, 2);
////        CGContextAddLineToPoint(context, X_OFFSET+(i+1) * (self.frame.size.width-X_OFFSET)/6, self.frame.size.height);
////    }
////    
////    CGContextStrokePath(context);
//}

@end
