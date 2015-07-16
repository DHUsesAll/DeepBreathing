//
//  DHScanScrollView.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-23.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHScanScrollView;

#pragma mark - datasource

@protocol DHScanScrollViewDataSource <NSObject>

- (NSInteger)numberOfItemsInScanScrollView:(DHScanScrollView *)scanScrollView;
- (UIImage *)itemImageForRowAtIndex:(NSInteger)index inScanScrollView:(DHScanScrollView *)scanScrollView;
- (UIColor *)itemBackgroundColorForRowAtIndex:(NSInteger)index inScanScrollView:(DHScanScrollView *)scanScrollView;

@end

#pragma mark - delegate
@protocol DHScanScrollViewDelegate <NSObject>

- (void)drawItemView:(UIView *)view forRowAtIndex:(NSInteger)index inScanScrollView:(DHScanScrollView *)scanScrollView;
- (void)scanScrollView:(DHScanScrollView *)scanScrollView didChangeToIndex:(NSInteger)index;

@end


@interface DHScanScrollView : UIView


@property (nonatomic, assign) id <DHScanScrollViewDataSource> dataSource;
@property (nonatomic, assign) id <DHScanScrollViewDelegate>   delegate;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id <DHScanScrollViewDelegate>)dataSource delegate:(id <DHScanScrollViewDelegate>)delegate startIndex:(NSInteger)index isHorizontal:(BOOL)flag;

- (UIScrollView *)scrollView;

- (void)reloadDataWithStartIndex:(NSInteger)index;

- (void)setCurrentIndex:(NSInteger)index animate:(BOOL)flag;

- (UIView *)leftButton;
- (UIView *)rightButton;

@end
