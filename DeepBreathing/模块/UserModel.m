//
//  UserModel.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "UserModel.h"
#import "NetworkingManager.h"

@implementation UserModel

+ (UserModel *)defaultUser
{
    static UserModel * userModel;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        userModel = [[UserModel alloc] init];
    });
    return userModel;
}

@end
