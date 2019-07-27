//
//  MakeBillPicsTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillPicsTableViewCell.h"

#define PhotoMargin 10*LCDW/375  //间距
#define ContentWidth LCDW-57

NSString *const MakeBillPicsTableViewCellID = @"MakeBillPicsTableViewCellID";

@interface MakeBillPicsTableViewCell ()

@end

@implementation MakeBillPicsTableViewCell

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
    
}

- (id)init{
    
    self = [super init];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZXAddPicCollectionView *picView = [[ZXAddPicCollectionView alloc] init];
    picView.collectionView.backgroundColor = [UIColor clearColor];
    picView.maxItemCount = 9;
    picView.minimumInteritemSpacing = 12.f;
    picView.photosState = ZXPhotosViewStateDidCompose;
    picView.sectionInset = UIEdgeInsetsMake(5, 12, 10, 12);
    picView.picItemWidth = [picView getItemAverageWidthInTotalWidth:LCDW columnsCount:4 sectionInset:picView.sectionInset minimumInteritemSpacing:picView.minimumInteritemSpacing];
    picView.picItemHeight = picView.picItemWidth;
    picView.addButtonPlaceholderImage = [UIImage imageNamed:@"postImage"];
    
    picView.addPicCoverView.titleLabel.text = [NSString stringWithFormat:@""];
    
    self.picsCollectionView = picView;
    [self.contentView addSubview:picView];
    
    [self.picsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(picView.superview.mas_top).offset(0);
        make.bottom.mas_equalTo(picView.superview.mas_bottom).offset(0);
        make.left.mas_equalTo(picView.superview.mas_left).offset(0);
        make.right.mas_equalTo(picView.superview.mas_right).offset(0);
    }];
    [ZXAddPicViewKit resetLayoutConfig];
    return self;
}


- (void)setData:(id)data{
    [self.picsCollectionView setData:data];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
