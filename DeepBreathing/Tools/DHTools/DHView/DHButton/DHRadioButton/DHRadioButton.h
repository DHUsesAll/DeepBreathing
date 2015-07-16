//
//  DHRadioButton.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-21.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHRadioButton;

@protocol DHRadioButtonDelegate <NSObject>

- (void)radioButton:(DHRadioButton *)radioButton didSelectItemWithTitle:(NSString *)title;

@end

@interface DHRadioButton : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) id <DHRadioButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame groupId:(NSString *)groupId themeColor:(UIColor *)themeColor title:(NSString *)title;

@end
