//
//  ShareLinkmanHeaderView.m
//  YiShangbao
//
//  Created by light on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShareLinkmanHeaderView.h"

NSString *const ShareLinkmanHeaderViewID = @"ShareLinkmanHeaderViewID";

@implementation ShareLinkmanHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(23.0);
            make.centerY.equalTo(self.contentView);
        }];
        self.titleLabel.textColor = [UIColor colorWithHex:0x535353];
        self.titleLabel.font = [UIFont systemFontOfSize:13.0];
        self.titleLabel.text = @"";
        
        self.imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15.0);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@3.5);
            make.height.equalTo(@15.0);
        }];
        [self.imageView setImage:[UIImage imageNamed:@"ic_line"]];
        
        self.contentView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
//        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
