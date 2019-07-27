//
//  WYTitleTagVIew.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/19.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYTitleTagVIew.h"

@implementation WYTitleTagVIew

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.image_left = [[UIImageView alloc] init];
    [self addSubview:self.image_left];
    self.label_title = [[UILabel alloc] init];
    [self addSubview:self.label_title];
//    self.label_more = [[UILabel alloc] init];
//    [self addSubview:self.label_more];
//    self.image_right = [[UIImageView alloc] init];
//    [self addSubview:self.image_right];
    
    //样式
    self.image_left.image = [UIImage imageNamed:@"Rectangle 2"];
    self.label_title.textColor  = WYUISTYLE.colorMTblack;
        self.label_title.font = WYUISTYLE.fontWith28;
//    self.label_more.text = @"更多";
//    self.image_right.image = [UIImage imageNamed:@"向右箭头"];

    
    //位置
    [self.image_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@4);
        make.height.equalTo(@14);
    }];
    [self.label_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image_left.mas_right).offset(5);
        make.centerY.equalTo(self.mas_centerY);
    }];
//    [self.image_right mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right);
//        make.centerY.equalTo(self.mas_centerY);
//        make.width.equalTo(@36);
//        make.height.equalTo(@36);
//    }];
//    [self.label_more mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.image_right.mas_left);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
    return self;
}

@end
