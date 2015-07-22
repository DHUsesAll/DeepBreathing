//
//  HomePageQuestionManager.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-22.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

// 抽象工具类
// 管理4个问题的显示

#import "HomePageQuestionManager.h"

#define QUESTION_WIDTH  (320*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])

#define QUESTION_HEIGTH  (568*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])

@interface HomePageQuestionManager ()

@property (nonatomic, strong) UIView * questionContainerView;

@property (nonatomic, strong) UIView * question1View;
@property (nonatomic, strong) UIView * question2View;
@property (nonatomic, strong) UIView * question3View;
@property (nonatomic, strong) UIView * question4View;

@property (nonatomic, assign) NSInteger currentQuestionIndex;

- (void)questionAnimationForIndex:(NSInteger)index;

@end

@implementation HomePageQuestionManager

+ (HomePageQuestionManager *)defaultManager
{
    //Singleton instance
    
    static HomePageQuestionManager *HPQMnager = nil;
    
    //Dispatching it once.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HPQMnager = [[self alloc] init];
    });
    
    return HPQMnager;
}

+ (CGPathRef)pathForStarting
{
    CGFloat width = QUESTION_WIDTH;
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:[DHConvenienceAutoLayout centerWithiPhone5Center:CGPointMake(0, 315)]];
    [path addQuadCurveToPoint:CGPointMake(width, 315*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]) controlPoint:CGPointMake(width/2, 470*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
    [path addLineToPoint:CGPointMake(width, 0)];
    
    return path.CGPath;
}

+ (CGPathRef)pathForEndding
{
    CGFloat height = QUESTION_HEIGTH;
    CGFloat width = QUESTION_WIDTH;
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(0, 0)];

    [bezierPath addLineToPoint:CGPointMake(0, height+185*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
    [bezierPath addQuadCurveToPoint:CGPointMake(width, height+185*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]) controlPoint:CGPointMake(width/2, height)];
    
    [bezierPath addLineToPoint:CGPointMake(width, 0)];
    
    return bezierPath.CGPath;
}

- (void)didTransitionToQuestion
{
    [self questionAnimationForIndex:0];
}

#pragma mark - getter
- (UIView *)questionContainerView
{
    if (!_questionContainerView) {
        _questionContainerView = ({
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QUESTION_WIDTH, QUESTION_HEIGTH)];
            [view addSubview:self.question1View];
            view;
        });
    }
    return _questionContainerView;
}

- (UIView *)question1View
{
    if (!_question1View) {
        _question1View = ({
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QUESTION_WIDTH, QUESTION_HEIGTH)];
            
            CAGradientLayer * gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 0, 320, 568) adjustWidth:![DHFoundationTool iPhone4]];
            gradientLayer.colors = @[(__bridge id)RGB_COLOR(246, 139, 65).CGColor,(__bridge id)RGB_COLOR(249, 210, 102).CGColor];
            
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1);
            [view.layer addSublayer:gradientLayer];
            
            
            CAShapeLayer * shapeLayer = [CAShapeLayer layer];
            
            shapeLayer.frame = CGRectMake(0, 0, QUESTION_WIDTH, QUESTION_HEIGTH*2);
            
            shapeLayer.fillColor = [UIColor redColor].CGColor;
            shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
            shapeLayer.path = [HomePageQuestionManager pathForStarting];
            gradientLayer.mask = shapeLayer;
            
            UIImageView * imageView = [[UIImageView alloc] initWithImage:IMAGE_WITH_NAME(@"question1.png")];
            imageView.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 141, 214) adjustWidth:YES];
            imageView.center = CGPointMake(view.center.x, 200*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
            [view addSubview:imageView];
            
            view;
        });
    }
    
    return _question1View;
}


#pragma mark - 私有方法

- (void)questionAnimationForIndex:(NSInteger)index
{
    if (index == 0) {
        // 路径改变动画
        
        // 取到shapeLayer
        
        NSArray * sublayers = self.question1View.layer.sublayers;
    
        CAShapeLayer * layer = sublayers[sublayers.count - 2];
        layer = (CAShapeLayer *)layer.mask;
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.fromValue = (__bridge id)[HomePageQuestionManager pathForStarting];
        
        layer.path = [HomePageQuestionManager pathForEndding];
        animation.duration = 0.65;
        
        [layer addAnimation:animation forKey:@"aaa"];
        
    }
}

@end
