//
//  RefundingContentCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "RefundingContentCell.h"

@implementation RefundingContentCell

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
    self.labelsTagsView.maxItemCount = 3;
    self.labelsTagsView.apportionsItemWidthsByContent = NO;
    [self.labelsTagsView setCollectionViewLayoutWithEqualSpaceAlign:AlignWithRight withItemEqualSpace:10.f animated:NO];

    self.btnContainerView.backgroundColor = [UIColor redColor];
    self.labelsTagsView.backgroundColor = [UIColor orangeColor];

}

- (void)setData:(id)data
{
    OMRefundDetailInfoModel *model = (OMRefundDetailInfoModel *)data;
    [self.statusIconImgView sd_setImageWithURL:[NSURL URLWithString:model.statusIcon] placeholderImage:[UIImage imageNamed:@"ic_tuikuanzhong"]];
    self.statusDespLab.text = model.statusDesp;
    self.statusTimeAboutLab.text = model.statusTimeAbout;
    if (model.reminders.count >0)
    {
        self.reminder1Lab.text = [model.reminders objectAtIndex:0];
        self.reminder2Lab.text = [model.reminders objectAtIndex:1];
    }
    NSMutableArray *titleArray = [NSMutableArray array];
    [model.buttons enumerateObjectsUsingBlock:^(OrderButtonModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [titleArray addObject:obj.name];
    }];
    [self.labelsTagsView setData:titleArray];
    
    if (model.buttons.count ==0)
    {
        [self.btnContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(0);
            make.bottom.mas_greaterThanOrEqualTo(self.contentView.mas_bottom).offset(0);
        }];

    }
}


- (CGFloat)getCellHeightWithContentData:(id)data
{
    [self.reminder1Lab setPreferredMaxLayoutWidth:LCDW-30];
    [self.reminder2Lab setPreferredMaxLayoutWidth:LCDW-30];
    self.reminder2Lab.numberOfLines = 0;
    self.reminder1Lab.numberOfLines = 0;
    [self.reminder1Lab layoutIfNeeded];
    [self.reminder2Lab layoutIfNeeded];
    OMRefundDetailInfoModel *model = (OMRefundDetailInfoModel *)data;
    if (model.reminders.count >0)
    {
        self.reminder1Lab.text = [model.reminders objectAtIndex:0];
        self.reminder2Lab.text = [model.reminders objectAtIndex:1];
    }
    [self.contentView layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (model.buttons.count ==0)
    {
        return size.height-50.f;
    }
    return size.height;
}
@end
