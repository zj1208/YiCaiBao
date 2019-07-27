//
//  FreightListTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/4/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "FreightListTableViewCell.h"
#import "AddProductModel.h"

NSString *const FreightListTableViewCellID = @"FreightListTableViewCellID";

@interface FreightListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@end

@implementation FreightListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentLabel.text = NSLocalizedString(@"详情", @"详情");
    [self.arrowImageView setImage:[UIImage imageNamed:@"right_arrow"]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateModel:(FreightTemplateModel *)model{
    self.nameLabel.text = model.fname;
    [self.selectedImageView setImage:[UIImage imageNamed:@"ic_weixuanzhong"]];
}

- (void)selectedCell{
    [self.selectedImageView setImage:[UIImage imageNamed:@"ic_xuanzhong"]];
}

@end
