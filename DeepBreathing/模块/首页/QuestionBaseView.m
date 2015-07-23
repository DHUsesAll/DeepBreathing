//
//  QuestionBaseView.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-22.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "QuestionBaseView.h"

@interface QuestionBaseView ()

@property (nonatomic, strong) UISwipeGestureRecognizer * swipeGesture;

@end

@implementation QuestionBaseView


#pragma mark - getter
- (UISwipeGestureRecognizer *)swipeGesture
{
    if (!_swipeGesture) {
        
    }
    return _swipeGesture;
}


@end
