//
//  ModifyPriceProCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ModifyPriceProCell.h"

@implementation ModifyPriceProCell

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
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [self.editBtn setTitleColor:UIColorFromRGB_HexValue(0x45A4E8) forState:UIControlStateNormal];
    [self.editBtn setTitleColor:UIColorFromRGB_HexValue(0xFF5434) forState:UIControlStateSelected];
    [self.editBtn setBackgroundColor:[UIColor whiteColor]];

    [self.picImageView setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
        
    [self sendSubviewToBack:self.contentView];

}


- (void)setData:(id)data
{
    GetConfirmOrderModelSub *model = (GetConfirmOrderModelSub *)data;
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.prodPic] placeholderImage:AppPlaceholderImage];
    //名字
    self.productNameLab.text = model.prodName;
    self.skuInfoLab.text = model.skuInfo;
    //价格，原价
    self.priceLab.text = model.price;
    //数量
    self.quantityLab.text = [NSString stringWithFormat:@"×%@",model.quantity];
    
    //展示新的价格 textField/Label
     self.nPriceLab.text = [NSString stringWithFormat:@"¥%@",model.finalPrice];
    //如果小数点不是0，则展示小数点数据；如果小数点后是0，则只展示整数；
    self.nPriceTextField.text = [model.finalPrice doubleValue]>floor([model.finalPrice doubleValue])? model.finalPrice:[@(lrint([model.finalPrice doubleValue])) stringValue];
    self.nPriceTextField.hidden = !model.isEditing;
    self.nPriceLab.hidden = !self.nPriceTextField.hidden;
    //总价
    self.totalPriceLab.text = [NSString stringWithFormat:@"总价：¥%@",model.totalPrice];
    if (model.ndiscount<=0)
    {
        self.discountLab.textColor = [UIColor colorWithRed:69.f/255 green:164.f/255 blue:232.f/255 alpha:1];
        self.discountLab.text = [NSString stringWithFormat:@"折扣：-¥%.2f",ABS(model.ndiscount)];
    }
    else
    {
        self.discountLab.textColor = [UIColor colorWithRed:255.f/255 green:84.f/255 blue:52.f/255 alpha:1];
        self.discountLab.text = [NSString stringWithFormat:@"折扣：+¥%.2f",ABS(model.ndiscount)];
    }
    
}

//- (void)editBtnAction:(UIButton *)sender
//{
////    NSIndexPath *indexPath = [self.tableView zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:sender];
//    sender.selected = !sender.selected;
//    self.nPriceTextField.hidden = !sender.selected;
//    self.nPriceLab.hidden = !self.nPriceTextField.hidden;
//}

@end
