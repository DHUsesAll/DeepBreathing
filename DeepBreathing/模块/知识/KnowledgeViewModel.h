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


- (BOOL)isRequestSuccess;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSDictionary *)cellInfoAtIndexPath:(NSIndexPath *)indexPath;

@end
