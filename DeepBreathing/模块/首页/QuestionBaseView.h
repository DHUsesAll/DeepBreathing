//
//  QuestionBaseView.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-22.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionBaseView : UIView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^YesBlock)(QuestionBaseView * baseView);
@property (nonatomic, copy) void(^NoBlock)(QuestionBaseView * baseView);
@property (nonatomic, copy) void(^RightSwipeGestureAction)(QuestionBaseView * baseView);

@end
