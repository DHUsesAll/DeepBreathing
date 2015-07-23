//
//  NetworkingManager.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-17.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "NetworkingManager.h"
#import "AFNetworking.h"



@implementation NetworkingManager

+ (AFHTTPRequestOperation *)postWithUrl:(NSString *)url requestParams:(NSDictionary *)params successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure
{
    
    url = [BASE_URL stringByAppendingString:url];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation * operation = [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    
    return operation;
}

@end
