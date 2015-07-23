//
//  KnowledgeCell.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-23.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "KnowledgeCell.h"
#import "UIKit+AFNetworking.h"

NSString * const kKnowledgeCellInfoImageKey = @"kKnowledgeCellInfoImageKey";

NSString * const kKnowledgeCellInfoTitleKey = @"kKnowledgeCellInfoTitleKey";

NSString * const kKnowledgeCellInfoDateKey = @"kKnowledgeCellInfoDateKey";

@interface KnowledgeCell ()

@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * dateLabel;

@end

@implementation KnowledgeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headerImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.dateLabel];
    }
    
    return self;
}

#pragma mark - getter
- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(0, 0, 100, 100) adjustWidth:YES]];
        _headerImageView = imageView;
    }
    
    return _headerImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
        
            UILabel * label = [[UILabel alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionScale|DHAutoLayoutOptionPosition iPhone5Frame:CGRectMake(105, 15, 200, 18) adjustWidth:![DHFoundationTool iPhone4]]];
            
            
            label.font = [UIFont systemFontOfSize:18*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
            label.textColor = THEME_TEXT_COLOR;
            label;
        
        });
    }
    
    return _titleLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = ({
        
            UILabel * label = [[UILabel alloc] initWithFrame:[DHConvenienceAutoLayout frameWithLayoutOption:DHAutoLayoutOptionPosition|DHAutoLayoutOptionScale iPhone5Frame:CGRectMake(235, 75, 80, 12) adjustWidth:![DHFoundationTool iPhone4]]];
            label.font = [UIFont systemFontOfSize:12*[DHConvenienceAutoLayout iPhone5VerticalMutiplier]];
            label.textColor = [UIColor lightGrayColor];
            label;
        
        });
    }
    return _dateLabel;
}

#pragma mark - setter
- (void)setCellInfo:(NSDictionary *)cellInfo
{
    if (cellInfo == _cellInfo) {
        return;
    }
    _cellInfo = cellInfo;
    NSString * imageUrl = cellInfo[kKnowledgeCellInfoImageKey];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.titleLabel.text = cellInfo[kKnowledgeCellInfoTitleKey];
    self.dateLabel.text = cellInfo[kKnowledgeCellInfoDateKey];
}

@end
