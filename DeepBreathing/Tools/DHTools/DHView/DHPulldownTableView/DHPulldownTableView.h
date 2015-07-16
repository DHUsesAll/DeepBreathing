//
//  DHPulldownTableView.h
//  HH
//
//  Created by DreamHack on 15-4-14.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DHPulldownTableView;

@protocol DHPulldownTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfSectionsInPulldownTableView:(DHPulldownTableView *)pulldownTableView;
- (NSInteger)pulldownTableView:(DHPulldownTableView *)pulldownTableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)pulldownTableView:(DHPulldownTableView *)pulldownTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DHPulldownTableViewDelegate <NSObject>

@optional
- (void)pulldownTableView:(DHPulldownTableView *)pulldownTableView didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)pulldownTableView:(DHPulldownTableView *)pulldownTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)pulldownTableView:(DHPulldownTableView *)pulldownTableView heightForHeaderInSection:(NSInteger)section;
@required
- (UIView *)pulldownTableView:(DHPulldownTableView *)pulldownTableView viewForHeaderInSection:(NSInteger)section;

// 将要下拉时，需要重新设置数据源的数据
- (void)pulldownTableView:(DHPulldownTableView *)pulldownTableView willPullDownSection:(NSInteger)section;

// 将要收起时，需要重新设置数据源的数据
- (void)pulldownTableView:(DHPulldownTableView *)pulldownTableView willPutAwaySection:(NSInteger)section;

@end


@interface DHPulldownTableView : UIView

@property (nonatomic, weak) id <DHPulldownTableViewDataSource>  dataSource;
@property (nonatomic, weak) id <DHPulldownTableViewDelegate>    delegate;

@property (nonatomic, strong, readonly) UITableView * tableView;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id <DHPulldownTableViewDataSource>)dataSource delegate:(id <DHPulldownTableViewDelegate>)delegate;

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
- (void)reloadData;

@end
