//
//  WYSellerMineHeadTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/10/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYSellerMineHeadTableViewCell.h"
NSString * const WYSellerMineHeadTableViewCellID = @"WYSellerMineHeadTableViewCellID";

//@implementation WYSellerFunctionView
//
//- (id)init{
//    self = [super init];
//    if (!self) return nil;
//
//    self.numberLabel = [[UILabel alloc]init];
//    [self addSubview:self.numberLabel];
//    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(16);
//        make.centerX.equalTo(self);
//        make.left.equalTo(self);
//        make.right.equalTo(self);
//    }];
//
//    self.nameLabel = [[UILabel alloc]init];
//    [self addSubview:self.nameLabel];
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.numberLabel.mas_bottom).offset(10);
//        make.centerX.equalTo(self);
//        make.left.equalTo(self);
//        make.right.equalTo(self);
//    }];
//
//    self.button = [[UIButton alloc]init];
//    [self addSubview:self.button];
//    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.left.equalTo(self);
//        make.right.equalTo(self);
//        make.bottom.equalTo(self);
//    }];
//
//    self.numberLabel.font = [UIFont systemFontOfSize:18];
//    self.numberLabel.textColor = [UIColor colorWithHex:0x535353];
//    self.numberLabel.textAlignment = NSTextAlignmentCenter;
//    self.nameLabel.font = [UIFont systemFontOfSize:13];
//    self.nameLabel.textColor = [UIColor colorWithHex:0x757575];
//    self.nameLabel.textAlignment = NSTextAlignmentCenter;
//
//    self.numberLabel.text = @"0";
//
//    return self;
//}
//
//@end

@interface WYSellerMineHeadTableViewCell()

@property (nonatomic ,strong) UIImageView *headImageView;
@property (nonatomic ,strong) UILabel *nameLabel;

@property (nonatomic ,strong) NSString *integralString;

@end

@implementation WYSellerMineHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.integralString = @" 积分 ";
    
    UIView *headBackView = [[UIView alloc]init];
    [self.contentView addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@55);
        make.height.equalTo(@55);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    self.headImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@55);
        make.height.equalTo(@55);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    self.integralButton = [[UIButton alloc]init];
    [self.contentView addSubview:self.integralButton];
    [self.integralButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@30);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(92);
        make.right.lessThanOrEqualTo(self.integralButton.mas_left).offset(-25);
    }];
    
    self.headButton = [[UIButton alloc]init];
    [self.contentView addSubview:self.headButton];
    [self.headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.integralButton.mas_left).offset(-20);
    }];
    
//    self.pushProductView = [[WYSellerFunctionView alloc]init];
//    [self.contentView addSubview:self.pushProductView];
//    [self.pushProductView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView);
//        make.height.equalTo(@84);
//        make.bottom.equalTo(self.contentView);
//    }];
//
//    self.clearInventoryView = [[WYSellerFunctionView alloc]init];
//    [self.contentView addSubview:self.clearInventoryView];
//    [self.clearInventoryView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.pushProductView.mas_right);
//        make.height.equalTo(@84);
//        make.bottom.equalTo(self.contentView);
//        make.width.equalTo(self.pushProductView);
//    }];
//
//    self.acceptBusinessView = [[WYSellerFunctionView alloc]init];
//    [self.contentView addSubview:self.acceptBusinessView];
//    [self.acceptBusinessView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.clearInventoryView.mas_right);
//        make.height.equalTo(@84);
//        make.bottom.equalTo(self.contentView);
//        make.width.equalTo(self.pushProductView);
//    }];
//
//    self.wantBuyView = [[WYSellerFunctionView alloc]init];
//    [self.contentView addSubview:self.wantBuyView];
//    [self.wantBuyView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.acceptBusinessView.mas_right);
//        make.right.equalTo(self.contentView);
//        make.height.equalTo(@84);
//        make.bottom.equalTo(self.contentView);
//        make.width.equalTo(self.pushProductView);
//    }];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 27.5;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.image = [UIImage imageNamed:@"ic_empty_person"];
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    headBackView.layer.cornerRadius = 27.5;
    headBackView.layer.shadowColor = [UIColor colorWithHex:0x5D6E7A].CGColor;
    headBackView.layer.shadowOffset = CGSizeMake(0,5);
    headBackView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    headBackView.layer.shadowRadius = 5;//阴影半径，默认3
    
    self.nameLabel.textColor = [UIColor colorWithHex:0x222222];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
//    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.integralButton setImage:[UIImage imageNamed:@"ic_liwu"] forState:UIControlStateNormal];
    [self.integralButton setTitle:[NSString stringWithFormat:@"%@0",self.integralString] forState:UIControlStateNormal];
    [self.integralButton setBackgroundColor:[UIColor colorWithHex:0xFFF5F6]];
    [self.integralButton setTitleColor:[UIColor colorWithHex:0xCF271D] forState:UIControlStateNormal];
    [self.integralButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    self.integralButton.layer.borderWidth = 0.5;
    self.integralButton.layer.borderColor = [UIColor colorWithHex:0xCF271D].CGColor;
    self.integralButton.layer.cornerRadius = 15.0;
    self.integralButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.startPoint = CGPointMake(0, 0);
//    gradient.endPoint = CGPointMake(1, 0);
//    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFFB45E].CGColor,(id)[UIColor colorWithHex:0xFF6950].CGColor, nil];
//    gradient.frame = CGRectMake(0, 0, SCREEN_WIDTH, 194);
//    [self.contentView.layer insertSublayer:gradient atIndex:0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)updateData:(UserModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:model.headURL] placeholderImage:[UIImage imageNamed:@"pic_weidenglu"] options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    if ([UserInfoUDManager isLogin]) {
        self.nameLabel.text = model.nickname;
        [self.integralButton setTitle:[NSString stringWithFormat:@"%@%@",self.integralString,model.score ? model.score : @""] forState:UIControlStateNormal];
    }else{
        self.nameLabel.text = @"点击登录";
        [self.integralButton setTitle:@" 未登录" forState:UIControlStateNormal];
    }
    
//    if (model.record){
//        self.pushProductView.numberLabel.text = [NSString stringWithFormat:@"%@",model.record.prodCount];
//        self.clearInventoryView.numberLabel.text = [NSString stringWithFormat:@"%@",model.record.stockCount];
//        self.acceptBusinessView.numberLabel.text = [NSString stringWithFormat:@"%@",model.record.bizCount];
//        self.wantBuyView.numberLabel.text = [NSString stringWithFormat:@"%@",model.record.subjectCount];
//    } else{
//        self.pushProductView.numberLabel.text = @"0";
//        self.clearInventoryView.numberLabel.text = @"0";
//        self.acceptBusinessView.numberLabel.text = @"0";
//        self.wantBuyView.numberLabel.text = @"0";
//    }
//
//    self.pushProductView.nameLabel.text = @"推产品";
//    self.clearInventoryView.nameLabel.text = @"清库存";
//    self.acceptBusinessView.nameLabel.text = @"接生意";
//    self.wantBuyView.nameLabel.text = @"求购";
}
@end
