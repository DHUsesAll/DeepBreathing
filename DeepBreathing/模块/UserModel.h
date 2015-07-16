//
//  UserModel.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString * photo;


+ (UserModel *)defaultUser;

@end
