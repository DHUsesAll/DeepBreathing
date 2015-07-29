//
//  AssessmentViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "AssessmentViewController.h"
#import "AssessmentDetailViewController.h"

@interface AssessmentViewController ()

@end

@implementation AssessmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAppearance];
    
}

- (void)initializeAppearance
{
    UILabel * navigationBar = [[UILabel alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 320, 64) adjustWidth:![DHFoundationTool iPhone4]]];
    navigationBar.backgroundColor = [UIColor whiteColor];
    navigationBar.text = @"评估管理";
    navigationBar.textColor = THEME_TEXT_COLOR;
    navigationBar.font = [UIFont systemFontOfSize:22*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
    navigationBar.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:navigationBar];
    
    
    UIButton * testButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [testButton setBounds:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 100, 100) adjustWidth:YES]];
    [testButton setCenter:self.view.center];
    
    [testButton addTarget:self action:@selector(onTest:) forControlEvents:UIControlEventTouchUpInside];
    
    [testButton setBackgroundColor:THEME_TEXT_COLOR];
    [[testButton layer] setMasksToBounds:YES];
    [[testButton layer] setCornerRadius:CGRectGetWidth(testButton.bounds)/2];
    
    [testButton setTitle:@"开始\n测试" forState:UIControlStateNormal];
    [testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testButton.titleLabel setFont:[UIFont systemFontOfSize:26*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]]];
    testButton.titleLabel.numberOfLines = 0;

    
    [self.view addSubview:testButton];
}


#pragma mark - button action
- (void)onTest:(UIButton *)sender
{
    [self.parentViewController.navigationController pushViewController:[[AssessmentDetailViewController alloc] initWithTitle:@"ACT评估"] animated:YES];
}





@end
