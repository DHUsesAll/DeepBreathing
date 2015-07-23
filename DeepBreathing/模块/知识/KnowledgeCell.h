//
//  KnowledgeCell.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-23.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KnowledgeCell : UITableViewCell

@property (nonatomic, strong) NSDictionary * cellInfo;

@end

extern NSString * const kKnowledgeCellInfoImageKey;

extern NSString * const kKnowledgeCellInfoTitleKey;

extern NSString * const kKnowledgeCellInfoDateKey;



