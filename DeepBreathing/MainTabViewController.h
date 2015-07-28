//
//  MainTabViewController.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabViewController : UIViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@property (nonatomic, strong, readonly) NSArray * viewControllers;

@property (nonatomic, strong) NSString * strongString;
@property (nonatomic, copy) NSString * strByCopy;

@end
