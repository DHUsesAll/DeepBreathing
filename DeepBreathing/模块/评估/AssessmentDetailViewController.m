//
//  AssessmentDetailViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-28.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "AssessmentDetailViewController.h"
#import "DHVector.h"
#import "AssessmentQuizView.h"

@interface AssessmentDetailViewController ()

// 顶部的弧线
@property (nonatomic, strong) CAShapeLayer * lineLayer;
// 当前是第几题
@property (nonatomic, assign) NSInteger quizIndex;
// 球形的视图，用来显示当前第几题
@property (nonatomic, strong) UIView * ballView;
// 显示当前第几题的label
@property (nonatomic, strong) UILabel * quizIndexLabel;

// 所有quizView的容器
@property (nonatomic, strong) UIView * containerView;

// 容器的锚点
@property (nonatomic, assign) CGPoint anchorPoint;

@end

@implementation AssessmentDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAppearance];
}

- (void)initializeAppearance
{
    _quizIndex = 0;
    self.anchorPoint = [DHConvenienceAutoLayout centerWithiPhone5Center:CGPointMake(160, -260)];
    self.view.backgroundColor = RGB_COLOR(237, 237, 237);
    CAShapeLayer * lineLayer = ({
    
        CAShapeLayer * layer = [CAShapeLayer layer];
        [layer setFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 75, 320, 80) adjustWidth:![DHFoundationTool iPhone4]]];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = THEME_TEXT_COLOR.CGColor;
        layer.lineWidth = 3;
        layer;
    
    });
    [self.view.layer addSublayer:lineLayer];
    self.lineLayer = lineLayer;
    
    // 在小球下方的曲线
    UIBezierPath * linePath = ({
    
        UIBezierPath * path = [UIBezierPath bezierPath];
        // 从00点开始画
        [path moveToPoint:CGPointZero];
        //
        [path addQuadCurveToPoint:CGPointMake(320*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 0) controlPoint:CGPointMake(CGRectGetWidth(lineLayer.bounds)/2, 70*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
        path;
    });
    
    lineLayer.path = linePath.CGPath;
    
    [self.ballView addSubview:self.quizIndexLabel];
    [self.view addSubview:self.ballView];
    [self.view addSubview:self.containerView];
    
    // 一个左划手势，一个右滑手势
    UISwipeGestureRecognizer * leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    leftSwipe.direction =UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer * rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    
}

#pragma mark - getter
- (UIView *)ballView
{
    if (!_ballView) {
        _ballView = ({
        
            UIView * view = [[UIView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 40, 40) adjustWidth:YES]];
            view.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, 110*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = CGRectGetWidth(view.bounds)/2;
            view.backgroundColor = THEME_TEXT_COLOR;
            view;
        
        });
    }
    
    return _ballView;
}


- (UILabel *)quizIndexLabel
{
    if (!_quizIndexLabel) {
        
        _quizIndexLabel = ({
        
            UILabel * label = [[UILabel alloc] initWithFrame:_ballView.bounds];
            [label setAttributedText:[self attributedString]];
            
            label;
        
        });
    }
    
    return _quizIndexLabel;
}


- (NSAttributedString *)attributedString
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/5",_quizIndex+1]];
    
    // 设置第一个字的字体
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:26*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, 1)];
    
    // 设置后两个字的字体
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(1, 2)];
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    [attributedString addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, 3)];
    
    
    return attributedString;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = ({
        
            UIView * view = [[UIView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 2000, 2000) adjustWidth:![DHFoundationTool iPhone4]]];
            view.center = self.anchorPoint;
            
            CGFloat referenceHeight = CGRectGetHeight(view.bounds);
            
            
            for (int i = 0; i < 5; i++) {
                
                // 初始化向量
                DHVector * vector = [[DHVector alloc] initWithStartPoint:[DHVector openGLPointFromUIKitPoint:CGPointMake(CGRectGetWidth(view.bounds)/2, CGRectGetHeight(view.bounds)/2) referenceHeight:referenceHeight] endPoint:[DHVector openGLPointFromUIKitPoint:CGPointMake(CGRectGetWidth(view.bounds)/2, self.view.center.y-view.frame.origin.y+60) referenceHeight:referenceHeight]];
                
                // 旋转向量
                [vector rotateAntiClockwiselyWithRadian:M_PI/6*i];
                
                AssessmentQuizView * aView = [[AssessmentQuizView alloc] initWithTitle:@"aaa" tintColor:THEME_TEXT_COLOR quiz:@[]];
                
                // 通过向量终点设置center
                aView.center = [DHVector uikitPointFromOpenGLPoint:vector.endPoint referenceHeight:referenceHeight];
                
                aView.transform = CGAffineTransformMakeRotation(2*M_PI- M_PI/6*i);
                [view addSubview:aView];
            }
            
            view;
        
        });
    }
    return _containerView;
}

#pragma mark - callbacks
- (void)onSwipe:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_quizIndex == 4) {
            return;
        }
        _quizIndex++;
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_quizIndex==0) {
            return;
        }
        _quizIndex--;
    }
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.78 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // 通过旋转整个containerView来旋转所有的问题的视图
        self.containerView.transform = CGAffineTransformMakeRotation(_quizIndex*M_PI/6);
        
    } completion:^(BOOL finished) {
        
    }];
    
    // 小球动画
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        // 向上
        self.ballView.frame = CGRectOffset(self.ballView.frame, 0, -100*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // 向下
            self.ballView.frame = CGRectOffset(self.ballView.frame, 0, 100*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    [self.quizIndexLabel setAttributedText:[self attributedString]];
}


@end
