//
//  DHAutoLayout.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-16.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHConvenienceAutoLayout.h"
#import "DHFoundationTool.h"

#define SCREEN_BOUNDS   [[UIScreen mainScreen] bounds]
#define IPHONE5_SIZE    CGSizeMake(320,568)

@implementation DHConvenienceAutoLayout

+ (CGRect)frameWithLayoutOption:(DHAutoLayoutOption)option iPhone5Frame:(CGRect)itemFrame adjustWidth:(BOOL)flag
{
    CGPoint itemCenter = [DHFoundationTool centerWithFrame:itemFrame];
    
    CGPoint center = [self centerWithiPhone5Center:itemCenter];
    
    CGSize size = [self sizeWithiPhone5Size:itemFrame.size adjustWidth:flag];
    if (option == (DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale)) {
        return [DHFoundationTool rectWithSize:size center:center];
    } else if (option == DHAutoLayoutOptionPosition) {
        return [DHFoundationTool rectWithSize:itemFrame.size center:center];
    } else if (option == DHAutoLayoutOptionScale) {
        return [DHFoundationTool rectWithSize:size center:itemCenter];
    } else {
        
        return itemFrame;
    }
}

+ (CGRect)frameWithLayoutOption:(DHAutoLayoutOption)option iPhone5Size:(CGSize)itemSize iPhone5Center:(CGPoint)itemCenter adjustWidth:(BOOL)flag
{
    CGRect frame = [DHFoundationTool rectWithSize:itemSize center:itemCenter];
    
    
    return [self frameWithLayoutOption:option iPhone5Frame:frame adjustWidth:flag];
}

+ (CGSize)sizeWithiPhone5Size:(CGSize)itemSize adjustWidth:(BOOL)flag
{
    if (flag) {
        return CGSizeMake(itemSize.height * [self iPhone5VerticalMutiplier]*itemSize.width/itemSize.height, itemSize.height * [self iPhone5VerticalMutiplier]);
    }
    return CGSizeMake(itemSize.width, itemSize.height * [self iPhone5VerticalMutiplier]);
}

+ (CGPoint)centerWithiPhone5Center:(CGPoint)itemCenter
{

    return CGPointMake(itemCenter.x * [self iPhone5HorizontalMutiplier], itemCenter.y * [self iPhone5VerticalMutiplier]);
}

+ (NSArray *)constraintsWithSize:(CGSize)size forView:(UIView *)view
{
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity:0];
    NSString * format = [NSString stringWithFormat:@"[view(%f)]",size.width];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    format = [NSString stringWithFormat:@"V:[view(%f)]",size.height];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    return constraints;
}

+ (CGFloat)iPhone5HorizontalMutiplier
{
    return SCREEN_BOUNDS.size.width/IPHONE5_SIZE.width;
}

+ (CGFloat)iPhone5VerticalMutiplier
{
    return SCREEN_BOUNDS.size.height/IPHONE5_SIZE.height;
}


@end
