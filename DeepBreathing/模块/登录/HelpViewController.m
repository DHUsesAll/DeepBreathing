//
//  HelpViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-20.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "HelpViewController.h"
#import "DHConvenienceAutoLayout.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * image = IMAGE_WITH_NAME(@"帮助.png");
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.bounds = [DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, image.size.width/2, image.size.height/2) adjustWidth:YES];
    imageView.center = self.view.center;
    
    [self.view addSubview:imageView];
}

@end
