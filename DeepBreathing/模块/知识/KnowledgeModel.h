//
//  KnowledgeModel.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-23.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnowledgeModel : NSObject

@property (nonatomic, strong) id knowledgeData;

- (void)getKnowledgeDataList;

@end
