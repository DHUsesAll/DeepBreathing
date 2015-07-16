//
//  DHImageTextButton.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-15.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHImageTextButton.h"
#import "DHFoundationTool.h"

@interface DHImageTextButton ()

@property (nonatomic, strong) UIImageView * imageView ;
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, assign) BOOL isVertical;

@property (nonatomic, assign) CGFloat spacing;

@property (nonatomic, strong) CAShapeLayer * maskLayer;

@end

@implementation DHImageTextButton

- (void)dealloc
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.imageView = nil;
    self.label = nil;
    self.image = nil;
    self.font = nil;
    self.text = nil;
    
}

- (instancetype)initWithSpacing:(CGFloat)spacing image:(UIImage *)image imageSize:(CGSize)size text:(NSString *)text font:(UIFont *)font vertical:(BOOL)flag usingMask:(BOOL)mask
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.spacing = spacing;
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(size.width+spacing, size.height/2-font.pointSize/2, 0, 0)];
        self.label.textColor = [UIColor darkGrayColor];
        self.isVertical = flag;
        if (flag) {
            self.spacing = spacing + font.pointSize/2 + size.height;
        }
//        self.label.center = CGPointMake(self.label.center.x, _imageView.center.y);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:_imageView];
        [self addSubview:_label];
        
        self.image = image;
        self.imageSize = size;
        self.font = font;
        self.text = text;
        
        if (mask) {
            [self setImageCornerRadius:size.width/2];
            self.imageView.layer.borderColor = [[DHFoundationTool colorWith255Red:220 green:220 blue:220 alpha:1] CGColor];
            self.imageView.clipsToBounds = YES;
            self.imageView.layer.borderWidth = 1;
            self.imageView.backgroundColor = [DHFoundationTool colorWith255Red:250 green:250 blue:250 alpha:1];
        }
    }
    return self;
}

- (UIImageView *)imageView
{
    return _imageView;
}

- (UILabel *)textLabel
{
    return _label;
}

#pragma mark - setter

- (void)setImage:(UIImage *)image
{
    if (_image == image) {
        return;
    }
    _image = image;
    self.imageView.image = image;
}

- (void)setImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    self.imageView.bounds = CGRectMake(self.imageView.bounds.origin.x, self.imageView.bounds.origin.y, imageSize.width, imageSize.height);
}

- (void)setText:(NSString *)text
{
    if ([_text isEqualToString:text] || _text == text) {
        return;
    }
    _text = text;
    self.label.text = text;
    [self.label sizeToFit];
    if (self.isVertical) {
        self.label.center = CGPointMake(_imageView.center.x, _spacing);
    }
}

- (void)setFont:(UIFont *)font
{
    if (_font == font) {
        return;
    }
    _font = font;
    self.label.font = font;
}

- (void)setImageCornerRadius:(CGFloat)radius
{
    _imageView.layer.cornerRadius = radius;
}

#pragma mark - tap

- (void)tap:(UITapGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOnImageTextButton:)]) {
        [self.delegate didTapOnImageTextButton:self];
    }
}


@end
