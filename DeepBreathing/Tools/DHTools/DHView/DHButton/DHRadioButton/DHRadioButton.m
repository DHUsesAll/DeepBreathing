//
//  DHRadioButton.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-21.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHRadioButton.h"
#import "DHFoundationTool.h"
#import "DHThemeSettings.h"

static NSMutableDictionary * groupRadioDic_ = nil;

#define IO_RATE 14.f/17

@interface DHRadioButton ()
{
    UIView * selectionView;
}

@property (nonatomic, strong) NSString * groupId;
@property (nonatomic, strong) UIColor * themeColor;
@property (nonatomic, strong) NSString * title;



@end

@implementation DHRadioButton

- (void)dealloc
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.groupId = nil;
    self.themeColor = nil;
    self.title = nil;
}

- (instancetype)initWithFrame:(CGRect)frame groupId:(NSString *)groupId themeColor:(UIColor *)themeColor title:(NSString *)title
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.groupId = groupId;
        self.themeColor = themeColor;
        self.title = title;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        [self addToGroup];
        [self draw];
    }
    
    return self;
}

- (void)addToGroup
{
    if (!groupRadioDic_) {
        groupRadioDic_ = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    NSMutableArray * group = [groupRadioDic_ objectForKey:_groupId];
    if (!group) {
        group = [NSMutableArray arrayWithCapacity:0];
    }
    [group addObject:self];
    [groupRadioDic_ setObject:group forKey:_groupId];
    
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    selectionView.hidden = !selected;
    if (selected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(radioButton:didSelectItemWithTitle:)]) {
            [self.delegate radioButton:self didSelectItemWithTitle:self.title];
        }
        NSMutableArray * group = [groupRadioDic_ objectForKey:_groupId];
        for (DHRadioButton * button in group) {
            
            if (button != self) {
                
                [button setSelected:NO];
            }
            
        }
        
    }
}

- (void)draw
{
    CGFloat radius = self.frame.size.height/2;
    UIView * radioOuterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius*2, radius*2)];
    radioOuterView.layer.cornerRadius = radius;
    radioOuterView.layer.borderColor = self.themeColor.CGColor;
    radioOuterView.layer.borderWidth = 1;
    [self addSubview:radioOuterView];
    
    selectionView = [[UIView alloc] initWithFrame:[DHFoundationTool rectWithSize:CGSizeMake(radius * IO_RATE * 2, radius * IO_RATE * 2) center:radioOuterView.center]];
    selectionView.backgroundColor = self.themeColor;
    selectionView.layer.cornerRadius = radius * IO_RATE;
    selectionView.hidden = YES;
    [self addSubview:selectionView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8+radius*2, selectionView.frame.origin.y, self.frame.size.width - 8 - radius*2, selectionView.frame.size.height)];
    titleLabel.text = self.title;
    titleLabel.font = [DHThemeSettings themeFontOfSize:radius*2*IO_RATE];
    titleLabel.textColor = [DHThemeSettings themeTextColor];
    [self addSubview:titleLabel];
}

- (void)tap
{
    if (self.selected) {
        return;
    }
    [self setSelected:YES];
    
}

@end
