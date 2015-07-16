//
//  DHFunctionChartView.h
//  HealthManagement
//
//  Created by DreamHack on 14-12-2.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat(^FunctionExpress)(CGFloat x);

@interface DHFunctionChartView : UIView

- (instancetype)initWithFrame:(CGRect)frame lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;

- (void)drawWithFunctionExpress:(FunctionExpress)express;

@end
