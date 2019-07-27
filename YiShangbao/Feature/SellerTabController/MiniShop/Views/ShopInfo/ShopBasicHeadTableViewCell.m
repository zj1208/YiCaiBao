//
//  ShopBasicHeadTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShopBasicHeadTableViewCell.h"

NSString *const ShopBasicHeadTableViewCellID = @"ShopBasicHeadTableViewCellID";

@interface ShopBasicHeadTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation ShopBasicHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius = 20.0;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)name imageName:(NSString *)value{
    self.nameLabel.text = name;
    [self.headImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:value] placeholderImage:[UIImage imageNamed:@"ic_empty_person"]];
}

@end
