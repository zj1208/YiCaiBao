//
//  InfosServiceTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/8/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "InfosServiceTableViewCell.h"
#import "SurveyModel.h"

NSString *const InfosServiceTableViewCellID = @"InfosServiceTableViewCellID";

@interface InfosServiceTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation InfosServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateDate:(id)data{
    SurveyModel *model = (SurveyModel *)data;
    [self.imgView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:model.imageUrl] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.createTime;
}

@end
