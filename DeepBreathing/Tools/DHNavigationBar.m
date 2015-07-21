//
//  DHNavigationBar.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-17.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHNavigationBar.h"
#import "DHConvenienceAutoLayout.h"
#import "DHFoundationTool.h"

@interface DHNavigationBar ()

@property (nonatomic, strong) NSString * title;

@end

@implementation DHNavigationBarItem



@end


@implementation DHNavigationBar

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 320, 64) adjustWidth:![DHFoundationTool iPhone4]]];
    
    if (self) {
        self.title = title;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    UILabel * titleLabel = ({
    
        UILabel * label = [[UILabel alloc] initWithFrame:self.bounds];
        
        label.textColor = THEME_TEXT_COLOR;
        label.font = [UIFont systemFontOfSize:[DHConvenienceAutoLayout iPhone5VerticalMutiplier] * 20];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
    
        label;
    });
    
    [self addSubview:titleLabel];
    
    return self;
}

- (void)setLeftBarButtonItem:(DHNavigationBarItem *)leftBarButtonItem
{
    if (_leftBarButtonItem == leftBarButtonItem) {
        return;
    }
    if (_leftBarButtonItem) {
        [_leftBarButtonItem removeFromSuperview];
    }
    _leftBarButtonItem = leftBarButtonItem;
    
    [self setItemWithItem:leftBarButtonItem originX:8];
}

- (void)setRightBarButtonItem:(DHNavigationBarItem *)rightBarButtonItem
{
    if (_rightBarButtonItem == rightBarButtonItem) {
        return;
    }
    if (_rightBarButtonItem) {
        [_rightBarButtonItem removeFromSuperview];
    }
    _rightBarButtonItem = rightBarButtonItem;
    [self setItemWithItem:rightBarButtonItem originX:320-90];
}

- (void)setItemWithItem:(DHNavigationBarItem *)item originX:(CGFloat)originX
{
    UIImage * image = item.imageView.image;
    item.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(originX, 0, image.size.width/2, image.size.height/2) adjustWidth:YES];
    
    item.center = CGPointMake(_leftBarButtonItem.center.x, CGRectGetHeight(self.bounds)/2);
    
    [self addSubview:item];

}

@end
