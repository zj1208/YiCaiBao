//
//  WYChoosePayWayTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/9/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYChoosePayWayTableViewCell.h"
#import "WYPublicModel.h"

NSString * const WYChoosePayWayTableViewCellID = @"WYChoosePayWayTableViewCellID";

@interface WYChoosePayWayTableViewCell()

@property (nonatomic ,strong) UIImageView *headImageView;
@property (nonatomic ,strong) UIImageView *selectedImageView;
@property (nonatomic ,strong) UIImageView *recommendImageView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *subTitleLabel;
@property (nonatomic ,strong) UILabel *contentLabel;

@end

@implementation WYChoosePayWayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.headImageView = [[UIImageView alloc]init];
    [self addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@29);
        make.height.equalTo(@29);
    }];
    
    UIView *backView = [[UIView alloc]init];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(59);
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView);
        make.left.equalTo(backView);
        make.height.equalTo(@20);
    }];
    
    self.subTitleLabel = [[UILabel alloc]init];
    self.subTitleLabel.textColor = [UIColor colorWithHex:0xF58F23];
    self.subTitleLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right);
    }];
    
    self.recommendImageView = [[UIImageView alloc]init];
    self.recommendImageView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:self.recommendImageView];
    [self.recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.subTitleLabel.mas_right).offset(5);
//        make.right.lessThanOrEqualTo(backView).offset(-40);
        make.width.equalTo(@34);
//        make.height.equalTo(@15);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = [UIColor colorWithHex:0x9D9D9D];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    [backView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    
    self.selectedImageView = [[UIImageView alloc]init];
    [backView addSubview:self.selectedImageView];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.right.equalTo(backView).offset(-15);
    }];
    
//    [self.recommendImageView setImage:[UIImage imageNamed:@"pic_tuijian"]];
    return self;
}

- (void)updateData:(id)model{
    if ([model isKindOfClass:[WYPayWayModel class]]) {
        WYPayWayModel *payWayModel = model;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:payWayModel.icon] placeholderImage:AppPlaceholderImage];
        self.titleLabel.text = payWayModel.way;
//        self.subTitleLabel.text = ;
        self.contentLabel.text = payWayModel.intro;
        self.contentLabel.numberOfLines = 2;
        [self.selectedImageView setImage:[UIImage imageNamed:@"ic_choose_nor_gray"]];
        [self.recommendImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:payWayModel.pic]];
//        if (payWayModel.pic.length){
//            self.recommendImageView.hidden = NO;
//        }else{
//            self.recommendImageView.hidden = YES;
//        }
    }
}

- (void)isSelect:(BOOL)isSelect{
    if (self.isRedHook){
        [self.selectedImageView setImage:[UIImage imageNamed:isSelect ? @"ic_xuanze" : @"ic_choose_nor_gray"]];
    }else{
        [self.selectedImageView setImage:[UIImage imageNamed:isSelect ? @"ic_choose_sel" : @"ic_choose_nor_gray"]];
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
