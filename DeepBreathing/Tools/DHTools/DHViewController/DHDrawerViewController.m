//
//  DHDrawerViewController.m
//  HH
//
//  Created by DreamHack on 15-7-11.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHDrawerViewController.h"

#define DRAWER_ANIMATION_DURATION   0.45
#define TRANSLATION_WIDTH   200
#define SPRING_DRAMPING     0.6
#define SPRING_VELOCITY     8

@interface DHDrawerViewController ()


@property (nonatomic, strong) UIViewController * mainViewController;
@property (nonatomic, strong) UIViewController * leftViewController;
@property (nonatomic, strong) UIViewController * rightViewController;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer * leftPanGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer * rightPanGesture;


// 当我们的手指的方向正确时，手指的移动才能控制抽屉动画显示的进程
@property (nonatomic, assign) BOOL shouldBeginAnimation;

// 抽屉出来后，用这个view盖在mainVC上面响应关闭抽屉的手势
@property (nonatomic, strong) UIView * maskGestureView;

- (void)initializeAppearance;
- (void)removeChildViewController:(UIViewController *)childController;
- (void)onLeftPanGesture:(UIPanGestureRecognizer *)gesture;
- (void)onRightPanGesture:(UIPanGestureRecognizer *)gesture;
- (CGFloat)interpolateFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent;

- (void)addMaskView;
- (void)removeMaskView;

// 抽屉打开与关闭的动画
- (void (^)(void))drawerOpenAnimationWithDrawerView:(UIView *)drawerView;
- (void (^)(void))drawerCloseAnimationWithDrawerView:(UIView *)drawerView;

// 通过手指的百分比控制动画
- (void)handleAnimationWithPercent:(CGFloat)percent forView:(UIView *)view;


@end

@implementation DHDrawerViewController

#pragma mark - initialize
- (instancetype)initWithMainViewContorller:(UIViewController *)mainVC leftViewController:(UIViewController *)leftVC rightViewController:(UIViewController *)rightVC
{
    self = [super init];
    if (self) {
        self.mainViewController = mainVC;
        self.leftViewController = leftVC;
        self.rightViewController = rightVC;
    }
    return self;
}

- (void)initializeAppearance
{
    if (self.leftViewController) {
        [self addChildViewController:self.leftViewController];
        self.leftViewController.view.alpha = 0;
//        self.leftViewController.view.frame = CGRectMake(0, 0, TRANSLATION_WIDTH, CGRectGetHeight(self.leftViewController.view.bounds));
    }
    if (self.rightViewController) {
        [self addChildViewController:self.rightViewController];
        self.rightViewController.view.alpha = 0;
    }
    if (self.mainViewController) {
        [self addChildViewController:self.mainViewController];
    }
    [self.view addGestureRecognizer:self.leftPanGesture];
    [self.view addGestureRecognizer:self.rightPanGesture];
}

#pragma mark - 重写方法

- (void)dealloc
{
    if (self.leftViewController) {
        [self removeChildViewController:self.leftViewController];
        self.leftViewController = nil;
    }
    if (self.rightViewController) {
        [self removeChildViewController:self.rightViewController];
        self.rightViewController = nil;
    }
    if (self.mainViewController) {
        [self removeChildViewController:self.mainViewController];
        self.mainViewController = nil;
    }
}

- (void)addChildViewController:(UIViewController *)childController
{
    [super addChildViewController:childController];
    [childController didMoveToParentViewController:self];
    [self.view addSubview:childController.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAppearance];
    
}

#pragma mark - getter
- (UIScreenEdgePanGestureRecognizer *)leftPanGesture
{
    if (!_leftPanGesture) {
        _leftPanGesture = ({
        
            UIScreenEdgePanGestureRecognizer * gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(onLeftPanGesture:)];
            gesture.edges = UIRectEdgeLeft;
            gesture;
            
        });
    }
    return _leftPanGesture;
}

- (UIScreenEdgePanGestureRecognizer *)rightPanGesture
{
    if (!_rightPanGesture) {
        _rightPanGesture = ({
        
            UIScreenEdgePanGestureRecognizer * gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(onRightPanGesture:)];
            gesture.edges = UIRectEdgeRight;
            gesture;
        
        });
    }
    return _rightPanGesture;
}

#pragma mark - 私有方法
- (void)removeChildViewController:(UIViewController *)childController
{
    [childController.view removeFromSuperview];
    [childController removeFromParentViewController];
    [childController willMoveToParentViewController:nil];
}

- (void)onLeftPanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if ([gesture velocityInView:self.view].x < 0) {
            return;
        }
        
        // 接下来在手指移动的时候可以动画
        _shouldBeginAnimation = YES;
        _leftViewController.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        if (!_shouldBeginAnimation) {
            return;
        }
        // 当前手指距离屏幕左边的距离
        CGFloat offsetX = [gesture translationInView:self.view].x;
        
        // 距离占屏幕宽度的百分比（用来表示动画进行的百分比）
        CGFloat percent = offsetX/CGRectGetWidth(self.view.bounds);
        
        [self handleAnimationWithPercent:percent forView:_leftViewController.view];
        
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        // 速度向左，则关闭抽屉
        if ([gesture velocityInView:self.view].x < 0) {
            [UIView animateWithDuration:DRAWER_ANIMATION_DURATION delay:0 usingSpringWithDamping:SPRING_DRAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:[self drawerCloseAnimationWithDrawerView:_leftViewController.view] completion:^(BOOL finished) {
                // 移除maskView
                [self removeMaskView];
                _shouldBeginAnimation = NO;
            }];
        } else {
            
            // 动画打开抽屉
            [UIView animateWithDuration:DRAWER_ANIMATION_DURATION delay:0 usingSpringWithDamping:SPRING_DRAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:[self drawerOpenAnimationWithDrawerView:_leftViewController.view] completion:^(BOOL finished) {
                // 添加maskView
                [self addMaskView];
                _shouldBeginAnimation = NO;
            }];
        }
        
        
    }
}

- (void)onRightPanGesture:(UIPanGestureRecognizer *)gesture
{
    
}

- (CGFloat)interpolateFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    return from + (to - from) * percent;
}

// 通过手指的百分比控制动画
- (void)handleAnimationWithPercent:(CGFloat)percent forView:(UIView *)view
{
    // 对center进行插值
    CGFloat x = [self interpolateFrom:CGRectGetWidth(self.view.bounds)/2 to:CGRectGetWidth(self.view.bounds) percent:percent];
    
    // 重新设置center
    _mainViewController.view.center = CGPointMake(x, _mainViewController.view.center.y);
    
    // 对抽屉视图缩放大小进行插值
    CGFloat scaleB = [self interpolateFrom:0.8 to:1 percent:percent];
    
    // 对抽屉式图center进行插值
    //    CGFloat xB = [self interpolateFrom:0 to:CGRectGetWidth(self.view.bounds)/2 percent:percent];
    
    view.transform = CGAffineTransformMakeScale(scaleB, scaleB);
    
    // 对抽屉视图alpha进行插值
    CGFloat alpha = [self interpolateFrom:0.6 to:1 percent:percent];
    view.alpha = alpha;
}

#pragma mark - 抽屉打开与关闭的动画

// 抽屉打开动画
// 主要视图缩小到0.7倍，并且center.x移到屏幕的右边界
// left大小还原，center到屏幕中心， alpha为1
- (void (^)(void))drawerOpenAnimationWithDrawerView:(UIView *)drawerView
{
    void (^animationBlock)(void);
    animationBlock = ^void(void) {
        _mainViewController.view.center = CGPointMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)/2);
        
        drawerView.transform = CGAffineTransformMakeScale(1, 1);
//        drawerView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2);
        drawerView.alpha = 1;
    };
    return animationBlock;
}

// 抽屉关闭动画
// 缩放和center全部还原到原来的大小和位置
- (void (^)(void))drawerCloseAnimationWithDrawerView:(UIView *)drawerView
{
    void (^animationBlock)(void);
    animationBlock = ^void(void) {
        _mainViewController.view.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2);
        
        drawerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
//        drawerView.center = CGPointMake(0, CGRectGetHeight(self.view.bounds)/2);
        drawerView.alpha = 0.6;
    };
    return animationBlock;
}

#pragma mark - mask view相关方法
// 添加maskView
- (void)addMaskView
{
    if (!_maskGestureView) {
        self.maskGestureView = [[UIView alloc] initWithFrame:_mainViewController.view.frame];
        [self.maskGestureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)]];
        [self.maskGestureView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)]];
        [self.view addSubview:self.maskGestureView];
    }
}

// 移除maskView
- (void)removeMaskView
{
    if (self.maskGestureView) {
        [self.maskGestureView removeFromSuperview];
        self.maskGestureView = nil;
    }
}


// 点击到maskGestureView上面。动画关闭抽屉
- (void)onTap:(UIGestureRecognizer *)gesture
{
    [UIView animateWithDuration:DRAWER_ANIMATION_DURATION delay:0 usingSpringWithDamping:SPRING_DRAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:[self drawerCloseAnimationWithDrawerView:_leftViewController.view] completion:^(BOOL finished) {
        [self removeMaskView];
    }];
}

// 打开抽屉后，拖动主要视图的响应手势（该手势实际上加在maskView上的）
- (void)onPan:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([sender velocityInView:self.view].x > 0) {
            return;
        }
        _shouldBeginAnimation = YES;
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (!_shouldBeginAnimation) {
            return;
        }
        
        // 手指的位移
        CGFloat offsetX = [sender translationInView:self.view].x;
        
        if (offsetX > 0) {
            return;
        }
        
        // 距离占屏幕宽度的百分比（用来表示动画进行的百分比）
        // fabs是取绝对值的函数
        CGFloat percent = 1-fabs(offsetX)/TRANSLATION_WIDTH;
        
        [self handleAnimationWithPercent:percent forView:_leftViewController.view];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        // 速度向左，则关闭抽屉
        if ([sender velocityInView:self.view].x < 0) {
            
            [UIView animateWithDuration:DRAWER_ANIMATION_DURATION delay:0 usingSpringWithDamping:SPRING_DRAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:[self drawerCloseAnimationWithDrawerView:_leftViewController.view] completion:^(BOOL finished) {
                // 移除maskView
                [self removeMaskView];
                _shouldBeginAnimation = NO;
            }];
            
        } else {
            
            // 动画打开抽屉
            [UIView animateWithDuration:DRAWER_ANIMATION_DURATION delay:0 usingSpringWithDamping:SPRING_DRAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:[self drawerOpenAnimationWithDrawerView:_leftViewController.view] completion:^(BOOL finished) {
                // 添加maskView
                [self addMaskView];
                _shouldBeginAnimation = NO;
            }];
        }
        
        
    }
    
}


@end
