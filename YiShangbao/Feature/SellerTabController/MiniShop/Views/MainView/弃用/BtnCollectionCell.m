//
//  BtnCollectionCell.m
//  YiShangbao
//
//  Created by simon on 17/3/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BtnCollectionCell.h"

@implementation BtnCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(13.f)];
    UIImage *normal = [UIImage imageNamed:@"pic_dot"];
    normal =[normal resizableImageWithCapInsets:UIEdgeInsetsMake(0,normal.size.width/2, 0,normal.size.width/2)];
    [self.badgeOrderBtn setBackgroundImage:normal forState:UIControlStateNormal];
    self.imgViewLayoutWidth.constant = LCDScale_5Equal6_To6plus(30.f);
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setData:(id)data
{
    ShopInfoWidgetsModel *model = (ShopInfoWidgetsModel *)data;
    [self.iconImgView sd_setImageWithURL:model.iconURL placeholderImage:AppPlaceholderImage];
    
    self.titleLab.text = model.desc;
    NSString *badge = [NSString stringWithFormat:@"  %@  ",model.num];
    [self.badgeOrderBtn setTitle:badge forState:UIControlStateNormal];
    [self.badgeImageView sd_setImageWithURL:[NSURL URLWithString:model.badgeIcon]];
    self.badgeOrderBtn.hidden = [model.num isEqualToNumber:@(0)];
    self.badgeImageView.hidden = model.badgeIcon.length==0?YES:NO;
    if (!self.badgeOrderBtn.hidden  && !self.badgeImageView.hidden)
    {
        self.badgeImageView.hidden = !self.badgeOrderBtn.hidden;
    }
}
@end
