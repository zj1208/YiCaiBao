//
//  OpenShopBaseTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "OpenShopBaseTableViewCell.h"

NSString *const OpenShopBaseTableViewCellID = @"OpenShopBaseTableViewCellID";

@interface OpenShopBaseTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation OpenShopBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImageView.layer.cornerRadius = 15.0f;
    self.headImageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTitle:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder{
    self.titleLabel.text = title;
    self.contentLabel.text = placeholder;
    self.contentLabel.textColor = [UIColor colorWithHex:0xCCCCCC];
    if (content.length > 0) {
        self.contentLabel.text = content;
        self.contentLabel.textColor = [UIColor colorWithHex:0x222222];
    }
}

- (void)updateImageWithUrl:(NSString *)url{
    if (url.length > 0) {
        [self.headImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:url] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached];
        self.contentLabel.hidden = YES;
    }else{
        self.contentLabel.hidden = NO;
    }
}

@end
