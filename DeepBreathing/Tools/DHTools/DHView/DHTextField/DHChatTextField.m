//
//  DHChatTextField.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-17.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHChatTextField.h"
#import "DHFoundationTool.h"
#import "DHConvenienceAutoLayout.h"

#define VIEW_HEIGHT 50

@interface DHChatTextField ()<UITextFieldDelegate>
{
    CGFloat keyboardHeight;
}
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton * sendBtn;

@end

@implementation DHChatTextField

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.textField = nil;
    self.placeHolder = nil;
    self.sendBtn = nil;
}

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder delegate:(id<DHChatTextFieldDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - VIEW_HEIGHT, [[UIScreen mainScreen] bounds].size.width, VIEW_HEIGHT)];
    if (self) {
        self.placeHolder = placeHolder;
        self.delegate = delegate;
        [self registerForKeyboardNotifications];
        self.backgroundColor = [DHFoundationTool colorWith255Red:247 green:248 blue:248 alpha:1];
        
        [self draw];
        _textField.delegate = self;
//        [_textField becomeFirstResponder];
    }
    
    
    return self;
}

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)draw
{
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
    sendBtn.enabled = NO;
    self.sendBtn = sendBtn;
    [self addSubview:sendBtn];
    
    // auto layout
    if ([DHFoundationTool iPhone4]) {
        [self addConstraints:[DHConvenienceAutoLayout constraintsWithSize:CGSizeMake(32, 18) forView:sendBtn]];
    } else {
        [self addConstraints:[DHConvenienceAutoLayout constraintsWithSize:[DHConvenienceAutoLayout sizeWithiPhone5Size:CGSizeMake(32, 18) adjustWidth:YES] forView:sendBtn]];
    }
    [self addConstraint:[NSLayoutConstraint constraintWithItem:sendBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-12*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:sendBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    // text field
    UITextField * textField = [[UITextField alloc] init];
    textField.placeholder = self.placeHolder;
    textField.layer.cornerRadius = 3;
    textField.backgroundColor = [UIColor whiteColor];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
    [self addSubview:textField];
    
    [self addConstraints:[DHConvenienceAutoLayout constraintsWithSize:[DHConvenienceAutoLayout sizeWithiPhone5Size:CGSizeMake(260, 28) adjustWidth:![DHFoundationTool iPhone4]] forView:textField]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:10*[DHConvenienceAutoLayout iPhone5HorizontalMutiplier]]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    _textField = textField;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}

- (UITextField *)textField
{
    return _textField;
}

- (void)onSend
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTextField:didSendMessage:)]) {
        [self.delegate chatTextField:self didSendMessage:_textField.text];
    }
}


- (void)beginMoveUpAnimation
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.frame = CGRectOffset(self.frame, 0, -keyboardHeight);
        self.frame = CGRectMake(self.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - VIEW_HEIGHT-keyboardHeight, self.frame.size.width, self.frame.size.height);
        [self setNeedsUpdateConstraints];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - callbakcs
- (void)textFieldChanged:(id)sender
{
    self.sendBtn.enabled = (_textField.text.length >= 2);
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    keyboardHeight = kbSize.height;
    //输入框位置动画加载
    [self beginMoveUpAnimation];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectOffset(self.frame, 0, keyboardHeight);
        [self setNeedsUpdateConstraints];
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location + range.length > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 200) ? NO : YES;
}

@end
