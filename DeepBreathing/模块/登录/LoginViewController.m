//
//  LoginViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "LoginViewController.h"
#import "DHConvenienceAutoLayout.h"
#import "RegisterViewController.h"
#import "DHFoundationTool.h"
#import "HelpViewController.h"
#import "ForgetViewController.h"
//#import "HomePageViewController.h"
#import "MainTabViewController.h"
#import "DHDrawerViewController.h"
#import "LeftViewController.h"
#import "NetworkingManager+Login.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField * usernameField;
@property (nonatomic, strong) UITextField * passwordField;
@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAppearance];
}

// 绘制所有的视图
- (void)initializeAppearance
{
    self.view.backgroundColor = [UIColor whiteColor];
    // 隐藏navigationBar
//    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    // 橙色背景图
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 320, 384) adjustWidth:YES]];
    imageView.image = IMAGE_WITH_NAME(@"登录橘色背景图.png");
    [self.view addSubview:imageView];
    
    
    self.imageView = imageView;
    
    // 注册
    UIButton * registerButton = [self buttonWithFrame:CGRectMake(25, 530, 40, 18) title:@"注册" action:@selector(onRegister:)];
    [self.view addSubview:registerButton];
    
    // 输入框
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    
    // 帮助按钮
    UIButton * helpButton = [self buttonWithFrame:CGRectMake(260, 530, 40, 18) title:@"帮助" action:@selector(onHelp:)];
    
    [self.view addSubview:helpButton];

    // 忘记密码
    UIButton * forgetButton = [self buttonWithFrame:CGRectMake(82, 297, 65, 16) title:@"忘记密码" action:@selector(onForget:)];
    [forgetButton setTintColor:[UIColor whiteColor]];
    [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:16*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]]];
    [self.view addSubview:forgetButton];
    
    // 登录
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setImage:IMAGE_WITH_NAME(@"登录按钮点击前.png") forState:UIControlStateNormal];
    [loginButton setImage:IMAGE_WITH_NAME(@"登录按钮点击后.png") forState:UIControlStateHighlighted];
    loginButton.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 327, 125, 150) adjustWidth:YES];
    loginButton.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, loginButton.center.y);
    
    [loginButton addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
}


#pragma mark - getter
- (UITextField *)usernameField
{
    if (!_usernameField) {
        _usernameField = ({
        
            UITextField * field = [self textFieldWithFrame:CGRectMake(80, 204, 180, 36) placeholder:@"请输入您的手机号"];
            field;
        
        });
    }
    return _usernameField;
}

- (UITextField *)passwordField
{
    if (!_passwordField) {
        _passwordField = ({
        
            UITextField * field = [self textFieldWithFrame:CGRectMake(80, 246, 180, 36) placeholder:@"请输入密码"];
            
            field;
        
        });
    }
    
    return _passwordField;
}

#pragma mark - 按钮点击事件

- (void)onLogin:(UIButton *)sender
{
    [NetworkingManager loginWithUserName:_usernameField.text password:_passwordField.text successHandler:^(id responseObj) {
        
        
        
        [UserModel defaultUser].phoneNumber = _usernameField.text;
        [UserModel defaultUser].password = _passwordField.text;
        
        [self presentToMainViewController];
    } failureHandler:^(NSError *error) {
        
    }];
}

- (void)onRegister:(UIButton *)sender
{
    RegisterViewController * controller = [[RegisterViewController alloc] initWithTitle:@"注册"];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)onForget:(UIButton *)sender
{
    ForgetViewController * controller = [[ForgetViewController alloc] initWithTitle:@"忘记密码"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onHelp:(UIButton *)sender
{
    [self.navigationController pushViewController:[[HelpViewController alloc] initWithTitle:@"帮助"] animated:YES];
}

#pragma mark - 私有方法

- (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
    UITextField * field = [[UITextField alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:frame adjustWidth:![DHFoundationTool iPhone4]]];
    
    field.placeholder = placeholder;
    [field setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    field.leftView = [[UIView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 10, 36) adjustWidth:![DHFoundationTool iPhone4]]];
    
    field.leftViewMode = UITextFieldViewModeAlways;
    
    field.layer.borderColor = [UIColor whiteColor].CGColor;
    field.layer.borderWidth = 1;
    return field;

}



- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale | DHAutoLayoutOptionPosition iPhone5Frame:frame adjustWidth:YES];
    button.titleLabel.font = [UIFont systemFontOfSize:18*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
    [button setTintColor:THEME_TEXT_COLOR];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)presentToMainViewController
{
    // 各个模块controller的类名
    NSArray * controllerClassNames = @[@"HomePageViewController",@"AssessmentViewController",@"MedicineViewController",@"KnowledgeViewController",@"AttendanceViewController"];
    
    // 传给tabController的controller数组
    NSMutableArray * controllerArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString * className in controllerClassNames) {
        // 通过类名初始化controller
        UIViewController * controller = [[NSClassFromString(className) alloc] init];
        [controllerArray addObject:controller];
        
    }
    
    
    // 初始化tabController
    MainTabViewController * mainViewController = [[MainTabViewController alloc] initWithViewControllers:controllerArray];
    
    
    // 初始化抽屉controller
    // 因为某一个子controller push的效果是把整个tabController进行push，所以要把tabController作为一个navigationController的rootController
    UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    naVC.navigationBar.hidden = YES;
    
    DHDrawerViewController * drawerViewController = [[DHDrawerViewController alloc] initWithMainViewContorller:naVC leftViewController:[[LeftViewController alloc] init] rightViewController:nil];
    
    [self.navigationController presentViewController:drawerViewController animated:YES completion:nil];

}

@end
