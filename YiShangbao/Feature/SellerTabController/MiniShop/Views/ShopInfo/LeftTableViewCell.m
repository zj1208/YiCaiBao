//
//  LeftTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "LeftTableViewCell.h"

@interface LeftTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *line;

@end
@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.name = [[UILabel alloc] init];
        [self.contentView addSubview:self.name];
        self.name.numberOfLines = 0;
        self.name.font = WYUISTYLE.fontWith28;
        self.name.textColor = WYUISTYLE.colorMTblack;
        self.name.highlightedTextColor = WYUISTYLE.colorMTblack;
        self.name.textAlignment = NSTextAlignmentCenter;
    
        self.yellowView = [[UIView alloc] init];
        [self.contentView addSubview:self.yellowView];
        self.yellowView.backgroundColor = WYUISTYLE.colorMred;
        
        self.line = [[UIView alloc] init];
        [self.contentView addSubview:self.line];
        self.line.backgroundColor = WYUISTYLE.colorLinegrey;
        
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@80);
        }];
        
        [self.yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.width.equalTo(@5);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(self.contentView.mas_left);
            make.width.equalTo(self.contentView.mas_width);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    self.contentView.backgroundColor = selected ? WYUISTYLE.colorBGgrey : WYUISTYLE.colorBWhite;
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
