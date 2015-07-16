//
//  DHImageTextButton.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-15.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHImageTextButton;

@protocol DHImageTextButtonDelegate <NSObject>

- (void)didTapOnImageTextButton:(DHImageTextButton *)imageTextButton;

@end

@interface DHImageTextButton : UIView

- (instancetype)initWithSpacing:(CGFloat)spacing image:(UIImage *)image imageSize:(CGSize)size text:(NSString *)text font:(UIFont *)font vertical:(BOOL)flag usingMask:(BOOL)mask;

@property (nonatomic, weak) id <DHImageTextButtonDelegate> delegate;

@property (nonatomic, strong) UIImage * image;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) UIFont * font;

- (void)setImageCornerRadius:(CGFloat)radius;

- (UIImageView *)imageView;
- (UILabel *)textLabel;

@end
