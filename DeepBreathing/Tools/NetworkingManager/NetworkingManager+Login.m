//
//  NetworkingManager+Login.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-17.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "NetworkingManager+Login.h"

#define LOGIN_URL   @"app/user/login.html"

@implementation NetworkingManager (Login)

+ (AFHTTPRequestOperation *)loginWithUserName:(NSString *)userName password:(NSString *)password successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:userName forKey:@"phone"];
    [parameters setObject:[password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"password"];
    [parameters setObject:[UserModel defaultUser].token forKey:@"token"];
    [parameters setObject:@"iphone" forKey:@"type"];
    return [NetworkingManager postWithUrl:LOGIN_URL requestParams:parameters successHandler:success failureHandler:failure];
    
}

@end
