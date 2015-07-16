//
//  DHFoundationTool.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-16.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DHFoundationTool : NSObject

// Core Graphics
+ (CGRect)rectWithSize:(CGSize)size center:(CGPoint)center;
+ (CGPoint)centerWithFrame:(CGRect)frame;

// NSDate
+ (NSString *)dateDescriptionWithFormat:(NSString *)format date:(NSDate *)date;

// UIColor
+ (UIColor *)colorWith255Red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;

+ (UIColor *)colorInterpolateWithRate:(CGFloat)rate fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

+ (void)getRGBComponents:(CGFloat [4])components forColor:(UIColor *)color;


+ (CGFloat)deviceOperatingSystemVersion;

+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateMobile:(NSString *)mobile;

+ (BOOL)iPhone4;


+ (void)showAlertInController:(UIViewController *)controller withTitle:(NSString *)title infoMessage:(NSString *)message;

+ (NSString *)imageBase64Description:(UIImage *)image;

NS_INLINE float acot(float x)
{
    if (x == 0) {
        return M_PI_2;
    }
    
    return atan(1/x);
}

@end
