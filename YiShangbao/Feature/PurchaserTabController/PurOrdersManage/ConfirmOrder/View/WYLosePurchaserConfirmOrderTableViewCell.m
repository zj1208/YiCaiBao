//
//  WYLosePurchaserConfirmOrderTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYLosePurchaserConfirmOrderTableViewCell.h"
#import "WYPlaceOrderModel.h"

NSString * const WYLosePurchaserConfirmOrderTableViewCellID = @"WYLosePurchaserConfirmOrderTableViewCellID";

@interface WYLosePurchaserConfirmOrderTableViewCell()

@property (nonatomic ,strong) UIImageView *goodsImageView;
@property (nonatomic ,strong) UIImageView *loseImageView;

@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *goodsInfolabel;
@property (nonatomic ,strong) UILabel *tipLabel;

@end

@implementation WYLosePurchaserConfirmOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.goodsImageView = [[UIImageView alloc]init];
    [self.goodsImageView setImage:AppPlaceholderImage];
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImageView.layer.borderColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.goodsImageView.layer.borderWidth = 1.0;
    self.goodsImageView.layer.cornerRadius = 4.0;
    self.goodsImageView.layer.masksToBounds = YES;
    [self addSubview:self.goodsImageView];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@93);
        make.height.equalTo(@93);
    }];
    
    self.loseImageView = [[UIImageView alloc]init];
    [self.loseImageView setImage:[UIImage imageNamed:@"pic_shixiao_mengceng"]];
    [self addSubview:self.loseImageView];
    [self.loseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.goodsImageView);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = [UIColor colorWithHex:0xB1B1B1];
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    
    self.goodsInfolabel = [[UILabel alloc]init];
    self.goodsInfolabel.font = [UIFont systemFontOfSize:11];
    self.goodsInfolabel.textColor = [UIColor colorWithHex:0xB1B1B1];
    [self addSubview:self.goodsInfolabel];
    [self.goodsInfolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor colorWithHex:0x535353];
    self.tipLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    
    self.tipLabel.text = @"该产品已不能购买，请联系卖家";
    
    return self;
}

- (void)updateData:(id)model{
    if ([model isKindOfClass:[WYConfirmOrderInvalidGoodsModel class]]){
        WYConfirmOrderInvalidGoodsModel *goodsModel = model;
        self.titleLabel.text = goodsModel.itemTitle;
        self.goodsInfolabel.text = goodsModel.skuInfo;
        [self.goodsImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:goodsModel.itemPic] placeholderImage:AppPlaceholderImage];
        self.tipLabel.text = goodsModel.reason;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
