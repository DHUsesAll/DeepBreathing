//
//  DHNavigationBaseTransition.m
//  Test3D
//
//  Created by DreamHack on 14-10-13.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHNavigationBaseTransition.h"

@implementation DHNavigationBaseTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.30f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    _operation = operation;
    return self;
}



@end
