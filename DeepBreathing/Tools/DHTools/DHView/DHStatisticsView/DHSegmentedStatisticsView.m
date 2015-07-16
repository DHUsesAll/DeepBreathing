//
//  DHSegmentedStatisticsView.m
//  HealthManagement
//
//  Created by DreamHack on 14-11-3.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHSegmentedStatisticsView.h"
#import "DHThemeSettings.h"
#import "DHConvenienceAutoLayout.h"
#import "DHFoundationTool.h"
@implementation DHSegmentedStatisticsView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id<DHSegmentedStatisticsViewDataSource>)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}

- (void)dealloc
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}


- (void)setDataSource:(id<DHSegmentedStatisticsViewDataSource>)dataSource
{
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    if (!(_dataSource && [_dataSource respondsToSelector:@selector(numberOfSectionsInSegmentedStatisticsView:)] && [_dataSource respondsToSelector:@selector(segmentedStatisticsView:itemPositionAtIndex:inSection:)] && [_dataSource respondsToSelector:@selector(segmentedStatisticsView:numberOfItemsInSection:)] && [_dataSource respondsToSelector:@selector(xAxisParametersInSegmentedStatisticsView:)] && [_dataSource respondsToSelector:@selector(yAxisParametersInSegmentedStatisticsView:)] && [_dataSource respondsToSelector:@selector(segmentedStatisticsView:themeColorInSection:)])) {
        return;
    }
    
    
    [self draw];
    
}

- (void)draw
{
    // y轴坐标
    
    NSInteger yNumber = [self.dataSource yAxisParametersInSegmentedStatisticsView:self].count;
    CGFloat xOffset = 0;
    for (int i = 0; i < yNumber; i++) {
        
        UILabel * paramLabel = [[UILabel alloc] init];
        paramLabel.text = [[self.dataSource yAxisParametersInSegmentedStatisticsView:self] objectAtIndex:i];
        paramLabel.textColor = [DHThemeSettings themeTextColor];
        paramLabel.font = [DHThemeSettings themeFontOfSize:12*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]];
        [paramLabel sizeToFit];
        paramLabel.center = CGPointMake(paramLabel.frame.size.width/2, self.frame.size.height/(yNumber+1)*(yNumber-i));
        [self addSubview:paramLabel];
        xOffset = paramLabel.frame.size.width+5;
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.strokeColor = [DHFoundationTool colorWith255Red:159 green:159 blue:159 alpha:1].CGColor;
        [self.layer addSublayer:layer];
        UIBezierPath * path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(paramLabel.frame.size.width+5, paramLabel.center.y)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, paramLabel.center.y)];
        layer.path = path.CGPath;
    }
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.strokeColor = [DHFoundationTool colorWith255Red:159 green:159 blue:159 alpha:1].CGColor;
    [self.layer addSublayer:layer];
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(xOffset, self.frame.size.height-12*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]-5)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-12*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]-5)];
    layer.path = path.CGPath;
    
    // 画坐标系
    NSInteger xNumber = [self.dataSource xAxisParametersInSegmentedStatisticsView:self].count;
    for (int i = 0; i < xNumber; i++) {
        
        
        UILabel * paramLabel = [[UILabel alloc] init];
        paramLabel.text = [[self.dataSource xAxisParametersInSegmentedStatisticsView:self] objectAtIndex:i];
        paramLabel.textColor = [DHThemeSettings themeTextColor];
        paramLabel.font = [DHThemeSettings themeFontOfSize:12*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]];
        [paramLabel sizeToFit];
        paramLabel.center = CGPointMake(xOffset + (self.frame.size.width-xOffset)/(xNumber-1)*i, self.frame.size.height-paramLabel.frame.size.height/2);
        [self addSubview:paramLabel];
        
        
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.lineWidth = 1;
        layer.strokeColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:layer];
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(xOffset + (self.frame.size.width-xOffset)/(xNumber-1)*i, self.frame.size.height-12*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]-3)];
        [path addLineToPoint:CGPointMake(xOffset + (self.frame.size.width-xOffset)/(xNumber-1)*i, 0)];
        layer.path = path.CGPath;
    }
    CGFloat width = self.frame.size.width - xOffset;
    CGFloat height = self.frame.size.height-12*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]-3;
    // 画点
    NSInteger sectionNumber = [self.dataSource numberOfSectionsInSegmentedStatisticsView:self];

    for (int i = 0; i < sectionNumber; i++) {
        
        NSInteger itemNumber = [self.dataSource segmentedStatisticsView:self numberOfItemsInSection:i];
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.strokeColor = [self.dataSource segmentedStatisticsView:self themeColorInSection:i].CGColor;
        layer.lineWidth = 2;
        layer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:layer];
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        
        for (int j = 0; j < itemNumber; j++) {
            
            CGPoint point = [self.dataSource segmentedStatisticsView:self itemPositionAtIndex:j inSection:i];
            CGPoint accPoint = CGPointMake(xOffset+point.x * width, point.y * height);
            if (j == 0) {
                
                [path moveToPoint:accPoint];
            } else {
                [path addLineToPoint:accPoint];
            }
            
            UIView * pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            pointView.center = accPoint;
            pointView.backgroundColor = [UIColor whiteColor];
            pointView.layer.cornerRadius = 5;
            pointView.layer.borderColor = [self.dataSource segmentedStatisticsView:self themeColorInSection:i].CGColor;
            pointView.layer.borderWidth = 2;
            
            [self addSubview:pointView];
        }
        
        layer.path = path.CGPath;
        
    }
    
}

- (UIView *)sectionDescriptionViewInSection:(NSInteger)section
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentedStatisticsView:sectionDescriptionInSection:)]) {
        
        NSString * description = [self.dataSource segmentedStatisticsView:self sectionDescriptionInSection:section];
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        UIView * pointView = [[UIView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 10, 10) adjustWidth:YES]];
        pointView.backgroundColor = [UIColor whiteColor];
        pointView.layer.cornerRadius = pointView.frame.size.height/2;
        pointView.layer.borderWidth = 2;
        pointView.layer.borderColor = [self.dataSource segmentedStatisticsView:self themeColorInSection:section].CGColor;
        [view addSubview:pointView];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(pointView.frame.size.width+2, 0, 0, 0)];
        label.font = [DHThemeSettings themeFontOfSize:10*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
        label.textColor = [DHThemeSettings themeTextColor];
        label.text = description;
        [label sizeToFit];
        [view addSubview:label];
        
        view.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, pointView.frame.size.width+label.frame.size.width, 10) adjustWidth:YES];
        
        return view;
    }
    return nil;
}


@end
