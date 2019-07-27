//
//  CircularDetailCaseTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CircularDetailCaseTableViewCell.h"
#import "SurveyModel.h"

@implementation CircularDetailCaseTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.backgroundColor = WYUISTYLE.colorBWhite;
    
    self.title = [[UILabel alloc] init];
    [self addSubview:self.title];
    self.content = [[UILabel alloc] init];
    [self addSubview:self.content];
    self.content.textAlignment = NSTextAlignmentLeft;
    self.content.numberOfLines = 0;
    self.line = [[UIView alloc] init];
    [self addSubview:self.line];
    
    //样式
    self.title.textColor = WYUISTYLE.colorLTgrey;
    self.title.font = WYUISTYLE.fontWith28;
    self.content.textColor = WYUISTYLE.colorMTblack;
    self.content.font = WYUISTYLE.fontWith30;
    self.line.backgroundColor = WYUISTYLE.colorLinegrey;
    
    //位置
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.left.equalTo(self.title.mas_right).offset(12);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    return self;
}
- (float)getAutoCellHeight:(BOOL)selected {
//    /**
//     *    self.最底部的控件.frame.origin.y      为自适应cell中的最后一个控件的Y坐标
//     *    self.最底部的空间.frame.size.height   为自适应cell中的最后一个控件的高
//     *    marginHeight    为自适应cell中的最后一个控件的距离cell底部的间隙
//     */
//    return  self.content.frame.origin.y + self.content.frame.size.height + 10;
    
    if (selected) {
        NSString *str = self.content.text;
        UIFont *font = [UIFont systemFontOfSize:15];
        NSDictionary *dic = @{NSFontAttributeName:font};
        CGRect rect = [str boundingRectWithSize:CGSizeMake(LCDW-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
        NSLog(@"%@",NSStringFromCGRect(rect));
        return (self.content.frame.origin.y +rect.size.height + 12);
    }else{
        return 44;
    }
}

- (float)getEditAutoCellHeight{
    [self layoutIfNeeded];
    /**
     *    self.最底部的控件.frame.origin.y      为自适应cell中的最后一个控件的Y坐标
     *    self.最底部的空间.frame.size.height   为自适应cell中的最后一个控件的高
     *    marginHeight    为自适应cell中的最后一个控件的距离cell底部的间隙
     */
    NSString *str = self.content.text;
    UIFont *font = [UIFont systemFontOfSize:16];
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(LCDW-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    NSLog(@"%@",NSStringFromCGRect(rect));
    return (self.content.frame.origin.y +rect.size.height + 12);
}
@end
