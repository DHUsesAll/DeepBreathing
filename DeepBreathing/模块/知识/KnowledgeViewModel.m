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
    
    NSDictionary * cellInfoDic = self.knowledgeData[@"data"][@"result"][indexPath.section];
    
    cellInfo[kKnowledgeCellInfoDateKey] = cellInfoDic[@"createTime"];
    cellInfo[kKnowledgeCellInfoTitleKey] = cellInfoDic[@"title"];
    cellInfo[kKnowledgeCellInfoImageKey] = [BASE_URL stringByAppendingString:cellInfoDic[@"pic"]];
    
    return cellInfo;
}

@end
