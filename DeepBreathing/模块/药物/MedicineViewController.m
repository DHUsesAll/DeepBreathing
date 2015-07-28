//
//  MedicineViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "MedicineViewController.h"

@interface MedicineViewController ()

@end

@implementation MedicineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAppearance];
}

- (void)initializeAppearance
{
    UILabel * navigationBar = [[UILabel alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 320, 64) adjustWidth:![DHFoundationTool iPhone4]]];
    navigationBar.backgroundColor = [UIColor whiteColor];
    navigationBar.text = @"哮喘知识";
    navigationBar.textColor = THEME_TEXT_COLOR;
    navigationBar.font = [UIFont systemFontOfSize:22*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
    navigationBar.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:navigationBar];
}


@end
