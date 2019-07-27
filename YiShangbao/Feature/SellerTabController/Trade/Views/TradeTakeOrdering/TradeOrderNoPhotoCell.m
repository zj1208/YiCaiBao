//
//  TradeOrderNoPhotoCell.m
//  YiShangbao
//
//  Created by simon on 17/1/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeOrderNoPhotoCell.h"

#define PhotoMargin 15*LCDW/375  //间距
#define ContentWidth LCDW-20

@implementation TradeOrderNoPhotoCell

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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.label.hidden = YES;
    self.picBtn.hidden = YES;
    
//    self.label.text = [NSString stringWithFormat:@"上传真实的图片(最多9张)\n多角度展现商品特征，有助于成交哦~"];
    ZXAddPicCollectionView *picView = [[ZXAddPicCollectionView alloc] init];
    picView.maxItemCount = 9;
    picView.minimumInteritemSpacing = 12.f;
    picView.photosState = ZXPhotosViewStateWillCompose;
    picView.sectionInset = UIEdgeInsetsMake(5, 15, 10, 15);
    picView.picItemWidth = [picView getItemAverageWidthInTotalWidth:LCDW columnsCount:4 sectionInset:picView.sectionInset minimumInteritemSpacing:picView.minimumInteritemSpacing];
    picView.picItemHeight = picView.picItemWidth;
    
    picView.addButtonPlaceholderImage = [UIImage imageNamed:ZXAddPhotoImageName];
    NSString *string =  [NSString stringWithFormat:@"上传产品图或您的名片，最多9张\n80%%的商户都上传了图片哦~"];
    NSRange range = [string rangeOfString:@"80%的商户都上传了图片哦~"];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB_HexValue(0xFF5434) range:range];
    NSAttributedString *att = [attString addLineSpace:5.f];
    picView.addPicCoverView.titleLabel.attributedText = att;
    picView.addPicCoverView.titleLabLeading.constant = 23.f;
    
    self.picsCollectionView = picView;
    [self.contentView addSubview:picView];
    

    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(picView.superview.mas_top).offset(0);
        make.bottom.mas_equalTo(picView.superview.mas_bottom).offset(0);
        make.left.mas_equalTo(picView.superview.mas_left).offset(0);
        make.right.mas_equalTo(picView.superview.mas_right).offset(0);
    }];
}

- (void)setData:(id)data
{
    [self.picsCollectionView setData:data];
}
@end
