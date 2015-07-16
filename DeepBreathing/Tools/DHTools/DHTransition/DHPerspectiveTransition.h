//
//  DHPerspectiveTransition.h
//  Test3D
//
//  Created by DreamHack on 14-10-10.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHBaseTransition.h"

@interface DHPerspectiveTransition : DHBaseTransition

//

@property (nonatomic, assign, readonly, getter=isUsingDynamicEffect) BOOL usingDynamicEffect;

@property (nonatomic, assign) CGPoint focalPoint;       // usually the center of a button

// use normal alloc init or new method to get default effect

- (instancetype)initWithDynamicPerspectiveFocalPoint:(CGPoint)focalPoint;



@end
