//
//  FreightTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/4/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "FreightTableViewCell.h"

NSString *const FreightTableViewCellID = @"FreightTableViewCellID";

@interface FreightTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation FreightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.arrowImageView setImage:[UIImage imageNamed:@"right_arrow"]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleString:(NSString *)titleString{
    self.nameLabel.text = titleString;
    self.contentLabel.text = @"";
    self.arrowImageView.hidden = YES;
    [self.selectedImageView setImage:[UIImage imageNamed:@"ic_weixuanzhong"]];
    
}

- (void)setTitleString:(NSString *)titleString contentString:(NSString *)contentString{
    [self setTitleString:titleString];
    self.contentLabel.text = contentString;
    self.arrowImageView.hidden = NO;
}

- (void)selectedCell{
    [self.selectedImageView setImage:[UIImage imageNamed:@"ic_xuanzhong"]];
}

@end
