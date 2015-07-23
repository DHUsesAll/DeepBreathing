//
//  KnowledgeModel.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-23.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "KnowledgeModel.h"
#import "NetworkingManager+Knowledge.h"

@implementation KnowledgeModel

- (void)getKnowledgeDataList
{
    UserModel * model = [UserModel defaultUser];
    [NetworkingManager getKnowledgeWithParams:@{@"phone":model.phoneNumber,@"password":model.password,@"page":@"1",@"token":model.token} success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        self.knowledgeData = responseObj;
        
    } failure:^(NSError *error) {
        
    }];
}

@end
