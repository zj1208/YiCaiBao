//
//  LinkmanHeadCollectionViewCell.m
//  YiShangbao
//
//  Created by light on 2018/4/10.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "LinkmanHeadCollectionViewCell.h"

NSString *const LinkmanHeadCollectionViewCellID = @"LinkmanHeadCollectionViewCellID";

@implementation LinkmanHeadCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.headImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.headImageView.layer.cornerRadius = 20.0;
        self.headImageView.layer.masksToBounds = YES;
    }
    return self;
}

@end
