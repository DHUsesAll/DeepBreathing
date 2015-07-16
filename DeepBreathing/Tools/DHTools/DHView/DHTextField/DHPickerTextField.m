//
//  DHPickerTextField.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-21.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHPickerTextField.h"
#import "DHFoundationTool.h"
#import "DHConvenienceAutoLayout.h"
#import "DHThemeSettings.h"

@interface DHPickerTextField ()<UIGestureRecognizerDelegate>


@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, assign) CGFloat pickerHeight;
@property (nonatomic, strong) UILabel * placeHolderView;

@end

@implementation DHPickerTextField

- (void)dealloc
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.components = nil;
    self.pickerView = nil;
    self.placeHolder = nil;
    self.placeHolderView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame pickerComponents:(NSArray *)components pickerHeight:(CGFloat)pickerHeight
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _show = NO;
        self.components = components;
        self.layer.masksToBounds = YES;
        self.pickerHeight = pickerHeight;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [self draw];
    }
    
    return self;
}

- (void)draw
{
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.pickerHeight)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_pickerView];
    
    self.placeHolderView = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, self.frame.size.width, self.frame.size.height)];
    self.placeHolderView.textColor = [DHFoundationTool colorWith255Red:196 green:196 blue:196 alpha:1];
    self.placeHolderView.font = [DHThemeSettings themeFontOfSize:14 * [DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
    self.placeHolderView.center = CGPointMake(self.placeHolderView.center.x, self.frame.size.height/2);
    [self addSubview:self.placeHolderView];
    
}

- (void)setComponents:(NSArray *)components
{
    if (_components == components) {
        return;
    }
    _components = components;
    if (_components && _pickerView) {
        [_pickerView reloadAllComponents];
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    if (_placeHolder == placeHolder) {
        return;
    }
    _placeHolder = placeHolder;
    _placeHolderView.text = placeHolder;
}

- (void)tap
{
    if (self.show) {
        [self hide];
        
    } else {
        [self show];
    }
    self.show = !self.show;
}

- (void)show
{
    UIView * superview = self.superview;
    [superview bringSubviewToFront:self];
    self.placeHolderView.hidden = YES;
    [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.79 initialSpringVelocity:12 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+_pickerHeight);
        
    } completion:nil];
}

- (void)hide
{
    self.placeHolderView.hidden = NO;
    [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.79 initialSpringVelocity:12 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-_pickerHeight);
        
    } completion:nil];
}

#pragma mark - picker delegate datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _components.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_components objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

@end
