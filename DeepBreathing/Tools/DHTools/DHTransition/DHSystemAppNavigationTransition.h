//
//  DHSystemAppNavigationTransition.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-16.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHNavigationBaseTransition.h"

@interface DHSystemAppNavigationTransition : DHNavigationBaseTransition

@property (nonatomic, assign) CGRect fromFrame;
@property (nonatomic,strong) UIPercentDrivenInteractiveTransition * percentDrivenInteractiveTransition;

- (instancetype)initWithFromFrame:(CGRect)fromFrame;

@end
