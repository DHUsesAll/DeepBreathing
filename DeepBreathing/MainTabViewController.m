//
//  MainTabViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "MainTabViewController.h"
#import "DHConvenienceAutoLayout.h"
#import "DHFoundationTool.h"

#define BUTTON_TAG  100

@interface MainTabViewController ()

@property (nonatomic, strong) NSArray * viewControllers;
@property (nonatomic, strong) UIView * tabBar;
@property (nonatomic, weak) UIButton * currentButton;

@end

@implementation MainTabViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        self.viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)initialize
{
    // tab bar
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabBar];
    
    // add controllers
    
    [self addChildViewController:self.viewControllers[0]];
}

- (void)addChildViewController:(UIViewController *)childController
{
    childController.view.frame = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 320, 568-50) adjustWidth:![DHFoundationTool iPhone4]];
    [self.view addSubview:childController.view];
    [super addChildViewController:childController];
    [childController didMoveToParentViewController:self];
}

#pragma mark - getter
- (UIView *)tabBar
{
    if (!_tabBar) {
        _tabBar = ({
        
            UIView * view = [[UIView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 568-50, 320, 50) adjustWidth:![DHFoundationTool iPhone4]]];
            
            CGFloat width = CGRectGetWidth(view.bounds)/self.viewControllers.count;
            
            // 初始化bar的按钮
            for (int i = 0; i < self.viewControllers.count; i++) {
                // 正常状态下的图片
                NSString * imageName = [NSString stringWithFormat:@"100%d-0.png",i];
                
                // 选中的图片的名字
                NSString * selectedName = [NSString stringWithFormat:@"100%d-1.png",i];
                
                UIImage * image = IMAGE_WITH_NAME(imageName);
                UIImage * selectedImage = IMAGE_WITH_NAME(selectedName);
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                if (i == 0) {
                    self.currentButton = button;
                    button.selected = YES;
                }
                
                button.frame = CGRectMake(i*width, 0, width, 50);
                button.tag = BUTTON_TAG+i;
                [button setImage:image forState:UIControlStateNormal];
                [button setImage:image forState:UIControlStateHighlighted];
                [button setImage:selectedImage forState:UIControlStateSelected];
                
                [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
            }
            
            view;
        
        });
    }
    
    return _tabBar;
}


#pragma mark - button action
- (void)onButton:(UIButton *)sender
{
    _currentButton.selected = NO;
    sender.selected = YES;
    
    NSInteger currentIndex = _currentButton.tag - BUTTON_TAG;
    UIViewController * currentViewController = [self.viewControllers objectAtIndex:currentIndex];
    [currentViewController removeFromParentViewController];
    [currentViewController.view removeFromSuperview];
    [currentViewController willMoveToParentViewController:nil];
    
    UIViewController * controller = [self.viewControllers objectAtIndex:sender.tag - BUTTON_TAG];
    [self addChildViewController:controller];
    
    _currentButton = sender;
    
    
}

@end
