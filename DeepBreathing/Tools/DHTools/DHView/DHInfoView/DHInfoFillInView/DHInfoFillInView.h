//
//  DHInfoFillInView.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-21.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHCaptchaView.h"

typedef enum {
    
    InfoFillInAnimationTypeFocus,
    InfoFillInAnimationTypeBadInput
    
} InfoFillInAnimationType;

typedef enum {
    
    InfoFillInReloadAnimationTypeNone,
    InfoFillInReloadAnimationTypeFade,
    InfoFillInReloadAnimationTypeFly
    
} InfoFillInReloadAnimationType;

@class DHInfoFillInView;

@protocol DHInfoFillInViewDataSource <NSObject>

- (NSInteger)numberOfItemsInInfoFillInView:(DHInfoFillInView *)infoFillInView;
- (NSDictionary *)attributeForItemAtIndex:(NSInteger)index inInfoFillInView:(DHInfoFillInView *)infoFillInView;
- (CGFloat)spacingAtSpacingIndex:(NSInteger)index inInfoFillInView:(DHInfoFillInView *)infoFillInView;
- (CGFloat)titleWidthForItemAtIndex:(NSInteger)index inInfoFillInView:(DHInfoFillInView *)infoFillInView;
- (CGFloat)unitWidthForItemAtIndex:(NSInteger)index inInfoFillInView:(DHInfoFillInView *)infoFillInView;

@end

@protocol DHInfoFillInViewDelegate <NSObject>

@optional

- (void)infoFillInView:(DHInfoFillInView *)infoFillInView didEndEditingTextFieldAtIndex:(NSInteger)index;
- (void)infoFillInView:(DHInfoFillInView *)infoFillInView didBeginEditingTextFieldWithInputView:(UIView *)inputView atIndex:(NSInteger)index;

@end


@interface DHInfoFillInView : UIView

@property (nonatomic, weak) id <DHInfoFillInViewDataSource> dataSource;
@property (nonatomic, weak) id <DHInfoFillInViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame fillInAttributes:(NSArray *)attributes titleWidth:(CGFloat)titleWidth unitWidth:(CGFloat)unitWidth itemSpacing:(CGFloat)spacing;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id <DHInfoFillInViewDataSource>)dataSource;

#pragma mark - attributes constructor

+ (NSDictionary *)itemAttributeWithTitle:(NSString *)title type:(NSString *)type typeInfo:(NSDictionary *)typeInfo;

+ (NSDictionary *)textFieldTypeInfoWithFillInType:(NSString *)type placeHolder:(NSString *)placeHolder pickerComponents:(NSArray *)components textUnit:(NSString *)unit secureTextEntry:(BOOL)flag;

+ (NSDictionary *)radioButtonTypeInfoWithItems:(NSArray *)items selectedIndex:(NSInteger)index;

+ (NSDictionary *)captchaTypeInfoWithDuration:(CGFloat)duration captchaActionBlock:(DHCaptchaActionBlock)actionBlock;

+ (NSDictionary *)photoTypeInfoWithDefaultImagePath:(NSString *)defaultImagePath pickerDelegate:(id <UINavigationBarDelegate, UIImagePickerControllerDelegate>)delegate currentController:(UIViewController *)controller;

#pragma mark - interface
- (BOOL)confirmAll;

- (NSMutableArray *)fillInInfos;

- (UITextField *)textFieldAtIndex:(NSInteger)index;
- (UISegmentedControl *)itemViewAtIndex:(NSInteger)index;

//- (void)makeTextFieldPerformAnimation:(InfoFillInAnimationType)animationType atIndex:(NSInteger)index;
- (void)makeTextFieldPerformAnimation:(InfoFillInAnimationType)animationType atIndex:(NSInteger)index withErrorInfo:(NSString *)errorInfo;
- (void)makeViewPerformAnimation:(InfoFillInAnimationType)animationType atIndex:(NSInteger)index;
- (void)makeCaptchaPerformAnimationAtIndex:(NSInteger)index;

- (void)reloadViewsWithAttributes:(NSArray *)attributes titleWidth:(CGFloat)titleWidth unitWidth:(CGFloat)unitWidth itemSpacing:(CGFloat)spacing;

- (void)reloadViewsWithCompletionImage:(UIImage *)image imageSize:(CGSize)size;

- (void)hideKeyBorad;
- (void)hideErrorMessage;

@end

extern NSString * const kDHInfoFillInTypeField;             // 输入框
extern NSString * const kDHInfoFillInTypeRadioButton;       // 单选
extern NSString * const kDHInfoFillInTypeCaptcha;           // 验证码
extern NSString * const kDHInfoFillInTypePhoto;             // 照片
extern NSString * const kDHInfoFillInTypeBlank;             // 留白

extern NSString * const kDHTextFieldFillInTypeText;         // 文本输入
extern NSString * const kDHTextFieldFillInTypeControl;      // 控件输入



