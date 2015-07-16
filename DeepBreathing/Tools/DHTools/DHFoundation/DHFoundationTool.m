//
//  DHFoundationTool.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-16.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHFoundationTool.h"
#import "DHThemeSettings.h"

@implementation DHFoundationTool

+ (CGRect)rectWithSize:(CGSize)size center:(CGPoint)center
{
    return CGRectMake(center.x-size.width/2, center.y-size.height/2, size.width, size.height);
}

+ (CGPoint)centerWithFrame:(CGRect)frame
{
    return CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2);
}

+ (UIColor *)colorWith255Red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a
{
    
    return [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:a];
    
}

+ (NSString *)dateDescriptionWithFormat:(NSString *)format date:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

+ (UIColor *)colorInterpolateWithRate:(CGFloat)rate fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    CGFloat firstComponents[4];
    CGFloat secondComponents[4];
    
    [self getRGBComponents:firstComponents forColor:fromColor];
    [self getRGBComponents:secondComponents forColor:toColor];
    
    CGFloat r = firstComponents[0] + (secondComponents[0] - firstComponents[0])*rate;
    CGFloat g = firstComponents[1] + (secondComponents[1] - firstComponents[1])*rate;
    CGFloat b = firstComponents[2] + (secondComponents[2] - firstComponents[2])*rate;
    CGFloat a = firstComponents[3] + (secondComponents[3] - firstComponents[3])*rate;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (void)getRGBComponents:(CGFloat [4])components forColor:(UIColor *)color
{
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 4; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

+ (CGFloat)deviceOperatingSystemVersion
{
    return [[UIDevice currentDevice].systemVersion floatValue];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)iPhone4
{
    return [UIScreen mainScreen].bounds.size.height <= 480;
}

+ (void)showAlertInController:(UIViewController *)controller withTitle:(NSString *)title infoMessage:(NSString *)message
{
    if ([DHFoundationTool deviceOperatingSystemVersion] < 8.0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        [controller presentViewController:alertController animated:YES completion:nil];
    }
}

+ (NSString *)imageBase64Description:(UIImage *)image
{
    NSData * data = UIImageJPEGRepresentation(image, 0.2);
    NSString * encode = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return encode;
}

@end