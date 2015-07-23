//
//  NetworkingManager+Knowledge.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-23.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "NetworkingManager+Knowledge.h"

@implementation NetworkingManager (Knowledge)

+ (AFHTTPRequestOperation *)getKnowledgeWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure
{
    AFHTTPRequestOperation * operation = [NetworkingManager postWithUrl:@"app/knowledge/getKnowList.html" requestParams:params successHandler:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failureHandler:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
}

@end
