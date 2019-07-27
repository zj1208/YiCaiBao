//
//  WYSelectBankCardTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYSelectBankCardTableViewCell.h"

#import "ShopModel.h"
@implementation WYSelectBankCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellData:(id)data
{
    AcctInfoModel* model = data;
    
   NSURL* url = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.bankIcon];
    [self.bankIMV sd_setImageWithURL:url placeholderImage:nil];
    
    self.bankNameLabel.text = [NSString stringWithFormat:@"%@",model.bankValue];
    self.userNameLabel.text = [NSString stringWithFormat:@"%@",model.acctName] ;
    self.bankCardLabel.text  =[NSString stringWithFormat:@"%@",model.bankNo] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
