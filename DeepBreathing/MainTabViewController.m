//
//  MainTabViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "MainTabViewController.h"

@interface MainTabViewController ()

@property (nonatomic, strong) NSArray * viewControllers;

@end

@implementation MainTabViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        self.viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)initialize
{
    
}

@end
