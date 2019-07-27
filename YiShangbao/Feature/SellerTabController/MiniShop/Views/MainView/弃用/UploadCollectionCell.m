//
//  UploadCollectionCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UploadCollectionCell.h"

@implementation UploadCollectionCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLab1.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];
    self.titleLab2.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];

    UIImage *normal = [UIImage imageNamed:@"pic_dot"];
    normal =[normal resizableImageWithCapInsets:UIEdgeInsetsMake(0,normal.size.width/2, 0,normal.size.width/2)];
    [self.badgeOrderBtn2 setBackgroundImage:normal forState:UIControlStateNormal];
    self.viewContainer1.backgroundColor = [UIColor whiteColor];
    self.viewContainer2.backgroundColor = [UIColor whiteColor];

    
}


- (void)setData:(id)data
{
//    ShopInfoWidgetsModel *model = (ShopInfoWidgetsModel *)data;
//    [self.iconImgView sd_setImageWithURL:model.iconURL placeholderImage:AppPlaceholderImage];
//    
    
//    self.badgeImageView.hidden = NO;
//    self.badgeOrderBtn.hidden = !self.badgeImageView.hidden;
//    [self.badgeImageView sd_setImageWithURL:model.iconURL placeholderImage:nil];
    NSArray *array = (NSArray *)data;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ShopInfoWidgetsModel *model = (ShopInfoWidgetsModel *)obj;
        NSString *badge = [NSString stringWithFormat:@"  %@  ",model.num];
        if (idx ==0)
        {
            [self.iconImgView1 sd_setImageWithURL:model.iconURL placeholderImage:AppPlaceholderImage];
            self.titleLab1.text = model.desc;
         
            [self.badgeOrderBtn1 setTitle:badge forState:UIControlStateNormal];
            [self.badgeImageView1 sd_setImageWithURL:[NSURL URLWithString:model.badgeIcon]];
            self.badgeOrderBtn1.hidden = [model.num isEqualToNumber:@(0)];
            self.badgeImageView1.hidden = model.badgeIcon.length==0?YES:NO;
            if (!self.badgeOrderBtn1.hidden  && !self.badgeImageView1.hidden)
            {
                self.badgeImageView1.hidden = !self.badgeOrderBtn1.hidden;
            }
        }
        else
        {
            [self.iconImgView2 sd_setImageWithURL:model.iconURL placeholderImage:AppPlaceholderImage];
            self.titleLab2.text = model.desc;
            
            [self.badgeOrderBtn2 setTitle:badge forState:UIControlStateNormal];
            [self.badgeImageView2 sd_setImageWithURL:[NSURL URLWithString:model.badgeIcon]];
            self.badgeOrderBtn2.hidden = [model.num isEqualToNumber:@(0)];
            self.badgeImageView2.hidden = model.badgeIcon.length==0?YES:NO;
            if (!self.badgeOrderBtn2.hidden  && !self.badgeImageView2.hidden)
            {
                self.badgeImageView2.hidden = !self.badgeOrderBtn2.hidden;

            }
        }
        
    }];
    
}

- (void)setNData
{

}

@end
