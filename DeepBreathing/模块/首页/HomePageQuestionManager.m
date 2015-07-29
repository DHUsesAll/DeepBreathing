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
#import "QuestionBaseView.h"

#define QUESTION_WIDTH  (320*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])

#define QUESTION_HEIGTH  (568*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])

@interface HomePageQuestionManager ()

@property (nonatomic, strong) UIView * questionContainerView;

@property (nonatomic, strong) QuestionBaseView * question1View;
@property (nonatomic, strong) QuestionBaseView * question2View;
@property (nonatomic, strong) QuestionBaseView * question3View;
@property (nonatomic, strong) QuestionBaseView * question4View;

@property (nonatomic, strong) UIButton * noButton;
@property (nonatomic, strong) UIButton * yesButton;

@property (nonatomic, assign) NSInteger currentQuestionIndex;

- (void)questionAnimationForIndex:(NSInteger)index;

@end

@implementation HomePageQuestionManager

+ (HomePageQuestionManager *)defaultManager
{
    //Singleton instance
    
    static HomePageQuestionManager *HPQManager = nil;
    
    //Dispatching it once.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HPQManager = [[self alloc] init];
    });
    
    return HPQManager;
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
    [self.questionContainerView addSubview:self.yesButton];
    [self.questionContainerView addSubview:self.noButton];
}

#pragma mark - getter
- (UIView *)questionContainerView
{
    if (!_questionContainerView) {
        _questionContainerView = ({
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QUESTION_WIDTH, QUESTION_HEIGTH)];
            [view addSubview:self.question2View];
            [view addSubview:self.question1View];
            view;
        });
    }
    return _questionContainerView;
}

- (QuestionBaseView *)question1View
{
    if (!_question1View) {
        _question1View = ({
            QuestionBaseView * view = [[QuestionBaseView alloc] initWithFrame:CGRectMake(0, 0, QUESTION_WIDTH, QUESTION_HEIGTH)];
            
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

- (QuestionBaseView *)question2View
{
    if (!_question2View) {
        _question2View = ({
            QuestionBaseView * view = [[QuestionBaseView alloc] initWithFrame:CGRectMake(0, 0, QUESTION_WIDTH, QUESTION_HEIGTH)];
            view.hidden = YES;
            CAGradientLayer * gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 0, 320, 568) adjustWidth:![DHFoundationTool iPhone4]];
            gradientLayer.colors = @[(__bridge id)RGB_COLOR(246, 139, 65).CGColor,(__bridge id)RGB_COLOR(249, 210, 102).CGColor];
            
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1);
            [view.layer addSublayer:gradientLayer];
            
            view;
        });
    }
    
    return _question2View;
}


- (UIButton *)noButton
{
    if (!_noButton) {
        _noButton = ({
        
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.hidden = YES;
            [button setCenter:[DHConvenienceAutoLayout centerWithiPhone5Center:CGPointMake(70, 500)]];
            [button setBounds:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 90, 90) adjustWidth:YES]];
            [button setImage:IMAGE_WITH_NAME(@"错.png") forState:UIControlStateNormal];
            [button setImage:IMAGE_WITH_NAME(@"错_选中.png") forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onNo:) forControlEvents:UIControlEventTouchUpInside];
            button;
        
        });
    }
    
    return _noButton;
}

- (UIButton *)yesButton
{
    if (!_yesButton) {
        _yesButton = ({
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.hidden = YES;
            [button setCenter:[DHConvenienceAutoLayout centerWithiPhone5Center:CGPointMake(250, 500)]];
            [button setBounds:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 90, 90) adjustWidth:YES]];
            [button setImage:IMAGE_WITH_NAME(@"对.png") forState:UIControlStateNormal];
            [button setImage:IMAGE_WITH_NAME(@"对_选中.png") forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onYes:) forControlEvents:UIControlEventTouchUpInside];
            button;
            
        });
    }
    
    return _yesButton;
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
        animation.delegate = self;
        layer.path = [HomePageQuestionManager pathForEndding];
        animation.duration = 0.65;
        
        [layer addAnimation:animation forKey:@"aaa"];
        
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.yesButton.hidden = NO;
    self.noButton.hidden = NO;
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.56;
    animation.fromValue = [NSValue valueWithCGPoint:[DHConvenienceAutoLayout centerWithiPhone5Center:CGPointMake(-90, 500)]];
    [self.noButton.layer addAnimation:animation forKey:@"noButton"];
    
    animation.fromValue = [NSValue valueWithCGPoint:[DHConvenienceAutoLayout centerWithiPhone5Center:CGPointMake(410, 500)]];
    [self.yesButton.layer addAnimation:animation forKey:@"yesButton"];
}

- (void)drawClockFace
{
    // 设个容器Layer用来装整个时钟
    CALayer * containerLayer = [CALayer layer];
    containerLayer.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 200, 200) adjustWidth:YES];
    containerLayer.position = [DHConvenienceAutoLayout centerWithiPhone5Center:CGPointMake(160, 120)];
    [self.question2View.layer addSublayer:containerLayer];
    
    // 表盘
    CALayer * clockFaceLayer = [CALayer layer];
    clockFaceLayer.frame = containerLayer.bounds;
    clockFaceLayer.contents = (__bridge id)IMAGE_WITH_NAME(@"表盘.png").CGImage;
    [containerLayer addSublayer:clockFaceLayer];
    
    // 各个指针的初始化，主要是设置anchorPoint
    // center和表盘中心对其，然后设置锚点
    CALayer * hourHand = [self handWithSize:CGSizeMake(75, 95) image:IMAGE_WITH_NAME(@"时钟.png")];
    
    hourHand.anchorPoint = CGPointMake(0.9, 0.9);
    [containerLayer addSublayer:hourHand];
    
    CALayer * minutesHand = [self handWithSize:CGSizeMake(130, 10) image:IMAGE_WITH_NAME(@"分钟.png")];
    minutesHand.anchorPoint = CGPointMake(0.02, 0.5);
    [containerLayer addSublayer:minutesHand];
    
    CALayer * secondHand = [self handWithSize:CGSizeMake(11, 186) image:IMAGE_WITH_NAME(@"秒针.png")];
    
    secondHand.anchorPoint = CGPointMake(0.5, 0.22);
    [containerLayer addSublayer:secondHand];
    
    CGFloat duration = 1.5;
    
    // 表盘缩放动画
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @3;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [clockFaceLayer addAnimation:animation forKey:@"clockFace"];
    
    // 添加动画
    [hourHand addAnimation:[self animationGroupFromPosition:CGPointMake(0, 100)] forKey:@"hourHand"];
    [minutesHand addAnimation:[self animationGroupFromPosition:CGPointMake(300, 100)] forKey:@"minutesHand"];
    [secondHand addAnimation:[self animationGroupFromPosition:CGPointMake(160, 400)] forKey:@"sectionHand"];
}

- (CAAnimationGroup *)animationGroupFromPosition:(CGPoint)position
{
    // 统一持续时间
    CGFloat duration = 1.5;
    // 统一曲线，淡入淡出
    CAMediaTimingFunction * timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // 改变anchorPoint
    // 因为旋转的时候anchorPoint是0.5,0.5
    // 动画结束后anchorPoint需要改变
    CABasicAnimation * anchorPointAnimation = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
    anchorPointAnimation.duration = duration;
    anchorPointAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
    anchorPointAnimation.timingFunction = timingFunction;
    
    // 位置动画，改变各个指针的位置
    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = duration;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:[DHConvenienceAutoLayout centerWithiPhone5Center:position]];
    positionAnimation.timingFunction = timingFunction;
    
    // 旋转动画
    CABasicAnimation * rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = @0;
    rotateAnimation.toValue = @(4*M_PI);
    rotateAnimation.duration = duration;
    rotateAnimation.timingFunction = timingFunction;
    
    // 缩放动画
    // 从2倍缩放到0.7倍
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @2;
    scaleAnimation.duration = duration;
    scaleAnimation.timingFunction = timingFunction;
    
    // 动画组，返回
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;
    animationGroup.animations = @[positionAnimation, scaleAnimation,rotateAnimation,anchorPointAnimation];
    return animationGroup;
}




- (CALayer *)handWithSize:(CGSize)size image:(UIImage *)image
{
    CALayer * layer = [CALayer layer];
    [layer setBounds:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Size:size iPhone5Center:CGPointZero adjustWidth:YES]];
    layer.position = [DHConvenienceAutoLayout centerWithiPhone5Center:CGPointMake(100, 100)];
    layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
    layer.contents = (__bridge id)image.CGImage;
    
    
    return layer;
}


#pragma mark - button action

- (void)onNo:(UIButton *)sender
{
    sender.selected = YES;
//    [self.question1View removeFromSuperview];
//    [self.question2View removeFromSuperview];
//    self.question1View = nil;
//    self.question2View = nil;
//    if (self.noBlock) {
//        self.noBlock();
//    }
}

- (void)onYes:(UIButton *)sender
{
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        // 将question1移除
        self.question1View.center = CGPointMake(-160*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], self.question1View.center.y);
    }];
    
    self.question2View.hidden = NO;
    // 取到gradientLayer
    NSArray * sublayers = self.question2View.layer.sublayers;
    CAGradientLayer * layer = sublayers.lastObject;
    // 改变渐变色的动画
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.beginTime = 0.3 + CACurrentMediaTime();
    animation.fillMode = kCAFillModeBackwards;
    animation.duration = 3;
    animation.fromValue = layer.colors;
    layer.colors = @[(__bridge id)RGB_COLOR(80, 80, 80).CGColor,(__bridge id)RGB_COLOR(10, 10, 255).CGColor];
    [layer addAnimation:animation forKey:@"gradient"];
    
    [self drawClockFace];
}


@end
