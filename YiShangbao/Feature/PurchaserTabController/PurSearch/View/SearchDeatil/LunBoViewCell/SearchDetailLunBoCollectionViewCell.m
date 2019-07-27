//
//  SearchDetailLunBoCollectionViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/7/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SearchDetailLunBoCollectionViewCell.h"

@implementation SearchDetailLunBoCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self changeUI];
    
}
-(void)changeUI
{
    
    //    阴影
    self.yinyingView.layer.shadowColor = [WYUISTYLE colorWithHexString:@"E7E7E7"].CGColor;
    self.yinyingView.layer.shadowOffset = CGSizeMake(0,1);
    self.yinyingView.layer.shadowOpacity = 0.6;;
    self.yinyingView.layer.shadowRadius = 4.f;

    self.contentView.layer.masksToBounds = YES;
//    self.contentView.layer.shadowRadius = 4.f;
    
    self.gotoBtn.layer.masksToBounds = YES;
    self.gotoBtn.layer.cornerRadius = self.gotoBtn.frame.size.height/2;
    self.gotoBtn.layer.borderWidth = 0.5;
    self.gotoBtn.layer.borderColor = [WYUISTYLE colorWithHexString:@"F58F23"].CGColor;
    
    self.touxiangImageView.layer.masksToBounds = YES;
    self.touxiangImageView.layer.cornerRadius = 20.f;
    
    //icons
    [self updateConstraintsIfNeeded];
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    iconsView.minimumInteritemSpacing = 4.f;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];

}

/**
 协议方法
 
 @param data <#data description#>
 */
-(void)setJLCycSrollCellData:(id)data
{
    SearchLunBoModel* model =(SearchLunBoModel *)data;
    NSURL *url =  [NSURL URLWithString:model.headPicUrl];
    [self.touxiangImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:url] placeholderImage:AppPlaceholderShopImage options:SDWebImageRetryFailed | SDWebImageRefreshCached ];
    
    self.shangpuNameLabel.text = model.name;
    self.jinyingLabel.text = model.businessAgeAndMode;
    self.addressLabel.text = model.address;
    self.mainSellLabel.text = model.mainSell;
    
    if ([NSString zhIsBlankString:model.payMark]) {
        self.tuiguangContentView.hidden = YES;
        self.tuiguangLabel.text = @"";
    }else{
        self.tuiguangContentView.hidden = NO;
        self.tuiguangLabel.text = model.payMark;
    }
    
    //icons
    NSMutableArray *imgIcons = [NSMutableArray array];
    [model.icons enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
    
    
    
//    [self.shangpuNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_lessThanOrEqualTo(self.gotoBtn.mas_left).offset(-72.f).priority(1000);
//    }];
//    if ([model.badges isEqualToNumber:@(0)]) {
//        
//        self.jinpaiImageView.hidden = YES;
//        self.shichangImageView.image = [UIImage imageNamed:@"weirenzheng"];
//        [self.shangpuNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_lessThanOrEqualTo(self.gotoBtn.mas_left).offset(-55.f).priority(1000);
//        }];
//    }else if ([model.badges isEqualToNumber:@(1)]){//实体认证/市场
//        
//        self.jinpaiImageView.hidden = YES;
//        self.shichangImageView.image = [UIImage imageNamed:@"yilenzheng"];
//        [self.shangpuNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_lessThanOrEqualTo(self.gotoBtn.mas_left).offset(-55.f).priority(1000);
//        }];
//        
//    }else if ([model.badges isEqualToNumber:@(2)]){//重点商家／金牌
//        self.jinpaiImageView.hidden = NO;
//        self.shichangImageView.image = [UIImage imageNamed:@"weirenzheng"];
//        
//        [self.shangpuNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_lessThanOrEqualTo(self.gotoBtn.mas_left).offset(-72.f).priority(1000);
//        }];
//    }else if ([model.badges isEqualToNumber:@(3)]){
//        self.jinpaiImageView.hidden = NO;
//        self.shichangImageView.image = [UIImage imageNamed:@"yilenzheng"];
//        [self.shangpuNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_lessThanOrEqualTo(self.gotoBtn.mas_left).offset(-72.f).priority(1000);
//        }];
//    }
    

    
}


@end
