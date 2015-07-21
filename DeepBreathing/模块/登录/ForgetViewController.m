//
//  ForgetViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-20.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "ForgetViewController.h"
#import "DHInfoFillInView.h"
#import "DHConvenienceAutoLayout.h"
#import "DHFoundationTool.h"

@interface ForgetViewController ()

@property (nonatomic, strong) DHInfoFillInView * infoFillInView;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.infoFillInView];
}

#pragma mark - getter
- (DHInfoFillInView *)infoFillInView
{
    if (!_infoFillInView) {
        _infoFillInView = ({
            
            NSMutableArray * attributes = [NSMutableArray arrayWithCapacity:0];
            
            NSDictionary * typeInfo = [DHInfoFillInView textFieldTypeInfoWithFillInType:kDHTextFieldFillInTypeText placeHolder:@"请输入您的手机号码" pickerComponents:@[] textUnit:nil secureTextEntry:NO];
            
            [attributes addObject:[DHInfoFillInView itemAttributeWithTitle:@"手机号" type:kDHInfoFillInTypeField typeInfo:typeInfo]];
            
            typeInfo = [DHInfoFillInView captchaTypeInfoWithDuration:60 captchaActionBlock:^(DHCaptchaView *captchaView) {
                
                [captchaView performAnimation];
                
            }];
            
            [attributes addObject:[DHInfoFillInView itemAttributeWithTitle:@"" type:kDHInfoFillInTypeCaptcha typeInfo:typeInfo]];
            
            typeInfo = [DHInfoFillInView textFieldTypeInfoWithFillInType:kDHTextFieldFillInTypeText placeHolder:@"请输入验证码" pickerComponents:@[] textUnit:nil
                                                         secureTextEntry:NO];
            
            [attributes addObject:[DHInfoFillInView itemAttributeWithTitle:@"验证码" type:kDHInfoFillInTypeField typeInfo:typeInfo]];
        
            DHInfoFillInView * view = [[DHInfoFillInView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(10, 80, 300, 400) adjustWidth:![DHFoundationTool iPhone4]] fillInAttributes:attributes titleWidth:81 unitWidth:0 itemSpacing:20*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
            
            view;
        
        
        });
    }
    return _infoFillInView;
}

@end
