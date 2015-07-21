//
//  DHInfoFillInView.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-21.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHInfoFillInView.h"
#import "DHConvenienceAutoLayout.h"
#import "DHThemeSettings.h"
#import "DHFoundationTool.h"
#import "DHRadioButton.h"
#import "DHPickerTextField.h"
#import "DHButton.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define ORIGINAL_MAX_WIDTH 640.0f

#define ITEM_TAG    1123
#define ITEM_SPACING 10
#define ITEM_HEIGHT 35
#define FONT_SIZE   15

//#define THEME_COLOR [DHThemeSettings themeColor]

NSString * const kDHInfoFillInTypeField = @"kDHInfoFillInTypeField";             // 输入框
NSString * const kDHInfoFillInTypeRadioButton = @"kDHInfoFillInTypeRadioButton";     // 单选
NSString * const kDHInfoFillInTypeCaptcha = @"kDHInfoFillInTypeCaptcha";        // 验证码
NSString * const kDHInfoFillInTypePhoto = @"kDHInfoFillInTypePhoto";             // 照片
NSString * const kDHInfoFillInTypeBlank = @"kDHInfoFillInTypeBlank";             // 留白

NSString * const kDHTextFieldFillInTypeText = @"kDHTextFieldFillInTypeText";         // 文本输入
NSString * const kDHTextFieldFillInTypeControl = @"kDHTextFieldFillInTypeControl";      // 控件输入


@interface DHInfoFillInView ()<UITextFieldDelegate,DHRadioButtonDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic ,strong) NSArray * attributes;
@property (nonatomic, strong) NSMutableArray * fillInInfos;
@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) UIToolbar * toolBar;
@property (nonatomic, strong) NSMutableDictionary * pickerComponentsDic;

@property (nonatomic, strong) UIImagePickerController * imagePickerController;

@property (nonatomic, weak) UITextField * inputtingTextField;
@property (nonatomic, weak) NSString * pickInfo;
@property (nonatomic, strong) UILabel * errorLabel;
@property (nonatomic, assign) CGFloat itemSpacing;

@property (nonatomic, assign) UIViewController * currentController;

@property (nonatomic, weak) DHButton * currentImageButton;

@end

@implementation DHInfoFillInView
{
    CGFloat _titleWidth;
    CGFloat _unitWidth;
    CGFloat keyboardHeight;
    CGFloat yOffset;
    BOOL willOcclusionTextField;
    BOOL showKeyBoard;
}

- (void)dealloc
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.attributes = nil;
    self.fillInInfos = nil;
    self.pickerView = nil;
    self.pickerComponentsDic = nil;
    self.toolBar = nil;
    self.errorLabel = nil;
    self.imagePickerController = nil;
}

- (instancetype)initWithFrame:(CGRect)frame fillInAttributes:(NSArray *)attributes titleWidth:(CGFloat)titleWidth unitWidth:(CGFloat)unitWidth itemSpacing:(CGFloat)spacing
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemSpacing = spacing;
        self.attributes = attributes;
        self.layer.masksToBounds = YES;
        self.fillInInfos = [NSMutableArray arrayWithCapacity:0];
        self.pickerComponentsDic = [NSMutableDictionary dictionaryWithCapacity:0];
        _titleWidth = titleWidth;
        _unitWidth = unitWidth;
        keyboardHeight = 0;
        self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
        _errorLabel.font = [UIFont boldSystemFontOfSize:10*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
        _errorLabel.textColor = [DHFoundationTool colorWith255Red:247 green:56 blue:35 alpha:1];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_errorLabel];
        [self draw];
        
        willOcclusionTextField = NO;
        showKeyBoard = NO;
        //使用NSNotificationCenter 鍵盤出現時
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        //使用NSNotificationCenter 鍵盤隐藏時
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)draw
{
    if (!self.pickerView) {
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        toolbar.barStyle = UIBarStyleDefault;
        toolbar.translucent = YES;
        [toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone)]]];
        self.toolBar = toolbar;
    }
    
    
    for (int i = 0; i < self.attributes.count; i++) {
        [self.fillInInfos addObject:[NSNull null]];
        NSDictionary * attribute = [self.attributes objectAtIndex:i];
        
        CGRect frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale | DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 15+(ITEM_HEIGHT+_itemSpacing)*i , self.frame.size.width/[DHConvenienceAutoLayout iPhone5HorizontalMutiplier], ITEM_HEIGHT) adjustWidth:![DHFoundationTool iPhone4]];
        
        UIView * subView = [[UIView alloc] initWithFrame:frame];
        subView.tag = i+ITEM_TAG;
        [self addSubview:subView];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (ITEM_HEIGHT/2 - FONT_SIZE/2)*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 0, 0)];
        titleLabel.text = [attribute objectForKey:@"title"];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [DHThemeSettings themeFontOfSize:FONT_SIZE*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
        titleLabel.textColor = [DHThemeSettings themeTextColor];
        [titleLabel sizeToFit];
        titleLabel.frame = CGRectMake(0, 0, _titleWidth, titleLabel.frame.size.height);
        titleLabel.center = CGPointMake(titleLabel.frame.size.width/2, subView.frame.size.height/2);
        [subView addSubview:titleLabel];
        
        if ([attribute objectForKey:@"type"] == kDHInfoFillInTypeField) {
            
            
            NSDictionary * info = [attribute objectForKey:@"typeInfo"];
            NSString * placeHolder = [info objectForKey:@"placeHolder"];
            
            if ([info objectForKey:@"unit"] && ![[info objectForKey:@"unit"] isKindOfClass:[NSNull class]]) {
                UILabel * unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                unitLabel.text = [info objectForKey:@"unit"];
                unitLabel.font = [DHThemeSettings themeFontOfSize:FONT_SIZE*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
                unitLabel.textColor = [DHThemeSettings themeTextColor];
                [unitLabel sizeToFit];
                unitLabel.frame = CGRectMake(0, 0, _unitWidth, unitLabel.frame.size.height);
                unitLabel.center = CGPointMake(subView.frame.size.width-unitLabel.frame.size.width/2, titleLabel.center.y);
                [subView addSubview:unitLabel];
            }
            
            
            UITextField * pickerTextField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.frame.size.width, 0, subView.frame.size.width-titleLabel.frame.size.width-_unitWidth-10, subView.frame.size.height)];
            pickerTextField.delegate = self;
            pickerTextField.placeholder = placeHolder;
            pickerTextField.backgroundColor = [UIColor whiteColor];
            pickerTextField.layer.cornerRadius = 3;
            pickerTextField.layer.borderColor = THEME_TEXT_COLOR.CGColor;
            pickerTextField.layer.borderWidth = 1;
            pickerTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, pickerTextField.frame.size.height)];
            pickerTextField.leftViewMode = UITextFieldViewModeAlways;
            [subView addSubview:pickerTextField];
            if ([info objectForKey:@"type"] == kDHTextFieldFillInTypeControl) {
                
                pickerTextField.inputView = self.pickerView;
                
//                pickerTextField.inputAccessoryView = _toolBar;
                
            } else if ([info objectForKey:@"type"] == kDHTextFieldFillInTypeText) {
                pickerTextField.secureTextEntry = [[info objectForKey:@"secureTextEntry"] boolValue];
            }
            [_pickerComponentsDic setObject:[info objectForKey:@"pickerComponents"] forKey:[NSNumber numberWithInteger:i]];
        } else if ([attribute objectForKey:@"type"] == kDHInfoFillInTypeRadioButton) {
            
            NSDictionary * info = [attribute objectForKey:@"typeInfo"];
            NSArray * items = [info objectForKey:@"items"];
//            for (int j = 0; j < items.count; j++) {
//                
//                NSString * title = [items objectAtIndex:j];
//                DHRadioButton * button = [[DHRadioButton alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0 , 0, 40, 17) adjustWidth:YES] groupId:[info objectForKey:@"groupKey"] themeColor:THEME_COLOR title:title];
//                button.delegate = self;
//                
//                button.center = CGPointMake(button.frame.size.width/2+(titleLabel.frame.size.width+(40+28)*j), titleLabel.center.y);
//                [subView addSubview:button];
//                if (j == 0) {
//                    button.selected = YES;
//                }
//            }
            UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
            [segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
            [segmentedControl setSelectedSegmentIndex:0];
            [segmentedControl setTintColor:THEME_TEXT_COLOR];
            [segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * [DHConvenienceAutoLayout iPhone5VerticalMutiplier]]} forState:UIControlStateNormal];
            [segmentedControl setFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0 , 0, 130, 25) adjustWidth:YES]];
            [segmentedControl setCenter:CGPointMake(segmentedControl.frame.size.width/2+(titleLabel.frame.size.width), titleLabel.center.y)];
            [segmentedControl setSelectedSegmentIndex:[[info objectForKey:@"selectedIndex"] integerValue]];
            [subView addSubview:segmentedControl];
            [_fillInInfos replaceObjectAtIndex:_fillInInfos.count-1 withObject:[items objectAtIndex:segmentedControl.selectedSegmentIndex]];
            
        } else if ([attribute objectForKey:@"type"] == kDHInfoFillInTypeCaptcha) {
            NSDictionary * info = [attribute objectForKey:@"typeInfo"];
            NSTimeInterval interval = [[info objectForKey:@"duration"] floatValue];
            DHCaptchaActionBlock actionBlock = [info objectForKey:@"action"];
            DHCaptchaView * captchaView = [[DHCaptchaView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition | DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(_titleWidth, 0, 100, 25) adjustWidth:![DHFoundationTool iPhone4]] reEnableTimeInterval:interval actionBlock:actionBlock];
            [captchaView setTitleFont:[DHThemeSettings themeFontOfSize:13*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]]];
            [subView addSubview:captchaView];
            [_fillInInfos replaceObjectAtIndex:_fillInInfos.count-1 withObject:@"captcha"];
        } else if ([attribute objectForKey:@"type"] == kDHInfoFillInTypePhoto) {
            
            NSDictionary * info = [attribute objectForKey:@"typeInfo"];
            
            DHButton * button = [DHButton buttonWithType:UIButtonTypeCustom];
            button.bounds = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale | DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 0, 32, 23) adjustWidth:YES];
            button.center = CGPointMake(titleLabel.frame.size.width+button.frame.size.width/2, subView.frame.size.height/2);
            [button setImage:[UIImage imageWithContentsOfFile:[info objectForKey:@"defaultImagePath"]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
            [subView addSubview:button];
            
            self.imagePickerController = [[UIImagePickerController alloc] init];
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            _imagePickerController.delegate = self;
            self.currentController = [info objectForKey:@"controller"];
            
        } else if ([attribute objectForKey:@"type"] == kDHInfoFillInTypeBlank) {
            [_fillInInfos replaceObjectAtIndex:_fillInInfos.count-1 withObject:@"blank"];
        }
    }
    [self bringSubviewToFront:_errorLabel];
}

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id<DHInfoFillInViewDataSource>)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}

- (BOOL)confirmAll
{
    for (id obj in self.fillInInfos) {
        
        if ([obj isKindOfClass:[NSNull class]]) {
            return NO;
        } else if ([obj isKindOfClass:[NSString class]] && ([obj isEqualToString:@""])) {
            return NO;
        }
    }
    return YES;
}

- (void)hideErrorMessage
{
    _errorLabel.hidden = YES;
}

- (NSMutableArray *)fillInInfos
{
    return _fillInInfos;
}

- (UITextField *)textFieldAtIndex:(NSInteger)index
{
    UIView * superview = [self viewWithTag:index + ITEM_TAG];
    for (UIView * view in superview.subviews) {
        
        if ([view isKindOfClass:[UITextField class]]) {
            return (UITextField *)view;
        }
    }
    return nil;
    
}

- (UISegmentedControl *)itemViewAtIndex:(NSInteger)index
{
    UIView * superview = [self viewWithTag:index + ITEM_TAG];
    for (UIView * view in superview.subviews) {
        
        if ([view isKindOfClass:[UISegmentedControl class]]) {
            return (UISegmentedControl *)view;
        }
    }
    return nil;
}

- (void)makeTextFieldPerformAnimation:(InfoFillInAnimationType)animationType atIndex:(NSInteger)index
{
    UITextField * textField = [self textFieldAtIndex:index];
    if (animationType == InfoFillInAnimationTypeBadInput) {
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position.x";
        animation.values = @[ @0, @10, @-10, @10, @0 ];
        animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
        animation.duration = 0.28;
        
        animation.additive = YES;
        [textField.layer addAnimation:animation forKey:@"InfoFillInAnimationTypeBadInput"];
    } else if (animationType == InfoFillInAnimationTypeFocus) {
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"transform.scale";
        animation.values = @[ @0, @0.08, @0.01, @0.08, @0 ];
        animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
        animation.duration = 0.3;
        
        animation.additive = YES;
        [textField.layer addAnimation:animation forKey:@"InfoFillInAnimationTypeFocus"];
    }
    
}

- (void)makeViewPerformAnimation:(InfoFillInAnimationType)animationType atIndex:(NSInteger)index
{
    UIView * view = [self viewWithTag:index + ITEM_TAG];
    for (UIView * subview in view.subviews) {
        
        if (![subview isKindOfClass:[UILabel class]]) {
            
            if (animationType == InfoFillInAnimationTypeBadInput) {
                CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
                animation.keyPath = @"position.x";
                animation.values = @[ @0, @10, @-10, @10, @0 ];
                animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
                animation.duration = 0.28;
                
                animation.additive = YES;
                [subview.layer addAnimation:animation forKey:@"InfoFillInAnimationTypeBadInput"];
            } else if (animationType == InfoFillInAnimationTypeFocus) {
                CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
                animation.keyPath = @"transform.scale";
                animation.values = @[ @0, @0.08, @0.01, @0.08, @0 ];
                animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
                animation.duration = 0.3;
                
                animation.additive = YES;
                [subview.layer addAnimation:animation forKey:@"InfoFillInAnimationTypeFocus"];
            }
        }
        
    }
    
}

- (void)makeTextFieldPerformAnimation:(InfoFillInAnimationType)animationType atIndex:(NSInteger)index withErrorInfo:(NSString *)errorInfo
{
    if (errorInfo) {
        _errorLabel.hidden = NO;
        
        _errorLabel.text = errorInfo;
        UIView * superview = [self viewWithTag:index + ITEM_TAG];
        _errorLabel.center = CGPointMake(_errorLabel.center.x, superview.center.y-superview.frame.size.height/2-_errorLabel.frame.size.height/2-5);
    }
    [self makeTextFieldPerformAnimation:animationType atIndex:index];
}

- (void)makeCaptchaPerformAnimationAtIndex:(NSInteger)index
{
    UIView * superview = [self viewWithTag:index + ITEM_TAG];
    for (UIView * view in superview.subviews) {
        
        if ([view isKindOfClass:[DHCaptchaView class]]) {
            DHCaptchaView * captchaView = (DHCaptchaView *)view;
            [captchaView performAnimation];
        }
    }
}

- (void)reloadViewsWithAttributes:(NSArray *)attributes titleWidth:(CGFloat)titleWidth unitWidth:(CGFloat)unitWidth itemSpacing:(CGFloat)spacing
{
    self.itemSpacing = spacing;
    self.attributes = attributes;
    _titleWidth = titleWidth;
    _unitWidth = unitWidth;
    [_fillInInfos removeAllObjects];
    [_pickerComponentsDic removeAllObjects];
    CATransition * transition = [CATransition animation];
    transition.type = @"oglFlip";
    transition.subtype =  kCATransitionFromTop;
    transition.duration = 0.45;
    [self.layer addAnimation:transition forKey:@"transition"];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
    _errorLabel.font = [UIFont boldSystemFontOfSize:10*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
    _errorLabel.textColor = [DHFoundationTool colorWith255Red:247 green:56 blue:35 alpha:1];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_errorLabel];
    [self draw];
}

- (void)reloadViewsWithCompletionImage:(UIImage *)image imageSize:(CGSize)size
{
    [_fillInInfos removeAllObjects];
    [_pickerComponentsDic removeAllObjects];
    CATransition * transition = [CATransition animation];
    transition.type = @"oglFlip";
    transition.subtype =  kCATransitionFromTop;
    transition.duration = 0.45;
    [self.layer addAnimation:transition forKey:@"transition"];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    
    imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self addSubview:imageView];
    
    
}

- (void)hideKeyBorad
{
    [_inputtingTextField resignFirstResponder];
}

- (NSInteger)indexOfTextField:(UITextField *)textField
{
    UIView * superview = textField.superview;
    
    return superview.tag - ITEM_TAG;
}

- (void)setInputtingTextField:(UITextField *)inputtingTextField
{
    if (_inputtingTextField == inputtingTextField) {
        return;
    }
    _inputtingTextField = inputtingTextField;
    UIPickerView * inputView = (UIPickerView *)inputtingTextField.inputView;
    [inputView reloadAllComponents];
}

#pragma mark - attributes constructor

+ (NSDictionary *)itemAttributeWithTitle:(NSString *)title type:(NSString *)type typeInfo:(NSDictionary *)typeInfo
{
    return @{@"title":title, @"type": type, @"typeInfo":typeInfo};
}

+ (NSDictionary *)textFieldTypeInfoWithFillInType:(NSString *)type placeHolder:(NSString *)placeHolder pickerComponents:(NSArray *)components textUnit:(NSString *)unit secureTextEntry:(BOOL)flag
{
    if (!unit || [unit isKindOfClass:[NSNull class]]) {
        return @{@"type":type, @"placeHolder":placeHolder, @"pickerComponents":components,@"secureTextEntry":[NSNumber numberWithBool:flag]};
    }
    
    return @{@"type":type, @"placeHolder":placeHolder, @"pickerComponents":components, @"unit":unit,@"secureTextEntry":[NSNumber numberWithBool:flag]};
}

+ (NSDictionary *)radioButtonTypeInfoWithItems:(NSArray *)items selectedIndex:(NSInteger)index
{
    return @{@"items":items, @"selectedIndex":[NSNumber numberWithInteger:index]};
}

+ (NSDictionary *)captchaTypeInfoWithDuration:(CGFloat)duration captchaActionBlock:(DHCaptchaActionBlock)actionBlock
{
    return @{@"duration":[NSNumber numberWithFloat:duration],@"action":actionBlock};
}

+ (NSDictionary *)photoTypeInfoWithDefaultImagePath:(NSString *)defaultImagePath pickerDelegate:(id<UINavigationBarDelegate,UIImagePickerControllerDelegate>)delegate currentController:(UIViewController *)controller
{
    if (!delegate) {
        return @{@"defaultImagePath":defaultImagePath,@"controller":controller};
    }
    return @{@"defaultImagePath":defaultImagePath,@"delegate":delegate, @"controller":controller};
}

#pragma mark - delegate

- (void)radioButton:(DHRadioButton *)radioButton didSelectItemWithTitle:(NSString *)title
{
    UIView * superView = radioButton.superview;
    if (!superView) {
        return;
    }
    NSInteger index = superView.tag - ITEM_TAG;
    [self.fillInInfos replaceObjectAtIndex:index withObject:title];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIView * superView = textField.superview;
    if (!superView) {
        return;
    }
    
    NSInteger index = superView.tag - ITEM_TAG;
        
    [self.fillInInfos replaceObjectAtIndex:index withObject:textField.text];

    if (willOcclusionTextField) {
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            for (UIView * view in self.subviews) {
                view.frame = CGRectOffset(view.frame, 0, yOffset);
            }
            [self setNeedsUpdateConstraints];
        } completion:^(BOOL finished) {
            showKeyBoard = NO;
            willOcclusionTextField = NO;
        }];
        
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoFillInView:didEndEditingTextFieldAtIndex:)]) {
        [self.delegate infoFillInView:self didEndEditingTextFieldAtIndex:index];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView * superView = textField.superview;
    if (!superView) {
        return;
    }
    NSInteger index = superView.tag - ITEM_TAG;
    self.inputtingTextField = textField;
    if (showKeyBoard) {
        UIView * superView = _inputtingTextField.superview;
        if (superView.frame.origin.y+superView.frame.size.height + self.frame.origin.y>= [UIScreen mainScreen].bounds.size.height - keyboardHeight) {
            willOcclusionTextField = YES;
            yOffset = superView.frame.origin.y+superView.frame.size.height + self.frame.origin.y- ([UIScreen mainScreen].bounds.size.height - keyboardHeight);
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                for (UIView * view in self.subviews) {
                    view.frame = CGRectOffset(view.frame, 0, -yOffset);
                }
                [self setNeedsUpdateConstraints];
            } completion:nil];
            
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoFillInView:didBeginEditingTextFieldWithInputView:atIndex:)]) {
        [self.delegate infoFillInView:self didBeginEditingTextFieldWithInputView:textField.inputView atIndex:index];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[_pickerComponentsDic objectForKey:[NSNumber numberWithInteger:[self indexOfTextField:_inputtingTextField]]]count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[_pickerComponentsDic objectForKey:[NSNumber numberWithInteger:[self indexOfTextField:_inputtingTextField]]] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _inputtingTextField.text = [[_pickerComponentsDic objectForKey:[NSNumber numberWithInteger:[self indexOfTextField:_inputtingTextField]]] objectAtIndex:row];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIView * superView = _currentImageButton.superview;
    
    NSInteger index = superView.tag - ITEM_TAG;
    [self.fillInInfos replaceObjectAtIndex:index withObject:image];
    [_currentImageButton setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - callbacks
- (void)onDone
{
    [_inputtingTextField resignFirstResponder];
}

- (void)showPicker:(DHButton *)sender
{
    if ([DHFoundationTool deviceOperatingSystemVersion] < 8.0) {
        
        UIActionSheet * choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"取消"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self];
        
    } else {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [_currentController presentViewController:controller
                                          animated:YES
                                        completion:^(void){
                                            NSLog(@"Picker View Controller is presented");
                                        }];
            }
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [_currentController presentViewController:controller
                                          animated:YES
                                        completion:^(void){
                                            NSLog(@"Picker View Controller is presented");
                                        }];
            }
        }]];
        
        [_currentController presentViewController:alertController animated:YES completion:^{
            
        }];
        
    }
    self.currentImageButton = sender;
    
    
//    [_currentController presentViewController:_imagePickerController animated:YES completion:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
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
            for (UIView * view in self.subviews) {
                view.frame = CGRectOffset(view.frame, 0, -yOffset);
            }
//            self.frame = CGRectOffset(self.frame, 0, -yOffset);
            [self setNeedsUpdateConstraints];
        } completion:nil];
    }
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    if (willOcclusionTextField) {
//
//        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.frame = CGRectOffset(self.frame, 0, yOffset);
//            [self setNeedsUpdateConstraints];
//        } completion:^(BOOL finished) {
//            showKeyBoard = NO;
//            willOcclusionTextField = NO;
//        }];
//        
//    }
    showKeyBoard = NO;
}

- (void)change:(UISegmentedControl *)sender
{
    UIView * superView = sender.superview;
    if (!superView) {
        return;
    }
    NSInteger index = superView.tag - ITEM_TAG;
    NSDictionary * attribute = [self.attributes objectAtIndex:index];
    NSDictionary * info = [attribute objectForKey:@"typeInfo"];
    NSArray * items = [info objectForKey:@"items"];
    [self.fillInInfos replaceObjectAtIndex:index withObject:[items objectAtIndex:sender.selectedSegmentIndex]];
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [_currentController presentViewController:controller
                                      animated:YES
                                    completion:^(void){
                                        NSLog(@"Picker View Controller is presented");
                                    }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [_currentController presentViewController:controller
                                      animated:YES
                                    completion:^(void){
                                        NSLog(@"Picker View Controller is presented");
                                    }];
        }
    }
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
@end
