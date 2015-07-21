//
//  HomePageViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "HomePageViewController.h"


@interface HomePageViewController ()

// 底部的渐变图层
@property (nonatomic, strong) CAGradientLayer * gradientLayer;
// 遮罩
@property (nonatomic, strong) CALayer * maskImageView;
// maskImageView下面的白色的视图
@property (nonatomic, strong) UIView * bottomView;

- (void)initializeAppearance;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAppearance];
}

- (void)initializeAppearance
{
    [self.view.layer addSublayer:self.gradientLayer];
    [self.view.layer addSublayer:self.maskImageView];
    [self.view addSubview:self.bottomView];
    
    UIButton * fillInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fillInButton.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 284, 100, 100) adjustWidth:YES];
    
    [fillInButton setImage:IMAGE_WITH_NAME(@"我有哮喘按钮.png") forState:UIControlStateNormal];
    [fillInButton setImage:IMAGE_WITH_NAME(@"我有哮喘按钮2.png") forState:UIControlStateHighlighted];
    fillInButton.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, fillInButton.center.y);
    [fillInButton addTarget:self action:@selector(fillIn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:fillInButton];
    
}

#pragma mark - getter
- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = ({
        
            CAGradientLayer * gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 0, 320, 385) adjustWidth:![DHFoundationTool iPhone4]];
            gradientLayer.colors = @[(__bridge id)[UIColor orangeColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor];
            
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 568.f/385.f);
            
            gradientLayer;
        
        });
    }
    
    return _gradientLayer;
}

- (CALayer *)maskImageView
{
    if (!_maskImageView) {
        _maskImageView = ({
        
            CALayer * layer = [CALayer layer];
            
            layer.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 315, 320, 70) adjustWidth:![DHFoundationTool iPhone4]];
            
            UIImage * image = IMAGE_WITH_NAME(@"背景图遮罩.png");
            layer.contents = (__bridge id)image.CGImage;
            
            layer;
        
        });
    }
    
    return _maskImageView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = ({
        
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 385, 320, 568-385-50)];
            view.backgroundColor = [UIColor whiteColor];
            
            view;
        });
    }
    
    return _bottomView;
}

#pragma mark - button action
- (void)fillIn
{
    CATransition * transition = [CATransition animation];
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromLeft;
    transition.duration = 0.8;
    transition.delegate = self;
    [self.gradientLayer addAnimation:transition forKey:@"aaa"];
    
    self.gradientLayer.frame = [UIScreen mainScreen].bounds;
}

#pragma mark - 系统的delegate方法
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    
    CABasicAnimation * maskAnimation = [CABasicAnimation animation];
    maskAnimation.keyPath = @"transform";
    maskAnimation.duration = 0.8;
    maskAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    _maskImageView.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
//    [_maskImageView addAnimation:maskAnimation forKey:@""];
    
    CABasicAnimation * maskTranslationAnimation = [CABasicAnimation animation];
    maskTranslationAnimation.duration = 0.8;
    maskTranslationAnimation.keyPath = @"position";
    maskTranslationAnimation.fromValue = [NSValue valueWithCGPoint:_maskImageView.position];
    _maskImageView.position = CGPointMake(_maskImageView.position.x, CGRectGetHeight(self.view.bounds)+50+CGRectGetHeight(_maskImageView.bounds)/2);
//    [_maskImageView addAnimation:maskTranslationAnimation forKey:@""];
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = @[maskAnimation,maskTranslationAnimation];
    [_maskImageView addAnimation:group forKey:@"aaa"];
    
    
//    [UIView animateWithDuration:0.8 animations:^{
//        _bottomView.frame = CGRectMake(0, 568*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 320*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 0);
//    }];
}

@end
