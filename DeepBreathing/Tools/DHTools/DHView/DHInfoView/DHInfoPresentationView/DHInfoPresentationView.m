//
//  DHInfoPresentationView.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-30.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHInfoPresentationView.h"
#import "DHThemeSettings.h"
#import "DHConvenienceAutoLayout.h"
@interface DHInfoPresentationView () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray * itemViews;
@property (nonatomic, strong) NSMutableArray * canEditItems;
@property (nonatomic, assign) UITextField * inputtingTextField;
@property (nonatomic, assign) CGRect originFrame;


@end

@implementation DHInfoPresentationView
{
    CGFloat keyboardHeight;
    CGFloat yOffset;
    BOOL willOcclusionTextField;
    BOOL showKeyBoard;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemViews = nil;
    self.canEditItems = nil;
}

- (instancetype)initWithFrame:(CGRect)frame itemHeight:(CGFloat)itemHeight dataSource:(id<DHInfoPresentationViewDataSource>)dataSource delegate:(id<DHInfoPresentationViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.originFrame = frame;
        _itemHeight = itemHeight;
        self.dataSource = dataSource;
        self.delegate = delegate;
        
        self.layer.masksToBounds = YES;
        //使用NSNotificationCenter 鍵盤出現時
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        //使用NSNotificationCenter 鍵盤隐藏時
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        [self draw];
    }
    return self;
}

- (void)draw
{
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(numberOfItemsInInfoPresentationView:)] || ![self.dataSource respondsToSelector:@selector(infoPresentationView:canEditItemAtIndex:)] || ![self.dataSource respondsToSelector:@selector(infoPresentationView:infoForItemAtIndex:)] || ![self.dataSource respondsToSelector:@selector(infoPresentationView:inputViewForItemAtIndex:)] || ![self.dataSource respondsToSelector:@selector(infoPresentationView:titleForItemAtIndex:)] || ![self.dataSource respondsToSelector:@selector(infoPresentationView:fontForItemAtIndex:)]) {
        return;
    }
    
    self.itemViews = [NSMutableArray arrayWithCapacity:0];
    self.canEditItems = [NSMutableArray arrayWithCapacity:0];
    NSInteger itemNumber = 0;
    itemNumber = [self.dataSource numberOfItemsInInfoPresentationView:self];

    if (itemNumber == 0) {
        return;
    }
    for (int i = 0; i < itemNumber; i++) {
        
        UIView * itemView = [[UIView alloc] init];
        itemView.bounds = CGRectMake(0, 0, self.frame.size.width, _itemHeight);
        itemView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/(itemNumber + 1) * (i+1));
        
        [self addSubview:itemView];
        [_itemViews addObject:itemView];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * [DHConvenienceAutoLayout iPhone5HorizontalMutiplier], 0, 0, 0)];
        titleLabel.text = [NSString stringWithFormat:@"%@：",[self.dataSource infoPresentationView:self titleForItemAtIndex:i]];
        titleLabel.font = [self.dataSource infoPresentationView:self fontForItemAtIndex:i];
        [titleLabel sizeToFit];
        titleLabel.textColor = [DHThemeSettings themeTextColor];
        [itemView addSubview:titleLabel];
        
        id info = [self.dataSource infoPresentationView:self infoForItemAtIndex:i];
        if ([info isKindOfClass:[NSString class]]) {
            UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(20 * [DHConvenienceAutoLayout iPhone5HorizontalMutiplier]+titleLabel.frame.size.width, 0, self.frame.size.width - titleLabel.frame.size.width - 20 * [DHConvenienceAutoLayout iPhone5HorizontalMutiplier] * 2, titleLabel.frame.size.height)];
            textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, self.frame.size.height)];
            textField.leftViewMode = UITextFieldViewModeUnlessEditing;
            textField.attributedText = [[NSAttributedString alloc] initWithString:info attributes:@{NSFontAttributeName:[self.dataSource infoPresentationView:self fontForItemAtIndex:i] , NSForegroundColorAttributeName:[DHThemeSettings themeTextColor]}];
            textField.layer.cornerRadius = 3;
            textField.inputView = [self.dataSource infoPresentationView:self inputViewForItemAtIndex:i];
            textField.userInteractionEnabled = NO;
            textField.delegate = self;
            if ([self.dataSource infoPresentationView:self canEditItemAtIndex:i]) {
                [_canEditItems addObject:textField];
            }
            [itemView addSubview:textField];
        } else if ([info isKindOfClass:[NSArray class]]) {
            for (int j = 0; j < [info count]; j++) {
                UIImage * image = [info objectAtIndex:j];
                UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
                imageView.frame = CGRectMake(20 * [DHConvenienceAutoLayout iPhone5HorizontalMutiplier]+15*j+titleLabel.frame.size.width, 0, self.frame.size.width - titleLabel.frame.size.width - 20 * [DHConvenienceAutoLayout iPhone5HorizontalMutiplier] * 2, titleLabel.frame.size.height);
                [itemView addSubview:imageView];
            }
            
        }
        
    }
    
}

- (void)addItemWithTitle:(NSString *)title info:(id)info canEdit:(BOOL)flag
{
    UIView * itemView = [[UIView alloc] init];
    itemView.bounds = CGRectMake(0, 0, self.frame.size.width, _itemHeight);
    [_itemViews addObject:itemView];
    [self addSubview:itemView];
    for (int i = 0; i < _itemViews.count; i++) {
        UIView * view = [_itemViews objectAtIndex:i];
        view.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/(_itemViews.count + 1) * (i+1));
    }
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"%@：",title];
    titleLabel.font = [DHThemeSettings themeFontOfSize:_itemHeight];
    [titleLabel sizeToFit];
    titleLabel.textColor = [DHThemeSettings themeTextColor];
    [itemView addSubview:titleLabel];
    
    if ([info isKindOfClass:[NSString class]]) {
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.frame.size.width, 0, self.frame.size.width - titleLabel.frame.size.width, self.frame.size.height)];
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, self.frame.size.height)];
        textField.leftViewMode = UITextFieldViewModeUnlessEditing;
        textField.attributedText = [[NSAttributedString alloc] initWithString:info attributes:@{NSFontAttributeName:[DHThemeSettings themeFontOfSize:_itemHeight] , NSForegroundColorAttributeName:[DHThemeSettings themeTextColor]}];
        textField.layer.cornerRadius = 3;
        textField.userInteractionEnabled = NO;
        textField.delegate = self;
        if (flag) {
            [_canEditItems addObject:textField];
        }
        [itemView addSubview:textField];
    } else if ([info isKindOfClass:[NSArray class]]) {
        
    }
    
}

- (NSArray *)presentationInfos
{
    NSMutableArray * presentationInfos = [NSMutableArray arrayWithCapacity:0];
    for (UIView * itemView in _itemViews) {
        for (UIView * view in itemView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField * textField = (UITextField *)view;
                [presentationInfos addObject:textField.text];
            }
        }
    }
    
    return presentationInfos;
}

- (void)reloadData
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemViews = nil;
    self.canEditItems = nil;
    [self draw];
}


- (void)setEditting:(BOOL)editting
{
    if (_editting == editting) {
        return;
    }
    _editting = editting;
    if (editting) {
        for (int i = 0; i < _canEditItems.count; i++) {
            UITextField * textField = [_canEditItems objectAtIndex:i];
            textField.userInteractionEnabled = YES;
            
            textField.backgroundColor = [UIColor whiteColor];
            [UIView animateWithDuration:0.3 animations:^{
                textField.frame = CGRectOffset(textField.frame, 10, 0);
            }];
            
//            if (i == 0) {
//                [textField becomeFirstResponder];
//            }
        }
        
        
    } else {
        for (UITextField * textField in _canEditItems) {
            
            [textField resignFirstResponder];
            textField.backgroundColor = [UIColor clearColor];
            textField.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.3 animations:^{
                textField.frame = CGRectOffset(textField.frame, -10, 0);
            }];
        }
    }
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    if (_itemHeight == itemHeight) {
        return;
    }
    _itemHeight = itemHeight;
}

- (void)setInfo:(id)info forItemAtIndex:(NSInteger)index
{
    if ([info isKindOfClass:[NSString class]]) {
        
        
        for (UIView * view in [[_itemViews objectAtIndex:index] subviews]) {
            
            if ([view isKindOfClass:[UITextField class]]) {
                
                UITextField * textField = (UITextField *)view;
                textField.text = info;
                
            }
            
        }
        
    } else {
        
    }
}

- (void)hideKeyBorad
{
    [_inputtingTextField resignFirstResponder];
}

#pragma mark - delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _inputtingTextField = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _inputtingTextField = textField;
    if (showKeyBoard) {
        UIView * superView = _inputtingTextField.superview;
        if (superView.frame.origin.y+superView.frame.size.height + self.frame.origin.y>= [UIScreen mainScreen].bounds.size.height - keyboardHeight) {
            willOcclusionTextField = YES;
            yOffset = superView.frame.origin.y+superView.frame.size.height + self.frame.origin.y- ([UIScreen mainScreen].bounds.size.height - keyboardHeight);
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.frame = CGRectOffset(self.frame, 0, -yOffset);
            } completion:nil];
            
        }
    }
    for (int i = 0; i < _itemViews.count; i++) {
        
        UIView * view = [_itemViews objectAtIndex:i];
        for (UIView * subView in view.subviews) {
            if (subView == textField) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(infoPresentationView:didBeginEditingItemWithInfo:atIndex:)]) {
                    [self.delegate infoPresentationView:self didBeginEditingItemWithInfo:textField.text atIndex:i];
                    return;
                }
            }
        }
    }
}

#pragma mark - callbacks
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (!_inputtingTextField) {
        return;
    }
    showKeyBoard = YES;
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    keyboardHeight = kbSize.height;
    //输入框位置动画加载
    UIView * superView = _inputtingTextField.superview;
    if (superView.frame.origin.y+superView.frame.size.height + self.frame.origin.y>= [UIScreen mainScreen].bounds.size.height - keyboardHeight) {
        willOcclusionTextField = YES;
        yOffset = superView.frame.origin.y+superView.frame.size.height + self.frame.origin.y- ([UIScreen mainScreen].bounds.size.height - keyboardHeight);
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
          
            self.frame = CGRectOffset(self.frame, 0, -yOffset);
        } completion:nil];
        
    }
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
        if (willOcclusionTextField) {
    
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.frame = _originFrame;
                [self setNeedsUpdateConstraints];
            } completion:^(BOOL finished) {
                showKeyBoard = NO;
                willOcclusionTextField = NO;
            }];
            
        }
    showKeyBoard = NO;
}

@end
