//
//  NetworkingManager.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-17.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

typedef void(^SuccessBlock)(id responseObj);

typedef void(^FailureBlock)(NSError * error);

@interface NetworkingManager : NSObject

+ (AFHTTPRequestOperation *)postWithUrl:(NSString *)url requestParams:(NSDictionary *)params successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure;


@end
