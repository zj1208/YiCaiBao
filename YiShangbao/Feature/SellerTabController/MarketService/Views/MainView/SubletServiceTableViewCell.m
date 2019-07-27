//
//  SubletServiceTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/8/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SubletServiceTableViewCell.h"
#import "CCLabel.h"
#import "ServiceModel.h"

NSString *const SubletServiceTableViewCellID = @"SubletServiceTableViewCellID";

@interface SubletServiceTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet CCLabel *tagLabel1;
@property (weak, nonatomic) IBOutlet CCLabel *tagLabel2;
@property (weak, nonatomic) IBOutlet CCLabel *tagLabel3;

@end

@implementation SubletServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tagLabel1.layer.borderWidth = 0.5;
    self.tagLabel1.layer.borderColor = [UIColor colorWithHex:0x45A4E8].CGColor;
    self.tagLabel1.layer.cornerRadius = 1.0;
    self.tagLabel1.textColor = [UIColor colorWithHex:0x45A4E8];
    
    self.tagLabel2.layer.borderWidth = 0.5;
    self.tagLabel2.layer.borderColor = [UIColor colorWithHex:0xFFB315].CGColor;
    self.tagLabel2.layer.cornerRadius = 1.0;
    self.tagLabel2.textColor = [UIColor colorWithHex:0xFFB315];
    
    self.tagLabel3.layer.borderWidth = 0.5;
    self.tagLabel3.layer.borderColor = [UIColor colorWithHex:0xFF5434].CGColor;
    self.tagLabel3.layer.cornerRadius = 1.0;
    self.tagLabel3.textColor = [UIColor colorWithHex:0xFF5434];
    
    self.tagLabel1.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);//设置内边距
    self.tagLabel2.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);//设置内边距
    self.tagLabel3.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);//设置内边距
    [self.tagLabel1 sizeToFit];
    [self.tagLabel2 sizeToFit];
    [self.tagLabel3 sizeToFit];
    
    if (SCREEN_WIDTH <= 320){
        self.tagLabel3.hidden = YES;
    }
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateDate:(id)data{
    ServiceModel *model = (ServiceModel *)data;
    self.iconImageView.hidden = !model.isRecommend.integerValue;
    [self.imgImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:model.picOne] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    
    self.titleLabel.text = model.titleValue;
    self.tagLabel1.text = model.subindustryValue;
    self.tagLabel2.text = model.typeValue;
    self.tagLabel3.text = model.boothmodelValue;
    self.timeLabel.text = model.createTimeValue;
}

@end
