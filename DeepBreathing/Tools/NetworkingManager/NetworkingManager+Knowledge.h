//
//  NetworkingManager+Knowledge.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-23.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "NetworkingManager.h"

@interface NetworkingManager (Knowledge)

+ (AFHTTPRequestOperation *)getKnowledgeWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
