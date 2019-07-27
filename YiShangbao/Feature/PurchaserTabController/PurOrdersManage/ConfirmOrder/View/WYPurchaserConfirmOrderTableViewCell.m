//
//  WYPurchaserConfirmOrderTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserConfirmOrderTableViewCell.h"
#import "WYPlaceOrderModel.h"
#import "UIImageView+WebCache.h"

NSString * const WYPurchaserConfirmOrderTableViewCellID = @"WYPurchaserConfirmOrderTableViewCellID";

@interface WYPurchaserConfirmOrderTableViewCell()

@property (nonatomic ,strong) UIView *backgroundColorView;
@property (nonatomic ,strong) UIImageView *goodsImageView;

@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *detailInfoLabel;
@property (nonatomic ,strong) UILabel *minCountLabel;
@property (nonatomic ,strong) UILabel *priceLabel;
@property (nonatomic ,strong) UILabel *countLabel;

@end

@implementation WYPurchaserConfirmOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.backgroundColorView = [[UIView alloc]init];
    self.backgroundColorView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    self.backgroundColorView.layer.cornerRadius = 4.0;
    [self addSubview:self.backgroundColorView];
    [self.backgroundColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.bottom.equalTo(self).offset(-2);
        make.left.equalTo(self).offset(4);
        make.right.equalTo(self).offset(-4);
    }];
    
    self.goodsImageView = [[UIImageView alloc]init];
    [self.goodsImageView setImage:AppPlaceholderImage];
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImageView.layer.borderColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.goodsImageView.layer.borderWidth = 1.0;
    self.goodsImageView.layer.cornerRadius = 4.0;
    self.goodsImageView.layer.masksToBounds = YES;
    [self addSubview:self.goodsImageView];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.equalTo(@93);
        make.height.equalTo(@93);
    }];
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.priceLabel.font = [UIFont systemFontOfSize:16];
    self.priceLabel.textAlignment =NSTextAlignmentRight;
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_top);
        make.right.equalTo(self).offset(-15);
        make.width.mas_lessThanOrEqualTo(@80);
    }];
    
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.textColor = [UIColor colorWithHex:0xB1B1B1];
    self.countLabel.font = [UIFont systemFontOfSize:13];
    self.countLabel.textAlignment =NSTextAlignmentRight;
    [self addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-15);
        make.width.mas_lessThanOrEqualTo(@80);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.numberOfLines = 2;
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_top);
        make.left.equalTo(self.goodsImageView.mas_right).offset(13);
//        make.right.equalTo(self.priceLabel.mas_left).offset(-20);
        make.right.equalTo(self).offset(-105);
    }];
    
    self.detailInfoLabel = [[UILabel alloc]init];
    self.detailInfoLabel.textColor = [UIColor colorWithHex:0xB1B1B1];
    self.detailInfoLabel.font = [UIFont systemFontOfSize:11];
//    self.detailInfoLabel.numberOfLines = 2;
    [self addSubview:self.detailInfoLabel];
    [self.detailInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        make.left.equalTo(self.goodsImageView.mas_right).offset(13);
//        make.right.equalTo(self.countLabel.mas_left).offset(-20);
        make.right.equalTo(self).offset(-105);
    }];
    
    self.minCountLabel = [[UILabel alloc]init];
    self.minCountLabel.textColor = [UIColor colorWithHex:0xB1B1B1];
    self.minCountLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.minCountLabel];
    [self.minCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailInfoLabel.mas_bottom).offset(6);
        make.left.equalTo(self.goodsImageView.mas_right).offset(13);
    }];
    
    
    
    [self.priceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.countLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateData:(id)model{
    if ([model isKindOfClass:[WYConfirmOrderGoodsModel class]]) {
        WYConfirmOrderGoodsModel *goodsModel = model;
        
        [self.goodsImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:goodsModel.itemPic] placeholderImage:AppPlaceholderImage];
        self.nameLabel.text = goodsModel.itemTitle;
        self.detailInfoLabel.text = goodsModel.skuInfo;
        self.minCountLabel.text = [NSString stringWithFormat:@"起订量：%ld", goodsModel.minQuantity];
        self.priceLabel.text = goodsModel.itemPrice;
        self.countLabel.text = [NSString stringWithFormat:@"x%ld", goodsModel.quantity];
    }
    
}

@end
