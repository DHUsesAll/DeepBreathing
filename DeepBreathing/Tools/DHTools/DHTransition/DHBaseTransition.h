//
//  DHBaseTransition.h
//  Test3D
//
//  Created by DreamHack on 14-10-10.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DHBaseTransition : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, readwrite, assign, getter = isPresenting) BOOL presenting;

@end
