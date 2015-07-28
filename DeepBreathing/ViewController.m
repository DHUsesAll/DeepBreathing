//
//  ViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-15.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSArray * array;
@property (nonatomic, copy) NSMutableArray * mutableArray;

@property (nonatomic, strong) NSString * string;
@property (nonatomic, copy) NSString * strByCopy;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableString * string = [NSMutableString stringWithFormat:@"hello"];
//    self.string = string;
    self.strByCopy = string;
    
    [string appendString:@" world!"];
    
    NSLog(@"%@ \n %@",self.string,self.strByCopy);
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:@[@"aaa",@"bbb"]];
    self.mutableArray = array;

    [array addObject:@"ccc"];
    [array removeObject:@"aaa"];
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(80, 80, 100, 100)];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
    
    [UIView animateWithDuration:1 animations:^{
        
        view.center = CGPointMake(200, 200);
        
    }];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 2;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(50, 50)];
    
    [view.layer addAnimation:animation forKey:@"aaa"];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.name forKey:@"name"];
}

@end
