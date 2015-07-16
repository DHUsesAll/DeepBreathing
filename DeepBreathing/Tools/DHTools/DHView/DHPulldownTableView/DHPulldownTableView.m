//
//  DHPulldownTableView.m
//  HH
//
//  Created by DreamHack on 15-4-14.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHPulldownTableView.h"

#define HEADER_TAG  1234

#define COMFORM_DATASOURCE(sel)    (self.dataSource && [self.dataSource respondsToSelector:sel])
#define COMFORM_DELEGATE(sel)      (self.delegate && [self.delegate respondsToSelector:sel])

@interface DHPulldownTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataList;

@end

@implementation DHPulldownTableView

#pragma mark - initializes

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id<DHPulldownTableViewDataSource>)dataSource delegate:(id<DHPulldownTableViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = dataSource;
        self.delegate = delegate;
        [self initialzeAppearence];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialzeAppearence];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialzeAppearence];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialzeAppearence];
    }
    return self;
}

- (void)initialzeAppearence
{
    [self addSubview:self.tableView];
    
}

#pragma mark - interface

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (void)reloadData
{
//    [self.tableView reloadData];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
        
            UITableView * tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.tableFooterView = [[UIView alloc] init];
            tableView.backgroundColor = [UIColor clearColor];
            tableView;
        });
    }
    
    return _tableView;
}


- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = ({
        
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            if (COMFORM_DATASOURCE(@selector(numberOfSectionsInPulldownTableView:))) {
                for (int i = 0; i < [self.dataSource numberOfSectionsInPulldownTableView:self]; i++) {
                    
                    // no 表示没有展开
                    [array addObject:[NSNumber numberWithBool:NO]];
                    
                }
            }
            array;
        
        });
    }
    
    return _dataList;
}

#pragma mark - callbacks

- (void)onHeader:(UITapGestureRecognizer *)sender
{
    NSInteger section = sender.view.tag - HEADER_TAG;
    NSNumber * value = [self.dataList objectAtIndex:section];
    if (![value boolValue]) {
        
        // 下拉展开
        if (COMFORM_DELEGATE(@selector(pulldownTableView:willPullDownSection:))) {
            
            [self.delegate pulldownTableView:self willPullDownSection:section];
            if (COMFORM_DATASOURCE(@selector(pulldownTableView:numberOfRowsInSection:))) {
                NSInteger rows = [self.dataSource pulldownTableView:self numberOfRowsInSection:section];
                NSMutableArray * indexPaths = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < rows; i++) {
                    
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
                    [indexPaths addObject:indexPath];
                    
                }
                
                [_dataList replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:YES]];
                [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
                
            }
        }
        
    } else {
        // 收起
        if (COMFORM_DELEGATE(@selector(pulldownTableView:willPutAwaySection:))) {
            
            
            if (COMFORM_DATASOURCE(@selector(pulldownTableView:numberOfRowsInSection:))) {
                NSInteger rows = [self.dataSource pulldownTableView:self numberOfRowsInSection:section];
                [self.delegate pulldownTableView:self willPutAwaySection:section];
                NSMutableArray * indexPaths = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < rows; i++) {
                    
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
                    [indexPaths addObject:indexPath];
                    
                }

                [_dataList replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:NO]];
                [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
            }
        }
    }
}

#pragma mark - tableview dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (COMFORM_DATASOURCE(@selector(pulldownTableView:numberOfRowsInSection:))) {
        
        return [self.dataSource pulldownTableView:self numberOfRowsInSection:section];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (COMFORM_DATASOURCE(@selector(pulldownTableView:cellForRowAtIndexPath:))) {
        return [self.dataSource pulldownTableView:self cellForRowAtIndexPath:indexPath];
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (COMFORM_DATASOURCE(@selector(numberOfSectionsInPulldownTableView:))) {
        return [self.dataSource numberOfSectionsInPulldownTableView:self];
    }
    
    return 0;
}

#pragma mark - tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (COMFORM_DELEGATE(@selector(pulldownTableView:viewForHeaderInSection:))) {
        UIView * subView = [self.delegate pulldownTableView:self viewForHeaderInSection:section];
        UIView * containerView = ({
        
            UIView * view = [[UIView alloc] initWithFrame:subView.bounds];
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeader:)]];
            view.tag = HEADER_TAG+section;
            [view addSubview:subView];
            view;
        
        });
        return containerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (COMFORM_DELEGATE(@selector(pulldownTableView:didSelectCellAtIndexPath:))) {
        [self.delegate pulldownTableView:self didSelectCellAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (COMFORM_DELEGATE(@selector(pulldownTableView:heightForRowAtIndexPath:))) {
        return [self.delegate pulldownTableView:self heightForRowAtIndexPath:indexPath];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (COMFORM_DELEGATE(@selector(pulldownTableView:heightForHeaderInSection:))) {
        return [self.delegate pulldownTableView:self heightForHeaderInSection:section];
    }
    
    return 0;
}

@end
