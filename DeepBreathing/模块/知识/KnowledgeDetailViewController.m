//
//  KnowledgeDetailViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-23.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "KnowledgeDetailViewController.h"

@interface KnowledgeDetailViewController ()

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation KnowledgeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
}

#pragma mark - getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = ({
        
            UIWebView * webView = [[UIWebView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 64, 320, 568-64) adjustWidth:![DHFoundationTool iPhone4]]];
            webView;
        
        });
    }
    
    return _webView;
}

#pragma mark - setter
// 通过重写setter来传值

- (void)setWebContent:(NSString *)webContent
{
    if ([webContent isEqualToString:_webContent]) {
        return;
    }
    
    _webContent = webContent;
    [self.webView loadHTMLString:webContent baseURL:[NSURL URLWithString:@""]];
}

@end
