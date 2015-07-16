//
//  DHScanScrollView.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-23.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHScanScrollView.h"
#import "DHFoundationTool.h"
#import "DHConvenienceAutoLayout.h"

@interface DHScanScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSMutableArray * reusingQueue;
@property (nonatomic, assign) BOOL isHorizontal;
@property (nonatomic, strong) NSMutableArray * colors;
@property (nonatomic, strong) CAGradientLayer * colorLayer;

@property (nonatomic, strong) UIView * leftButton;
@property (nonatomic, strong) UIView * rightButton;

@end

@implementation DHScanScrollView
{
    NSInteger _startIndex;
    NSInteger _currentIndex;
    NSInteger _oldIndex;
    CGFloat new;
    CGFloat old;
    
    UIImageView * preView;
    UIImageView * currentView;
    UIImageView * nextView;
    
    NSInteger itemNumber;
    
    BOOL noColors;
}

- (void)dealloc
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_colorLayer removeFromSuperlayer];
    [_scrollView removeFromSuperview];
    self.scrollView = nil;
    self.colors = nil;
    self.colorLayer = nil;
    self.leftButton = nil;
    self.rightButton = nil;
}

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id<DHScanScrollViewDataSource>)dataSource delegate:(id<DHScanScrollViewDelegate>)delegate startIndex:(NSInteger)index isHorizontal:(BOOL)flag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = dataSource;
        self.delegate = delegate;
        _startIndex = index;
        _currentIndex = index;
        _oldIndex = index;
        self.isHorizontal = flag;
        noColors = NO;
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        self.scrollView = scrollView;
//        [self drawScrollViewWithIndex:index];
        
        self.scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        old = scrollView.frame.size.width * index;
        
        self.colorLayer = [CAGradientLayer layer];
        self.colorLayer.frame = self.bounds;
        self.colorLayer.startPoint = CGPointMake(0.5, 0.8);
        self.colorLayer.endPoint = CGPointMake(0.5, -0.4);
        [self.layer addSublayer:_colorLayer];
        [self addSubview:scrollView];
        
        [self drawButton];
        
    }
    return self;
}

- (UIView *)leftButton
{
    return _leftButton;
}

- (UIView *)rightButton
{
    return _rightButton;
}

- (void)drawButton
{
    self.leftButton = [[UIView alloc] init];
    _leftButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    
    _leftButton.layer.cornerRadius = 13.5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier];
    _leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_leftButton];
    
    self.rightButton = [[UIView alloc] init];
    _rightButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    
    _rightButton.layer.cornerRadius = 13.5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier];
    _rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_rightButton];
    
    [self addConstraints:[DHConvenienceAutoLayout constraintsWithSize:[DHConvenienceAutoLayout sizeWithiPhone5Size:CGSizeMake(27, 27) adjustWidth:YES] forView:_leftButton]];
    [self addConstraints:[DHConvenienceAutoLayout constraintsWithSize:[DHConvenienceAutoLayout sizeWithiPhone5Size:CGSizeMake(27, 27) adjustWidth:YES] forView:_rightButton]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:100*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-8*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:100*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]]];
    
    
    CAShapeLayer * leftLayer = [CAShapeLayer layer];
    leftLayer.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 0, 27, 27) adjustWidth:YES];
    leftLayer.strokeColor = [UIColor whiteColor].CGColor;
    leftLayer.fillColor = [UIColor clearColor].CGColor;
    leftLayer.lineWidth = 3;
    [_leftButton.layer addSublayer:leftLayer];
    
    UIBezierPath * leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(15*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
    [leftPath addLineToPoint:CGPointMake(7*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 13.5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
    [leftPath addLineToPoint:CGPointMake(15*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 22*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
    
    leftLayer.path = leftPath.CGPath;
    
    CAShapeLayer * rightLayer = [CAShapeLayer layer];
    rightLayer.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(0, 0, 27, 27) adjustWidth:YES];
    rightLayer.strokeColor = [UIColor whiteColor].CGColor;
    rightLayer.fillColor = [UIColor clearColor].CGColor;
    rightLayer.lineWidth = 3;
    [_rightButton.layer addSublayer:rightLayer];
    
    UIBezierPath * rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:CGPointMake(10*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
    [rightPath addLineToPoint:CGPointMake(18*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 13.5*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
    [rightPath addLineToPoint:CGPointMake(10*[DHConvenienceAutoLayout iPhone5VerticalMutiplier], 22*[DHConvenienceAutoLayout iPhone5VerticalMutiplier])];
    
    rightLayer.path = rightPath.CGPath;

}

- (void)drawScrollViewWithIndex:(NSInteger)index
{
    self.colors = [NSMutableArray arrayWithCapacity:0];
    if (!currentView) {
        currentView = [[UIImageView alloc] init];
    }
    
    if (!preView) {
        preView = [[UIImageView alloc] init];
    }
    
    if (!nextView) {
        nextView = [[UIImageView alloc] init];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInScanScrollView:)]) {
        
        itemNumber = [self.dataSource numberOfItemsInScanScrollView:self];
        if (itemNumber == 0) {
            return;
        }
        if (itemNumber > 1) {
            [_leftButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnButton:)]];
            [_rightButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnButton:)]];
        }
        NSMutableArray * images = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemImageForRowAtIndex:inScanScrollView:)] && [self.dataSource itemImageForRowAtIndex:0 inScanScrollView:self]) {
            images = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < itemNumber; i++) {
                [images addObject:[self.dataSource itemImageForRowAtIndex:i inScanScrollView:self]];
            }
        }

        _scrollView.contentSize = CGSizeMake(self.frame.size.width * itemNumber, self.frame.size.height);
        _scrollView.contentOffset = CGPointMake(self.frame.size.width * index, 0);
        if (itemNumber == 1) {
            
            currentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            currentView.image = [images objectAtIndex:0];
            [_scrollView addSubview:currentView];
            if (self.delegate && [self.delegate respondsToSelector:@selector(drawItemView:forRowAtIndex:inScanScrollView:)]) {
                [self.delegate drawItemView:currentView forRowAtIndex:0 inScanScrollView:self];
            }
        } else if (itemNumber == 2) {
            currentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            currentView.image = [images objectAtIndex:0];
            nextView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            nextView.image = [images objectAtIndex:1];
            [_scrollView addSubview:currentView];
            [_scrollView addSubview:nextView];
            if (self.delegate && [self.delegate respondsToSelector:@selector(drawItemView:forRowAtIndex:inScanScrollView:)]) {
                [self.delegate drawItemView:currentView forRowAtIndex:0 inScanScrollView:self];
                [self.delegate drawItemView:nextView forRowAtIndex:1 inScanScrollView:self];
            }
        } else {
            // 如果一开始显示最后一页
            if (index == itemNumber - 1) {
                
                
                nextView.frame = CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                nextView.image = [images lastObject];
                currentView.frame = CGRectOffset(nextView.frame, -self.frame.size.width, 0);
                currentView.image = [images objectAtIndex:index - 1];
                preView.frame = CGRectOffset(currentView.frame, -self.frame.size.width, 0);
                preView.image = [images objectAtIndex:index - 2];
                if (self.delegate && [self.delegate respondsToSelector:@selector(drawItemView:forRowAtIndex:inScanScrollView:)]) {
                    [self.delegate drawItemView:preView forRowAtIndex:index-2 inScanScrollView:self];
                    [self.delegate drawItemView:currentView forRowAtIndex:index-1 inScanScrollView:self];
                    [self.delegate drawItemView:nextView forRowAtIndex:index inScanScrollView:self];
                }
            } else if (index == 0) {
                preView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                preView.image = [images firstObject];
                currentView.frame = CGRectOffset(nextView.frame, self.frame.size.width, 0);
                currentView.image = [images objectAtIndex:1];
                nextView.frame = CGRectOffset(currentView.frame, self.frame.size.width, 0);
                nextView.image = [images objectAtIndex:2];
                if (self.delegate && [self.delegate respondsToSelector:@selector(drawItemView:forRowAtIndex:inScanScrollView:)]) {
                    [self.delegate drawItemView:preView forRowAtIndex:0 inScanScrollView:self];
                    [self.delegate drawItemView:currentView forRowAtIndex:1 inScanScrollView:self];
                    [self.delegate drawItemView:nextView forRowAtIndex:2 inScanScrollView:self];
                }
            } else {
                currentView.frame = CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                currentView.image = [images objectAtIndex:index];
                preView.frame = CGRectOffset(currentView.frame, -self.frame.size.width, 0);
                preView.image = [images objectAtIndex:index - 1];
                nextView.frame = CGRectOffset(currentView.frame, self.frame.size.width, 0);
                nextView.image = [images objectAtIndex:index + 1];
                if (self.delegate && [self.delegate respondsToSelector:@selector(drawItemView:forRowAtIndex:inScanScrollView:)]) {
                    [self.delegate drawItemView:preView forRowAtIndex:index-1 inScanScrollView:self];
                    [self.delegate drawItemView:currentView forRowAtIndex:index inScanScrollView:self];
                    [self.delegate drawItemView:nextView forRowAtIndex:index+1 inScanScrollView:self];
                }
            }
            [_scrollView addSubview:preView];
            [_scrollView addSubview:currentView];
            [_scrollView addSubview:nextView];
        }
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemBackgroundColorForRowAtIndex:inScanScrollView:)]) {
            
            for (int i = 0; i < itemNumber; i++) {
                if ([self.dataSource itemBackgroundColorForRowAtIndex:i inScanScrollView:self]) {
                    [self.colors addObject:[self.dataSource itemBackgroundColorForRowAtIndex:i inScanScrollView:self]];
                } else {
                    noColors = YES;
                }
                
                
            }
//            _scrollView.backgroundColor = [self.colors objectAtIndex:index];
            if (!noColors) {
                UIColor * color = [self.colors objectAtIndex:index];
//                _colorLayer.colors = @[(__bridge id)[color CGColor],(__bridge id)[UIColor whiteColor].CGColor];
                _scrollView.backgroundColor = color;
            }
            
        }
    }
}

- (UIScrollView *)scrollView
{
    return _scrollView;
}

- (void)reloadDataWithStartIndex:(NSInteger)index
{
    _startIndex = index;
    _currentIndex = index;
    _oldIndex = index;
    preView = nil;
    currentView = nil;
    nextView = nil;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self drawScrollViewWithIndex:index];
}

- (void)setCurrentIndex:(NSInteger)index animate:(BOOL)flag
{
    [_scrollView setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:YES];
}

- (void)tapOnButton:(UIGestureRecognizer *)sender
{
    
    if (sender.view == _leftButton) {
        if (_currentIndex == 0) {
            return;
        }
        _leftButton.userInteractionEnabled = NO;
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*(_currentIndex-1), 0) animated:YES];
    } else if (sender.view == _rightButton) {
        if (_currentIndex == itemNumber-1) {
            return;
        }
        _rightButton.userInteractionEnabled = NO;
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*(_currentIndex+1), 0) animated:YES];
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (itemNumber == 0 || _colors.count == 0 || noColors) {
        return;
    }
    if (scrollView.contentOffset.x < 0) {
        scrollView.alpha = 1 + scrollView.contentOffset.x/scrollView.frame.size.width*1.8;
    } else if (scrollView.contentOffset.x >= (itemNumber-1) * scrollView.frame.size.width) {
        scrollView.alpha = 1 - (scrollView.contentOffset.x-(itemNumber-1) * scrollView.frame.size.width)/scrollView.frame.size.width*1.8;
    } else {
        NSInteger fromIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
        NSInteger toIndex = fromIndex+1;
        UIColor * fromColor = [self.colors objectAtIndex:fromIndex];
        UIColor * toColor = [self.colors objectAtIndex:toIndex];
//        CGFloat rate = (scrollView.contentOffset.x-fromIndex*scrollView.frame.size.width)/scrollView.frame.size.width;
        scrollView.backgroundColor = [DHFoundationTool colorInterpolateWithRate:(scrollView.contentOffset.x-fromIndex*scrollView.frame.size.width)/scrollView.frame.size.width fromColor:fromColor toColor:toColor];
//        UIColor * color = [DHFoundationTool colorInterpolateWithRate:rate fromColor:fromColor toColor:toColor];
//        self.colorLayer.colors = @[(__bridge id)color.CGColor,(__bridge id)[UIColor whiteColor].CGColor];
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    scrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = YES;
    _currentIndex = (NSInteger)scrollView.contentOffset.x/(NSInteger)scrollView.frame.size.width;
    if (_currentIndex == _oldIndex) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanScrollView:didChangeToIndex:)]) {
        
        [self.delegate scanScrollView:self didChangeToIndex:_currentIndex];
        
    }
    
    if (itemNumber > 3) {
        if (_currentIndex > _oldIndex) {
            
            // 向左
            if (_currentIndex != 1 && _currentIndex != itemNumber-1) {
                UIImageView * tempView = preView;
                preView.frame = CGRectOffset(nextView.frame, scrollView.frame.size.width, 0);
                [preView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                preView = currentView;
                currentView = nextView;
                nextView = tempView;
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemImageForRowAtIndex:inScanScrollView:)]) {
                    nextView.image = [_dataSource itemImageForRowAtIndex:_currentIndex+1 inScanScrollView:self];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(drawItemView:forRowAtIndex:inScanScrollView:)]) {
                    [self.delegate drawItemView:nextView forRowAtIndex:_currentIndex+1 inScanScrollView:self];
                }
            }
            
        } else if (_currentIndex < _oldIndex) {
            // 向右
            if (_currentIndex != 0 && _currentIndex != itemNumber-2) {
                UIImageView * tempView = nextView;
                nextView.frame = CGRectOffset(preView.frame, -scrollView.frame.size.width, 0);
                [nextView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                nextView = currentView;
                currentView = preView;
                preView = tempView;
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemImageForRowAtIndex:inScanScrollView:)]) {
                    preView.image = [_dataSource itemImageForRowAtIndex:_currentIndex-1 inScanScrollView:self];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(drawItemView:forRowAtIndex:inScanScrollView:)]) {
                    [self.delegate drawItemView:preView forRowAtIndex:_currentIndex-1 inScanScrollView:self];
                }
            }
            
        }
    }
    
    _oldIndex = _currentIndex;
    
//    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
//    CGFloat offset = scrollView.contentOffset.x - index * scrollView.frame.size.width;
//    if (offset > scrollView.frame.size.width/2) {
//        index++;
//    }
//    offset = index * scrollView.frame.size.width;
//    [scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _leftButton.userInteractionEnabled = YES;
    _rightButton.userInteractionEnabled = YES;
    [self scrollViewDidEndDecelerating:scrollView];
}


@end
