//
//  DHBaseTransition.m
//  Test3D
//
//  Created by DreamHack on 14-10-10.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHBaseTransition.h"

@implementation DHBaseTransition

#pragma mark - UIViewControllerAnimatedTransitioning


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.30f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}


#pragma mark - UIViewControllerTransitioningDelegate


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{

    _presenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{

    _presenting = NO;
    return self;
}


@end
