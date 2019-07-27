//
//  Survey_EmptyView.m
//  YiShangbao
//
//  Created by 何可 on 2017/3/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "Survey_EmptyView.h"

@implementation Survey_EmptyView

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.image_view = [[UIImageView alloc] init];
    [self addSubview:self.image_view];
    self.label_title = [[UILabel alloc] init];
    [self addSubview:self.label_title];
    
    //样式
    self.image_view.image = [UIImage imageNamed:@"空经侦"];
    self.label_title.textColor  = WYUISTYLE.colorSTgrey;
    self.label_title.font = WYUISTYLE.fontWith32;
    
    
    //位置
    [self.image_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.label_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image_view.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
    }];

    return self;
}


@end
