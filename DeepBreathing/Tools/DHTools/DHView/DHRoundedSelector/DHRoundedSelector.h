//
//  DHRoundedSelector.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-14.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHRoundedSelector;

@protocol  DHRoundedSelectorDelegate <NSObject>

@optional

- (void)roundedSelector:(DHRoundedSelector *)selector didSelectItemAtIndex:(NSInteger)index touchPosition:(CGPoint)position;

@end

@interface DHRoundedSelector : UIView

@property (nonatomic, weak) id <DHRoundedSelectorDelegate> delegate;

- (instancetype)initWithCenter:(CGPoint)center circleRadius:(CGFloat)radius backgroundImage:(UIImage *)image selectionNumber:(NSInteger)number delegate:(id<DHRoundedSelectorDelegate>) delegate;


@end
