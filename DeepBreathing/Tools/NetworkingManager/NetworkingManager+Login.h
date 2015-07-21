//
//  NetworkingManager+Login.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-17.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "NetworkingManager.h"

@interface NetworkingManager (Login)

+ (AFHTTPRequestOperation *)loginWithUserName:(NSString *)userName password:(NSString *)password successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure;












@end
