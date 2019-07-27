//
//  ManageBrandsCell.m
//  YiShangbao
//
//  Created by simon on 17/2/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ManageBrandsCell.h"

@implementation ManageBrandsCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    ZXLabelsInputTagsView *tagsView = [[ZXLabelsInputTagsView alloc] init];
    self.inputTagsView = tagsView;
    [self.contentView addSubview:tagsView];
    
    [self.inputTagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(tagsView.superview.mas_top).offset(0);
        make.bottom.mas_equalTo(tagsView.superview.mas_bottom).offset(0);
        make.left.mas_equalTo(tagsView.superview.mas_left).offset(0);
        make.right.mas_equalTo(tagsView.superview.mas_right).offset(0);
    }];
    
    self.inputTagsView.defaultAddTagTitle = @"添加经营品牌";
    self.inputTagsView.defaultAlertTitle = @"添加经营品牌";
    self.inputTagsView.maxItemCount = 5;
    self.inputTagsView.minimumLineSpacing = 10;
    self.inputTagsView.defaultAlertFieldTextLength = 20;
    self.inputTagsView.addTagTextColor = UIColorFromRGB_HexValue(0x979797);
    self.inputTagsView.addTagBorderColor = UIColorFromRGB_HexValue(0x979797);
}

- (void)setData:(id)data
{
    [self.inputTagsView setData:data];
}

- (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data
{
    return [self.inputTagsView getCellHeightWithContentData:data];
}

@end
