//
//  WYEvaluateTagsCollectionViewCell.m
//  YiShangbao
//
//  Created by light on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYEvaluateTagsCollectionViewCell.h"

NSString *const WYEvaluateTagsCollectionViewCellID = @"WYEvaluateTagsCollectionViewCellID";

@interface WYEvaluateTagsCollectionViewCell ()

@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WYEvaluateTagsCollectionViewCell

//- (id)initWithCoder:(NSCoder *)aDecoder{
//
//}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
        [_imageView setImage:[UIImage imageNamed:@"icon_red_gou"]];
        
        _tagLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_tagLabel];
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(7);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-7);
        }];
        _tagLabel.textColor = [UIColor colorWithHex:0x999999];
        _tagLabel.font = [UIFont systemFontOfSize:14.0];
        self.imageView.hidden = YES;
        
        self.contentView.layer.cornerRadius = 2.0;
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.borderColor = [UIColor colorWithHex:0xE1E2E3].CGColor;
    }
    return self;
}

- (void)setData:(NSString *)name{
    _tagLabel.text = name;
}

- (void)setIsSelected:(BOOL)isSelected{
//    [super setSelected:isSelected];
    _isSelected = isSelected;
    if (isSelected) {
        self.tagLabel.textColor = [UIColor colorWithHex:0xFF5434];
        self.contentView.layer.borderColor = [UIColor colorWithHex:0xFF5434].CGColor;
    }else{
        self.tagLabel.textColor = [UIColor colorWithHex:0x999999];
        self.contentView.layer.borderColor = [UIColor colorWithHex:0xE1E2E3].CGColor;
    }
    self.imageView.hidden = !isSelected;
}

@end
