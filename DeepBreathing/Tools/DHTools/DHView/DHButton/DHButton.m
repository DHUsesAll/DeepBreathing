//
//  DHButton.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-30.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHButton.h"

@implementation DHButton

- (void)setHighlighted:(BOOL)highlighted
{
//    [super setHighlighted:highlighted];
    if (highlighted) {
        self.alpha = 0.28;
        
    } else {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end


