//
//  DHSystemAppNavigationTransition.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-16.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHSystemAppNavigationTransition.h"
#import "DHFoundationTool.h"

@interface DHSystemAppNavigationTransition ()



@end

@implementation DHSystemAppNavigationTransition
{
    CGRect frame;
}

- (instancetype)initWithFromFrame:(CGRect)fromFrame
{
    self = [super init];
    self.fromFrame = fromFrame;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView * containerView = [transitionContext containerView];
    
    
    CGFloat scaleH = fromVC.view.frame.size.width / _fromFrame.size.width;
    CGFloat scaleV = fromVC.view.frame.size.height / _fromFrame.size.height;
    
    if (self.operation == UINavigationControllerOperationPop) {
        [containerView addSubview:toVC.view];
        [containerView addSubview:fromVC.view];
        toVC.view.frame = frame;
//        [UIView animateWithDuration:0.35 animations:^{
//            fromVC.view.alpha = 0;
//            
//            toVC.view.transform = fromVC.view.transform;
//            toVC.view.center = fromVC.view.center;
//            fromVC.view.layer.transform = CATransform3DScale(fromVC.view.layer.transform, 1/((scaleV+scaleH)/2), 1/((scaleV+scaleH)/2), 1);
//            fromVC.view.layer.position = [DHFoundationTool centerWithFrame:_fromFrame];
//            [toVC.view updateConstraintsIfNeeded];
//            [fromVC.view updateConstraintsIfNeeded];
//        } completion:^(BOOL finished) {
//            [transitionContext completeTransition:YES];
//        }];
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toVC.view.transform = CGAffineTransformScale(toVC.view.transform, 1/((scaleV+scaleH)/2), 1/((scaleV+scaleH)/2));
            toVC.view.center = fromVC.view.center;
            fromVC.view.alpha = 0;
            fromVC.view.transform = CGAffineTransformScale(fromVC.view.transform, 1/((scaleV+scaleH)/2), 1/((scaleV+scaleH)/2));
            fromVC.view.center = [DHFoundationTool centerWithFrame:_fromFrame];
            [toVC.view updateConstraintsIfNeeded];
            [fromVC.view updateConstraintsIfNeeded];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
//        [UIView animateWithDuration:0.65 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            
//        } completion:nil];
        
        [UIView animateWithDuration:0.1 animations:^{
            fromVC.view.alpha = 0;
        }];
        
        
    } else if (self.operation == UINavigationControllerOperationPush) {
        [containerView addSubview:fromVC.view];
        [containerView addSubview:toVC.view];
        CGAffineTransform transform = toVC.view.transform;
        toVC.view.transform = CGAffineTransformScale(toVC.view.transform, 1/((scaleV+scaleH)/2), 1/((scaleV+scaleH)/2));
        toVC.view.center = [DHFoundationTool centerWithFrame:_fromFrame];
        toVC.view.alpha = 0;
        CGFloat xOffset = (scaleV+scaleH)/2 * (toVC.view.layer.position.x - fromVC.view.layer.position.x);
        CGFloat yOffset = (scaleV+scaleH)/2 * (toVC.view.layer.position.y - fromVC.view.layer.position.y);
        
//        [UIView animateWithDuration:0.35 animations:^{
//            toVC.view.transform = transform;
//            toVC.view.center = fromVC.view.center;
//            fromVC.view.transform = CGAffineTransformScale(fromVC.view.transform, (scaleV+scaleH)/2, (scaleV+scaleH)/2);
//            fromVC.view.center = CGPointMake(fromVC.view.center.x - xOffset, fromVC.view.center.y - yOffset);
//            toVC.view.alpha = 1;
//            [toVC.view updateConstraintsIfNeeded];
//            [fromVC.view updateConstraintsIfNeeded];
//        } completion:^(BOOL finished) {
//            frame = fromVC.view.frame;
//            [transitionContext completeTransition:YES];
//        }];
        
        [UIView animateWithDuration:0.1 animations:^{
            toVC.view.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toVC.view.transform = transform;
            toVC.view.center = fromVC.view.center;
            
//            toVC.view.alpha = 1;
            [toVC.view updateConstraintsIfNeeded];
            
        } completion:^(BOOL finished) {
            frame = fromVC.view.frame;
            [transitionContext completeTransition:YES];
        }];
        
        [UIView animateWithDuration:0.85 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            fromVC.view.transform = CGAffineTransformScale(fromVC.view.transform, (scaleV+scaleH)/2, (scaleV+scaleH)/2);
            fromVC.view.center = CGPointMake(fromVC.view.center.x - xOffset, fromVC.view.center.y - yOffset);
            [fromVC.view updateConstraintsIfNeeded];
        } completion:nil];
        
    }
}

//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
//{
//    if ([DHFoundationTool deviceOperatingSystemVersion] < 8.0) {
//        return nil;
//    }
//    return self.percentDrivenInteractiveTransition;
//}

@end
