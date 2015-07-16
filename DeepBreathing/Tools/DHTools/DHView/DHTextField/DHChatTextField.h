//
//  DHChatTextField.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-17.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DHChatTextField;

@protocol DHChatTextFieldDelegate <NSObject>

- (void)chatTextField:(DHChatTextField *)chatTextField didSendMessage:(NSString *)message;

@end

@interface DHChatTextField : UIView

@property (nonatomic, strong) NSString * placeHolder;

@property (nonatomic, weak) id <DHChatTextFieldDelegate> delegate;

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder delegate:(id <DHChatTextFieldDelegate>)delegate;

- (UITextField *)textField;

@end
