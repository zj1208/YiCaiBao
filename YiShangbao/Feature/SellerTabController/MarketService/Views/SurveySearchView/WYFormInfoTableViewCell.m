//
//  WYFormInfoTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/26.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYFormInfoTableViewCell.h"

@implementation WYFormInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        if(!self.title){
            self.title = [[UILabel alloc] init];
            [self.contentView addSubview:self.title];
            self.title.textColor = WYUISTYLE.colorLTgrey;
            self.title.font = WYUISTYLE.fontWith28;
            self.title.text = @"公司/个人";
            self.title.textAlignment = NSTextAlignmentRight;
        }
        if(!self.content){
            self.content = [[UILabel alloc]init];
            [self.contentView addSubview:self.content];
            self.content.textColor = WYUISTYLE.colorMTblack;
            self.content.font = WYUISTYLE.fontWith30;
            self.content.text = @"翱扩贸易商行";
            self.content.numberOfLines = 0;
        }
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(@12);
            make.width.equalTo(@72);
        }];
        
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(12);
            make.right.equalTo(self.mas_right).offset(-12);
            make.left.equalTo(self.title.mas_right).offset(12);
        }];
    }
    return self;
}

- (float)getAutoCellHeight {
    [self layoutIfNeeded];
    /**
     *    self.最底部的控件.frame.origin.y      为自适应cell中的最后一个控件的Y坐标
     *    self.最底部的空间.frame.size.height   为自适应cell中的最后一个控件的高
     *    marginHeight    为自适应cell中的最后一个控件的距离cell底部的间隙
     */
    return  self.content.frame.origin.y + self.content.frame.size.height + 10;
    
}
@end
