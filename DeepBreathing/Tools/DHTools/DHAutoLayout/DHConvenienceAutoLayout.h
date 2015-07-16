//
//  DHAutoLayout.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-16.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    
    DHAutoLayoutOptionPosition = 1,
    DHAutoLayoutOptionScale = DHAutoLayoutOptionPosition << 1,
    
} DHAutoLayoutOption;

@interface DHConvenienceAutoLayout : NSObject

+ (CGRect)frameWithLayoutOption:(DHAutoLayoutOption)option iPhone5Size:(CGSize)itemSize iPhone5Center:(CGPoint)itemCenter adjustWidth:(BOOL)flag;

+ (CGRect)frameWithLayoutOption:(DHAutoLayoutOption)option iPhone5Frame:(CGRect)itemFrame adjustWidth:(BOOL)flag;

+ (CGSize)sizeWithiPhone5Size:(CGSize)itemSize adjustWidth:(BOOL)flag;

+ (CGPoint)centerWithiPhone5Center:(CGPoint)itemCenter;

+ (NSArray *)constraintsWithSize:(CGSize)size forView:(UIView *)view;

+ (CGFloat)iPhone5HorizontalMutiplier;
+ (CGFloat)iPhone5VerticalMutiplier;

@end
