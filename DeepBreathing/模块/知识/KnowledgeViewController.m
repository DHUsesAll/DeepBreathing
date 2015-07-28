//
//  KnowledgeViewController.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-16.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "NetworkingManager+Knowledge.h"
#import "KnowledgeModel.h"
#import "KnowledgeCell.h"
#import "UIKit+AFNetworking.h"
#import "KnowledgeViewModel.h"


#import "KnowledgeDetailViewController.h"
@interface KnowledgeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) KnowledgeModel * model;
@property (nonatomic, strong) KnowledgeViewModel * viewModel;

@end

@implementation KnowledgeViewController

- (void)dealloc
{
    // 移除观察者
    [self.model removeObserver:self forKeyPath:@"knowledgeData"];
    self.model = nil;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.model addObserver:self forKeyPath:@"knowledgeData" options:NSKeyValueObservingOptionNew context:nil];

    
    [self.model getKnowledgeDataList];
    [self initializeAppearance];
}

- (void)initializeAppearance
{
    UILabel * navigationBar = [[UILabel alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 320, 64) adjustWidth:![DHFoundationTool iPhone4]]];
    navigationBar.backgroundColor = [UIColor whiteColor];
    navigationBar.text = @"哮喘知识";
    navigationBar.textColor = THEME_TEXT_COLOR;
    navigationBar.font = [UIFont systemFontOfSize:22*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
    navigationBar.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:navigationBar];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"knowledgeData"]) {
        
        [self.viewModel prepareWithData:self.model.knowledgeData];
        
        if (![self.viewModel isRequestSuccess]) {
            [DHFoundationTool showAlertInController:self withTitle:@"温馨提示" infoMessage:@"数据请求失败，请刷新"];
        } else {
            
            [self.tableView reloadData];
        }
        
    }
}

#pragma mark - getter
- (KnowledgeModel *)model
{
    if (!_model) {
        _model = [[KnowledgeModel alloc] init];
    }
    
    return _model;
}

- (KnowledgeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[KnowledgeViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
        
            UITableView * tableView = [[UITableView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 64, 320, 568-64-50) adjustWidth:![DHFoundationTool iPhone4]] style:UITableViewStyleGrouped];
            tableView.dataSource = self;
            tableView.delegate = self;
            [tableView registerClass:[KnowledgeCell class] forCellReuseIdentifier:@"cellIdf"];
            
            tableView;
        });
    }
    
    return _tableView;
}

#pragma mark - table view protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KnowledgeCell * cell = (KnowledgeCell *)[tableView dequeueReusableCellWithIdentifier:@"cellIdf"];
    cell.cellInfo = [self.viewModel cellInfoAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*[DHConvenienceAutoLayout iPhone5VerticalMutiplier];
}

// section之间的间距设为10
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KnowledgeDetailViewController * detailVC = [[KnowledgeDetailViewController alloc] initWithTitle:[self.viewModel titleAtIndexPath:indexPath]];
    detailVC.webContent = [self.viewModel contentsAtIndexPath:indexPath];
    
    [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
}

@end
