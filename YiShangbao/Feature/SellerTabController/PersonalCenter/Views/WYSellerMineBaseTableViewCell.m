//
//  WYSellerMineBaseTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/10/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYSellerMineBaseTableViewCell.h"
#import "YYText.h"

NSString * const WYSellerMineBaseTableViewCellID = @"WYSellerMineBaseTableViewCellID";

@interface WYSellerMineBaseTableViewCell()

@property (nonatomic, strong) UIImageView *iconImgaeView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation WYSellerMineBaseTableViewCell

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
    
    self.iconImgaeView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconImgaeView];
    [self.iconImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(45);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.arrowImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.contentLabel = [[YYLabel alloc]init];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.nameLabel.font = [UIFont systemFontOfSize:15.0];
    self.nameLabel.textColor = [UIColor colorWithHex:0x757575];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    self.contentLabel.textColor = [UIColor colorWithHex:0xB1B1B1];
    self.contentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    self.arrowImageView.image = [UIImage imageNamed:@"pic-jiantou"];
    return self;
}

- (void)updateImageName:(NSString *)iconName name:(NSString *)name content:(NSString *)content showArrow:(BOOL)isShow contentLeftImageName:(NSString *)imageName{
    [self updateImageName:iconName name:name content:content showArrow:isShow];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:content];
    one.yy_color = self.contentLabel.textColor;
    UIImage *image = [UIImage imageNamed:imageName];
    image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:self.contentLabel.font alignment:YYTextVerticalAlignmentCenter];
    
    [text appendAttributedString:attachText];
    [text appendAttributedString:one];
    
    self.contentLabel.attributedText = text;
}

- (void)updateImageName:(NSString *)iconName name:(NSString *)name content:(NSString *)content showArrow:(BOOL)isShow contentRightImageName:(NSString *)imageName{
    [self updateImageName:iconName name:name content:content showArrow:isShow];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:content];
    one.yy_color = self.contentLabel.textColor;
    UIImage *image = [UIImage imageNamed:imageName];
    image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:self.contentLabel.font alignment:YYTextVerticalAlignmentCenter];
    
    [text appendAttributedString:one];
    [text appendAttributedString:attachText];
    
    self.contentLabel.attributedText = text;
}

- (void)updateImageName:(NSString *)iconName name:(NSString *)name content:(NSString *)content showArrow:(BOOL)isShow{
    
    [self.iconImgaeView setImage:[UIImage imageNamed:iconName]];
    self.nameLabel.text = name;
    self.contentLabel.text = content;
    self.arrowImageView.hidden = !isShow;
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-10 + !isShow * 20);
    }];
    
    if (isShow) {
        self.contentLabel.textColor = [UIColor colorWithHex:0xB1B1B1];
    }else{
        self.contentLabel.textColor = [UIColor colorWithHex:0x45A4E8];
    }
}



@end
