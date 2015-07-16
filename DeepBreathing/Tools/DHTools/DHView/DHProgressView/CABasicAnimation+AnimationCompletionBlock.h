//
//  CABasicAnimation+AnimationCompletionBlock.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-15.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void(^AnimationCompletionBlock)(BOOL flag);

@interface CABasicAnimation (AnimationCompletionBlock)

@property (nonatomic, strong) AnimationCompletionBlock completionBlock;

@end
