//
//  CircularListTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CircularListTableViewCell.h"
#import "SurveyModel.h"

@implementation CircularListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.lbl_title = [[UILabel alloc] init];
    [self addSubview:self.lbl_title];
    self.lbl_title.textColor = WYUISTYLE.colorMTblack;
    self.lbl_title.font = WYUISTYLE.fontWith28;
    
    self.lbl_time = [[UILabel alloc] init];
    [self addSubview:self.lbl_time];
    self.lbl_time.textColor = WYUISTYLE.colorLTgrey;
    self.lbl_time.font = WYUISTYLE.fontWith24;
    self.lbl_time.textAlignment = NSTextAlignmentRight;
    
    [self.lbl_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(@18);
        make.right.equalTo(self.lbl_time.mas_left).offset(-24);
    }];
    [self.lbl_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lbl_title.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-18);
        make.width.equalTo(@74);
    }];
    return self;
}

-(void)setData:(id)data{
    CircularListModel *model = (CircularListModel *)data;
    self.lbl_title.text = model.companyname;
    self.lbl_time.text = model.escapedateVO;
}

@end
