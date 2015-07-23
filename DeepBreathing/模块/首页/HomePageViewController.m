//
//  HomePageViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "HomePageViewController.h"
#import "AppDelegate.h"
#import "HomePageQuestionManager.h"


@interface HomePageViewController ()

// 底部的渐变图层
@property (nonatomic, strong) CAGradientLayer * gradientLayer;
// 遮罩
@property (nonatomic, strong) CAShapeLayer * maskLayer;
// maskImageView下面的白色的视图
@property (nonatomic, strong) UIView * bottomView;

//
@property (nonatomic, strong) UIView * resultView;

- (void)initializeAppearance;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAppearance];
}

- (void)initializeAppearance
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:IMAGE_WITH_NAME(@"图表.png")];
    imageView.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(10, 410, 300, 105) adjustWidth:YES];
    [self.view addSubview:imageView];
    
    UIView * containerView = [[HomePageQuestionManager defaultManager] questionContainerView];
    [self.view addSubview:containerView];
    [self.view addSubview:self.resultView];
    
    UIButton * fillInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fillInButton.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 284, 100, 100) adjustWidth:YES];
    
    [fillInButton setImage:IMAGE_WITH_NAME(@"我有哮喘按钮.png") forState:UIControlStateNormal];
    [fillInButton setImage:IMAGE_WITH_NAME(@"我有哮喘按钮2.png") forState:UIControlStateHighlighted];
    fillInButton.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, fillInButton.center.y);
    [fillInButton addTarget:self action:@selector(fillIn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.resultView addSubview:fillInButton];
    
    
}

#pragma mark - getter
- (UIView *)resultView
{
    if (!_resultView) {
        _resultView = ({
        
            UIView * view = [[UIView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 0, 320, 568) adjustWidth:![DHFoundationTool iPhone4]]];
            [view.layer addSublayer:self.gradientLayer];
            self.gradientLayer.mask = self.maskLayer;
            
            view;
        
        });
    }
    return _resultView;
}


- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = ({
        
            CAGradientLayer * gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 0, 320, 568) adjustWidth:![DHFoundationTool iPhone4]];
            gradientLayer.colors = @[(__bridge id)RGB_COLOR(246, 139, 65).CGColor,(__bridge id)RGB_COLOR(249, 210, 102).CGColor];
            
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1);
            
            gradientLayer;
        
        });
    }
    
    return _gradientLayer;
}

- (CAShapeLayer *)maskLayer
{
    
    if (!_maskLayer) {
        
        _maskLayer = ({
            
            CAShapeLayer * shapeLayer = [CAShapeLayer layer];
            
            shapeLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)*2);
            
            shapeLayer.fillColor = [UIColor redColor].CGColor;
            shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
            shapeLayer.path = [HomePageQuestionManager pathForStarting];
            shapeLayer;
        });
    }
    
    return _maskLayer;
}

#pragma mark - button action
- (void)fillIn
{
    UIView * containerView = [[HomePageQuestionManager defaultManager] questionContainerView];
    [UIView animateWithDuration:1.2 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_resultView cache:NO];
    } completion:^(BOOL finished) {
        
    }];
    _resultView.hidden = YES;
    
    [UIView animateWithDuration:1.2 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:NO];
    } completion:^(BOOL finished) {
        [[HomePageQuestionManager defaultManager] didTransitionToQuestion];
    }];
}

@end
