//
//  DHPickerTextField.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-21.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHPickerTextField : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign, getter=isShowing) BOOL show;
@property (nonatomic, strong) NSArray * components;
@property (nonatomic, strong) NSString * placeHolder;

- (instancetype)initWithFrame:(CGRect)frame pickerComponents:(NSArray *)components pickerHeight:(CGFloat)pickerHeight;

@end
