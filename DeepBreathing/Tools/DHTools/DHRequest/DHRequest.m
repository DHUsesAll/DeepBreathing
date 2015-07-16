//
//  DHRequest.m
//  HealthManagement
//
//  Created by DreamHack on 14-11-11.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHRequest.h"
#import "UIKit+AFNetworking.h"
#import "JSONKit.h"

static AFHTTPRequestOperationManager * manager_;


@implementation DHRequest

+ (AFHTTPRequestOperationManager *)sharedManager
{
    
    return manager_;
}

+ (AFHTTPRequestOperation *)postWithURL:(NSString *)baseUrl paramJson:(id)params successHandler:(postSuccessHandler)success failureHandler:(postFailureHandler)failure cancelBlock:(postCancelHandler)cancel
{
    AFNetworkActivityIndicatorManager * manager = [AFNetworkActivityIndicatorManager sharedManager];
    manager.enabled = YES;
    
    NSString * postUrl = [SERVER_URL stringByAppendingString:baseUrl];
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    manager_ = operationManager;
    operationManager.requestSerializer.timeoutInterval = 60;
    AFHTTPRequestOperation * operation = [operationManager POST:postUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(operation,responseObject);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error.code == -999) {
            // 手动取消
            if (cancel) {
                cancel();
            }
            NSLog(@"手动取消");
            
            // -1001 time out
        } else {
            NSLog(@"%@",error);
            failure(operation,error);
        }
        
    }];
    
    return operation;
}

@end
