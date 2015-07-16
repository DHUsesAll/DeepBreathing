//
//  DHPerspectiveNavigationTransition.h
//  Test3D
//
//  Created by DreamHack on 14-10-13.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHNavigationBaseTransition.h"

@interface DHPerspectiveNavigationTransition : DHNavigationBaseTransition

@property (nonatomic, assign, readonly, getter=isUsingDynamicEffect) BOOL usingDynamicEffect;

@property (nonatomic, assign) CGPoint focalPoint;       // usually the center of a button

- (instancetype)initWithDynamicPerspectiveFocalPoint:(CGPoint)focalPoint;




@end
