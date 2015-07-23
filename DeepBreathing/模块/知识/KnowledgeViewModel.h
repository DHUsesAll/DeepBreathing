//
//  KnowledgeViewModel.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-23.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnowledgeViewModel : NSObject


- (void)prepareWithData:(id)knowledgeData;

// viewmodel通过接口提供给controller调用

- (BOOL)isRequestSuccess;

// 返回tableView dataSource的方法
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSDictionary *)cellInfoAtIndexPath:(NSIndexPath *)indexPath;

// 返回详情controller的title
- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;
// 返回详情controller的webView需要加载的数据
- (NSString *)contentsAtIndexPath:(NSIndexPath *)indexPath;

@end
