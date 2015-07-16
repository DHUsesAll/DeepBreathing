//
//  DHRequest.h
//  HealthManagement
//
//  Created by DreamHack on 14-11-11.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//#define SERVER_URL @"http://192.168.0.104:8080/api/"
#define SERVER_URL @"http://huhu.aliapp.com/api/"

typedef void (^postSuccessHandler)(AFHTTPRequestOperation * operation, id responseObject);
typedef void (^postFailureHandler)(AFHTTPRequestOperation * operation, NSError * error);
typedef void (^multiPostSuccessHandler)(NSArray * operationQueue, NSArray * responseObjects);
typedef void (^postCancelHandler)(void);

@interface DHRequest : NSObject

+ (AFHTTPRequestOperationManager *)sharedManager;

// 将用户信息上传至服务器
+ (AFHTTPRequestOperation *)postWithURL:(NSString *)baseUrl
                              paramJson:(id)params
                         successHandler:(postSuccessHandler)success
                         failureHandler:(postFailureHandler)failure
                            cancelBlock:(postCancelHandler)cancel;


@end
