//
//  DHThemeSettings.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-20.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DHThemeSettings : NSObject

+ (UIFont *)themeFontOfSize:(CGFloat)fontSize;

+ (UIFont *)themeTitleFontOfSize:(CGFloat)fontSize;

+ (UIColor *)themeTitleColor;

+ (UIColor *)themeTextColor;

+ (UIColor *)themeColor;

#pragma mark - theme hud info
+ (NSString *)hudGetSuccessInfo;
+ (NSString *)hudGetTitle;

+ (NSString *)hudUploadSuccessInfo;
+ (NSString *)hudUploadTitle;

@end
