//
//  DHNavigationBar.h
//  DeepBreathing
//
//  Created by DreamHack on 15-7-17.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHNavigationBarItem : UIButton

@end

@interface DHNavigationBar : UIView

- (instancetype)initWithTitle:(NSString *)title;

@property (nonatomic, strong) DHNavigationBarItem * leftBarButtonItem;

@property (nonatomic, strong) DHNavigationBarItem * rightBarButtonItem;

@end
