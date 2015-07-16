//
//  DHNormalProgressView.h
//  HealthManagement
//
//  Created by DreamHack on 14-11-27.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHNormalProgressView : UIView

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor;

- (void)setProgress:(NSInteger)progress;

@end
