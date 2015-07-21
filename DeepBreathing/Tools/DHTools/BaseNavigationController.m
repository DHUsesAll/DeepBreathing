//
//  BaseNavigationController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-20.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "BaseNavigationController.h"
#import "DHNavigationBar.h"


@interface BaseNavigationController ()

@property (nonatomic, strong) NSString * navigationBarTitle;

@end

@implementation BaseNavigationController

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.navigationBarTitle = title;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    DHNavigationBar * navigationBar = [[DHNavigationBar alloc] initWithTitle:_navigationBarTitle];
    
    [self.view addSubview:navigationBar];
    
    DHNavigationBarItem * leftButton = [DHNavigationBarItem buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(onLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:IMAGE_WITH_NAME(@"返回.png") forState:UIControlStateNormal];
    
    navigationBar.leftBarButtonItem = leftButton;
}

- (void)onLeftButton:(UIButton *)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}






@end
