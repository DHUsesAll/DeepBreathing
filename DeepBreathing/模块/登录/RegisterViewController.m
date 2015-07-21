//
//  RegisterViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-17.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "RegisterViewController.h"
#import "DHNavigationBar.h"
#import "DHInfoFillInView.h"
#import "DHConvenienceAutoLayout.h"
#import "DHFoundationTool.h"
#import "KnowledgeViewController.h"

@interface RegisterViewController ()

@property (nonatomic, strong) DHInfoFillInView * infoFillInView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeAppearance];
}

- (void)initializeAppearance
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.infoFillInView];
    
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    registerButton.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(20, 400, 280, 40) adjustWidth:![DHFoundationTool iPhone4]];
    [registerButton addTarget:self action:@selector(onRegister:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setBackgroundColor:THEME_TEXT_COLOR];
    [registerButton setTitle:@"完成注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.layer.masksToBounds = YES;
    registerButton.layer.cornerRadius = 3;
    
    [self.view addSubview:registerButton];
}

- (void)onRegister:(UIButton *)sender
{
    KnowledgeViewController * controller = [[KnowledgeViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
//    if (![self.infoFillInView confirmAll]) {
//        [self.infoFillInView makeTextFieldPerformAnimation:InfoFillInAnimationTypeBadInput atIndex:0 withErrorInfo:@"请输入手机号"];
//    }
}

#pragma mark - getter
- (DHInfoFillInView *)infoFillInView
{
    if (!_infoFillInView) {
        _infoFillInView = ({
            
            NSMutableArray * attributes = [NSMutableArray arrayWithCapacity:0];
            
            NSDictionary * typeInfo = [DHInfoFillInView textFieldTypeInfoWithFillInType:kDHTextFieldFillInTypeText placeHolder:@"请输入您的手机号码" pickerComponents:@[]
                                                                               textUnit:@"" secureTextEntry:NO];
            
            [attributes addObject:[DHInfoFillInView  itemAttributeWithTitle:@"注册手机号" type:kDHInfoFillInTypeField typeInfo:typeInfo]];
            
            typeInfo = [DHInfoFillInView captchaTypeInfoWithDuration:60 captchaActionBlock:^(DHCaptchaView *captchaView) {
                // 在这里进行验证码的方法
                
                [captchaView performAnimation];
            }];
            [attributes addObject:[DHInfoFillInView itemAttributeWithTitle:@"" type:kDHInfoFillInTypeCaptcha typeInfo:typeInfo]];
            
            typeInfo = [DHInfoFillInView textFieldTypeInfoWithFillInType:kDHTextFieldFillInTypeText placeHolder:@"请输入验证码" pickerComponents:@[] textUnit:nil secureTextEntry:NO];
            
            [attributes addObject:[DHInfoFillInView itemAttributeWithTitle:@"验证码" type:kDHInfoFillInTypeField typeInfo:typeInfo]];
            
            
            typeInfo = [DHInfoFillInView textFieldTypeInfoWithFillInType:kDHTextFieldFillInTypeText placeHolder:@"请输入密码" pickerComponents:@[] textUnit:nil
                                                         secureTextEntry:YES];
            [attributes addObject:[DHInfoFillInView itemAttributeWithTitle:@"密码" type:kDHInfoFillInTypeField typeInfo:typeInfo]];
            
            
            typeInfo = [DHInfoFillInView textFieldTypeInfoWithFillInType:kDHTextFieldFillInTypeText placeHolder:@"请再次输入密码" pickerComponents:@[] textUnit:nil secureTextEntry:YES];
            
            [attributes addObject:[DHInfoFillInView itemAttributeWithTitle:@"确认密码" type:kDHInfoFillInTypeField typeInfo:typeInfo]];
            
        
            DHInfoFillInView * view = [[DHInfoFillInView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(10, 80, 300, 488) adjustWidth:![DHFoundationTool iPhone4]] fillInAttributes:attributes titleWidth:85*[DHConvenienceAutoLayout iPhone5VerticalMutiplier] unitWidth:0 itemSpacing:12*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
            
            view;
        
        });
    }
    
    return _infoFillInView;
}

@end
