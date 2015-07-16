//
//  DHPerspectiveTransition.m
//  Test3D
//
//  Created by DreamHack on 14-10-10.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHPerspectiveTransition.h"
#import "DHVector.h"
#define MAX_RADIAN M_PI/6

#define BASE_SCALE  .65

@implementation DHPerspectiveTransition

- (instancetype)initWithDynamicPerspectiveFocalPoint:(CGPoint)focalPoint
{
    self = [super init];
    
    _usingDynamicEffect = YES;
    _focalPoint = focalPoint;
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.8;
    
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    CATransform3D transform = fromVC.view.layer.transform;
    CATransform3D fromTransform3d = fromVC.view.layer.transform;
    if (self.usingDynamicEffect) {
        CGPoint center = fromVC.view.center;
        CGPoint position = self.focalPoint;
        
        // 将点转换成OPENGL坐标，以适配DHVector中的方法
        position = [DHVector openGLPointFromUIKitPoint:position referenceHeight:fromVC.view.bounds.size.height];
        
        center = [DHVector openGLPointFromUIKitPoint:center referenceHeight:fromVC.view.bounds.size.height];
        
        // 生成一个向量，视图将沿着这个向量旋转，注意起始点和终点不能调换
        DHVector * vector = [[DHVector alloc] initWithStartPoint:position endPoint:center];
        
        // 将向量旋转90度，该方向才是旋转轴方向
        [vector rotateAntiClockwiselyWithRadian:M_PI_2];
        
        // 获取触摸点到旋转轴的距离，也就是向量长度，距离越长，旋转的角度将越大（力矩）
        CGFloat distance = [vector length];
        
        // 最大距离为中心点到端点的距离
        
        CGFloat maxDistance = [[[DHVector alloc] initWithStartPoint:CGPointMake(0, 0) endPoint:fromVC.view.center] length];
        // 我们规定视图最大旋转量为60度，也就是M_PI/3，触摸点越接近中心，旋转度数越小
        CGFloat radiant = distance/maxDistance * MAX_RADIAN;
        
        // 将向量平移至原点，以获取其坐标表达式
        CGPoint originalPoint = [DHVector uikitPointFromOpenGLPoint:CGPointMake(0, 0) referenceHeight:fromVC.view.bounds.size.height];
        
        [vector translationToPoint:originalPoint];
        
        // 将openGL坐标转换回UIKIT坐标
        CGPoint destPoint = [DHVector uikitPointFromOpenGLPoint:vector.endPoint referenceHeight:fromVC.view.bounds.size.height];
        
        
        
        transform.m34 = -1.0 / 850;
        
        // 设置旋转轴向量，向量的坐标表达式(x,y,z)
        transform = CATransform3DRotate(transform, radiant, destPoint.x, destPoint.y, 0);
        
        // 为了让旋转看起来更和谐，当视图被触摸后，它应该稍微远离镜头（缩小），而缩小的倍数也与触摸点到中心点的距离有关
        // 以0.6倍为基数，也就是说最多缩小到0.6倍大小（不要问我为什么是0.6，我只能说因为0.6看起来比较和谐）
        // 距离越大，缩小越多
        CGFloat scaleOffset = (1 - distance/maxDistance) * 0.3; // (0 <= scaleOffset < 0.3)
        
        transform = CATransform3DScale(transform, BASE_SCALE + scaleOffset, BASE_SCALE + scaleOffset, BASE_SCALE + scaleOffset);
        
        
        
    } else {
        transform = [self defaultTransformNeedRotate:NO];
    }
    toVC.view.layer.transform = transform;
    toVC.view.alpha = 0;
    [UIView animateWithDuration:1.1 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        fromVC.view.layer.transform = transform;
        [fromVC.view updateConstraintsIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    [UIView animateWithDuration:0.45 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [toVC.view setAlpha:1];
        [fromVC.view setAlpha:0];
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:1.0 delay:0.8 usingSpringWithDamping:1.0 initialSpringVelocity:17 options:UIViewAnimationOptionCurveEaseIn animations:^{
        toVC.view.layer.transform = fromTransform3d;
        [toVC.view updateConstraintsIfNeeded];
        
    } completion:^(BOOL finished) {
        //            [fromVC.view setAlpha:1];
        [transitionContext completeTransition:YES];
    }];
}


- (CATransform3D)defaultTransformNeedRotate:(BOOL)rotate
{
    CATransform3D transform3d = CATransform3DIdentity;
    
    if (rotate) {
        transform3d.m34 = .008;
        transform3d = CATransform3DScale(transform3d, .4, .4, .4);
        transform3d = CATransform3DRotate(transform3d,M_PI_4/4, .01f, -1.f, -1.0f);
        
        transform3d = CATransform3DTranslate(transform3d, (-30.f)/.3f, (3.f)/.3f, -10.f/.3f);
    } else {
        transform3d = CATransform3DScale(transform3d, .85, .85, .85);
    }
    
    return transform3d;
}


@end
