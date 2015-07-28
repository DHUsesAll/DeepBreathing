//
//  AssessmentQuizView.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-28.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "AssessmentQuizView.h"

@interface AssessmentQuizView ()

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIColor * tintColor;
@property (nonatomic, copy) NSArray * quiz;

@end

@implementation AssessmentQuizView

- (instancetype)initWithTitle:(NSString *)title tintColor:(UIColor *)tintColor quiz:(NSArray *)quiz
{
    self = [super initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 210, 374) adjustWidth:![DHFoundationTool iPhone4]]];
    if (self) {
        self.title = title;
        self.tintColor = tintColor;
        self.quiz = quiz;
        self.backgroundColor = tintColor;
    }
    
    return self;
}

@end
