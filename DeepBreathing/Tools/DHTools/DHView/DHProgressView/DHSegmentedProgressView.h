//
//  DHSegmentedProgressView.h
//  HealthManagement
//
//  Created by DreamHack on 14-11-3.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    DHSegmentedProgressViewProgressLabelOptionNone,
    DHSegmentedProgressViewProgressLabelOptionInner,
    DHSegmentedProgressViewProgressLabelOptionOutter
    
    
} DHSegmentedProgressViewProgressLabelOption;

@class DHSegmentedProgressView;

@protocol DHSegmentedProgressViewDataSource <NSObject>

- (NSInteger)numberOfItemsInSegmentedProgressView:(DHSegmentedProgressView *)segmentedProgressView;
- (UIColor *)segmentedProgressView:(DHSegmentedProgressView *)segmentedProgressView colorForItemAtIndex:(NSInteger)index;
- (UIImage *)segmentedProgressView:(DHSegmentedProgressView *)segmentedProgressView headerImageForItemAtIndex:(NSInteger)index;
- (NSArray *)ratesForItemsInSegmentedProgressView:(DHSegmentedProgressView *)segmentedProgressView;
- (NSString *)segmentedProgressView:(DHSegmentedProgressView *)segmentedProgressView progressLabelTextForItemAtIndex:(NSInteger)index;

@end


@interface DHSegmentedProgressView : UIView

@property (nonatomic, assign) id <DHSegmentedProgressViewDataSource> dataSource;

- (instancetype)initWithRadius:(CGFloat)radius center:(CGPoint)center lineWidth:(CGFloat)lineWidth dataSource:(id <DHSegmentedProgressViewDataSource>)dataSource progressLabelOption:(DHSegmentedProgressViewProgressLabelOption)option;

- (void)reloadData;

- (void)draw;

- (void)setInfoLabelHidden:(BOOL)hidden;

@end
