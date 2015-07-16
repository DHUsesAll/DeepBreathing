//
//  DHThemeSettings.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-20.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHThemeSettings.h"
#import "DHFoundationTool.h"

@implementation DHThemeSettings

+ (UIFont *)themeFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize];
}

+ (UIFont *)themeTitleFontOfSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIColor *)themeTitleColor
{
    return [DHFoundationTool colorWith255Red:51 green:51 blue:51 alpha:1];
}

+ (UIColor *)themeTextColor
{
    return [UIColor darkGrayColor];
}

+ (UIColor *)themeColor
{
    return [DHFoundationTool colorWith255Red:105 green:213 blue:233 alpha:1];
}

#pragma mark - theme hud info
+ (NSString *)hudGetSuccessInfo
{
    return @"获取成功";
}

+ (NSString *)hudGetTitle
{
    return @"正在努力获取数据";
}

+ (NSString *)hudUploadSuccessInfo
{
    return @"上传成功";
}

+ (NSString *)hudUploadTitle
{
    return @"正在努力上传数据";
}

@end
