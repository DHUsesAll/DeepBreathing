//
//  DHDrawerViewController.h
//  HH
//
//  Created by DreamHack on 15-7-11.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    暂时只能添加left
*/

@interface DHDrawerViewController : UIViewController

// 主要VC
@property (nonatomic, strong, readonly) UIViewController * mainViewController;
// 左边的抽屉
@property (nonatomic, strong, readonly) UIViewController * leftViewController;

// 右边的抽屉
@property (nonatomic, strong, readonly) UIViewController * rightViewController;

// 可以给手势设置delegate
@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer * leftPanGesture;
@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer * rightPanGesture;


- (instancetype)initWithMainViewContorller:(UIViewController *)mainVC leftViewController:(UIViewController *)leftVC rightViewController:(UIViewController *)rightVC;



@end
