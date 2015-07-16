//
//  DHNavigationBaseTransition.h
//  Test3D
//
//  Created by DreamHack on 14-10-13.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DHNavigationBaseTransition : NSObject<UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate>

@property (nonatomic, readwrite, assign) UINavigationControllerOperation operation;

@end

