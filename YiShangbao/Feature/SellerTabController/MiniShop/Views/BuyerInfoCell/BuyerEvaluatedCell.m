//
//  BuyerEvaluatedCell.m
//  YiShangbao
//
//  Created by simon on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BuyerEvaluatedCell.h"

NSString *const BuyerEvaluatedCellID = @"BuyerEvaluatedCellID";

@implementation BuyerEvaluatedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(EvaluateInfoModel *)data
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:data.icon] placeholderImage:[UIImage imageNamed:@"ic_touxiang"]];
    self.nickNameLab.text = data.nickname;
    self.evaluateTypeNameLab.text = data.score_s;
    self.evaluateContentLab.text = data.content;
    self.dateLab.text = data.createTime;
    
}
@end
