//
//  DHRoundedSelector.m
//  HealthManagement
//
//  Created by DreamHack on 14-10-14.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import "DHRoundedSelector.h"
#import "DHVector.h"
#import "DHConvenienceAutoLayout.h"

@interface DHRoundedSelector ()
{
    NSInteger selection;
    CAGradientLayer * shadowLayer;
}

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) UIImage * image;
@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSMutableArray * vectors;

@end

@implementation DHRoundedSelector
{
    CGPoint origin;
}

- (void)dealloc
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.image = nil;
    self.vectors = nil;
}

- (instancetype)initWithCenter:(CGPoint)center circleRadius:(CGFloat)radius backgroundImage:(UIImage *)image selectionNumber:(NSInteger)number delegate:(id<DHRoundedSelectorDelegate>) delegate;
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.radius = radius;
        self.center = center;
        self.image = image;
        self.number = number;
        self.vectors = [NSMutableArray arrayWithCapacity:0];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = image;
        [self addSubview:imageView];
        shadowLayer = [CAGradientLayer layer];
        shadowLayer.frame = self.bounds;
        shadowLayer.colors = @[(id)[UIColor groupTableViewBackgroundColor].CGColor, (id)[UIColor darkGrayColor].CGColor];
        shadowLayer.startPoint = CGPointMake(0.5, 0.5);
        shadowLayer.endPoint = CGPointMake(0.5, 0.5);
        shadowLayer.opacity = 0.11;
        shadowLayer.hidden = YES;
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = 35.f * [DHConvenienceAutoLayout iPhone5VerticalMutiplier];
        shapeLayer.frame = self.bounds;
        
        self.layer.cornerRadius = radius;
        
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius-22.f * [DHConvenienceAutoLayout iPhone5VerticalMutiplier] startAngle:0 endAngle:M_PI*2 clockwise:YES];
        shapeLayer.fillColor = [[UIColor clearColor]CGColor];
        shapeLayer.strokeColor = [[UIColor redColor] CGColor];
        shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
        
        shapeLayer.path = path.CGPath;
        
        shadowLayer.mask = shapeLayer;
        [self.layer addSublayer:shadowLayer];
        
        //
        CGFloat referenceHeight = self.bounds.size.height;
        
//        CGFloat startRadian = -M_PI/_number;
        CGFloat segmentRadian = M_PI*2/_number;
        origin = [DHVector openGLPointFromUIKitPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) referenceHeight:referenceHeight];
        DHVector * originVector = [[DHVector alloc] initWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(_radius, 0)];
        [originVector translationToPoint:origin];
        
        [originVector rotateClockwiselyWithRadian:segmentRadian/2];
        for (int i = 0; i < _number; i++) {
            
            DHVector * vector = [DHVector vectorWithVector:originVector];
            [originVector rotateClockwiselyWithRadian:segmentRadian];
            [[self vectors] addObject:vector];
        }
        
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    shadowLayer.hidden = NO;
    UITouch * aTouch = [touches anyObject];
    
    CGPoint position = [aTouch locationInView:self];
    
    shadowLayer.endPoint = CGPointMake(position.x/(_radius*2), position.y/(_radius*2));
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * aTouch = [touches anyObject];
    
    CGPoint position = [aTouch locationInView:self];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    if ((position.x-center.x)*(position.x-center.x)+(position.y-center.y)*(position.y-center.y) >= self.radius*self.radius) {
        shadowLayer.hidden = YES;
        return;
    }
    shadowLayer.endPoint = CGPointMake(position.x/(_radius*2), position.y/(_radius*2));
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * aTouch = [touches anyObject];
    
    CGPoint position = [aTouch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if ((position.x-center.x)*(position.x-center.x)+(position.y-center.y)*(position.y-center.y) >= self.radius*self.radius) {
        return;
    }
    shadowLayer.hidden = YES;
    
    DHVector * touchVector = [[DHVector alloc] initWithStartPoint:origin endPoint:[DHVector openGLPointFromUIKitPoint:position referenceHeight:self.bounds.size.height]];
    
    for (int i = 0; i < _number; i++) {
        DHVector * vector = self.vectors[i];
        if ([touchVector clockwiseAngleToVector:vector] < M_PI*2/_number) {
            selection = i;
            break;
        }
        
    }

    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(roundedSelector:didSelectItemAtIndex:touchPosition:)]) {
        [self.delegate roundedSelector:self didSelectItemAtIndex:selection touchPosition:position];
    }
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, radius*2, radius*2);
    
}


@end
