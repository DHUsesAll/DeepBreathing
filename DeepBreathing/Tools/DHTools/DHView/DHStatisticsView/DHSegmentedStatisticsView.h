//
//  DHSegmentedStatisticsView.h
//  HealthManagement
//
//  Created by DreamHack on 14-11-3.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHSegmentedStatisticsView;

@protocol DHSegmentedStatisticsViewDataSource <NSObject>

- (NSInteger)numberOfSectionsInSegmentedStatisticsView:(DHSegmentedStatisticsView *)segmentedStatisticsView;

- (NSInteger)segmentedStatisticsView:(DHSegmentedStatisticsView *)segmentedStatisticsView numberOfItemsInSection:(NSInteger)section;

- (NSArray *)xAxisParametersInSegmentedStatisticsView:(DHSegmentedStatisticsView *)segmentedStatisticsView;
- (NSArray *)yAxisParametersInSegmentedStatisticsView:(DHSegmentedStatisticsView *)segmentedStaitsticsView;

- (CGPoint)segmentedStatisticsView:(DHSegmentedStatisticsView *)segmentedStatisticsView itemPositionAtIndex:(NSInteger)index inSection:(NSInteger)section;

- (UIColor *)segmentedStatisticsView:(DHSegmentedStatisticsView *)segmentedStatisticsView themeColorInSection:(NSInteger)section;

- (NSString *)segmentedStatisticsView:(DHSegmentedStatisticsView *)segmentedStatisticsView sectionDescriptionInSection:(NSInteger)section;

@end

@interface DHSegmentedStatisticsView : UIView

@property (nonatomic, assign) id <DHSegmentedStatisticsViewDataSource> dataSource;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id <DHSegmentedStatisticsViewDataSource>)dataSource;

- (UIView *)sectionDescriptionViewInSection:(NSInteger)section;

@end
