//
//  KnowledgeViewModel.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-23.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "KnowledgeViewModel.h"
#import "KnowledgeCell.h"

@interface KnowledgeViewModel ()


@property (nonatomic, strong) id knowledgeData;

@end

@implementation KnowledgeViewModel

- (void)prepareWithData:(id)knowledgeData
{
    self.knowledgeData = knowledgeData;
}

- (BOOL)isRequestSuccess
{
    return ([self.knowledgeData[@"status"] integerValue] == 0);
}

- (NSInteger)numberOfSections
{
    return [self.knowledgeData[@"data"][@"result"] count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSDictionary *)cellInfoAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * cellInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSDictionary * cellInfoDic = [self cellInfoDicAtIndexPath:indexPath];
    
    cellInfo[kKnowledgeCellInfoDateKey] = cellInfoDic[@"createTime"];
    cellInfo[kKnowledgeCellInfoTitleKey] = cellInfoDic[@"title"];
    cellInfo[kKnowledgeCellInfoImageKey] = [BASE_URL stringByAppendingString:cellInfoDic[@"pic"]];
    
    return cellInfo;
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * infoDic = [self cellInfoDicAtIndexPath:indexPath];
    
    return infoDic[@"title"];
}

- (NSString *)contentsAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * infoDic = [self cellInfoDicAtIndexPath:indexPath];
    
    return infoDic[@"content"];
}


#pragma mark - 私有方法
- (NSDictionary *)cellInfoDicAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cellInfoDic = self.knowledgeData[@"data"][@"result"][indexPath.section];
    
    return cellInfoDic;
}

@end
