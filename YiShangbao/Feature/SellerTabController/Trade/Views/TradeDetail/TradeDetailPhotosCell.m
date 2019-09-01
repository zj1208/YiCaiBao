//
//  TradeDetailPhotosCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/6/6.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "TradeDetailPhotosCell.h"


#define PhotoMargin 10*LCDW/375  //间距
#define ContentWidth LCDW-30

@implementation TradeDetailPhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.photoContainerView.backgroundColor = [UIColor whiteColor];
    // 创建一个流水布局photosView(默认为流水布局)
    ZXPhotosView *photoView   = [ZXPhotosView photosView];
    photoView.autoLayoutWithWeChatSytle = YES;
    photoView.photoMargin = PhotoMargin;
    photoView.photoWidth = (ContentWidth-PhotoMargin*2)/3;
    photoView.photoHeight = photoView.photoWidth;
    self.photosView = photoView;
    //设置边框
    photoView.photoModelItemViewBlock = ^(UIView *itemView)
    {
        [itemView zx_setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    };
    [self.photoContainerView addSubview:self.photosView];
    
    
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.photoContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];
    
}
- (void)setData:(id)data
{
    
    TradeDetailModel *model = (TradeDetailModel *)data;
   
    NSMutableArray *picMArray = [NSMutableArray array];
    [model.photosArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AliOSSPicModel *picModel = (AliOSSPicModel *)obj;
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:picModel.picURL];
        NSURL *thumbnail_pic = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:picModel.picURL];
        photo.thumbnail_pic = thumbnail_pic.absoluteString;
        photo.width = picModel.width;
        photo.height = picModel.height;
        [picMArray addObject:photo];
        
    }];
    self.photosView.photoModelArray = picMArray;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size  = [self.photosView sizeWithPhotoCount:self.photosView.photoModelArray.count photosState:ZXPhotosViewStateDidCompose];
    [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {

        make.size.mas_equalTo(size);
    }];
}

-(CGFloat)getCellHeightWithContentData:(id)data
{
    NSArray *picMArray =[data photosArray];
    CGSize photosViewSize  = [self.photosView sizeWithPhotoCount:picMArray.count photosState:ZXPhotosViewStateDidCompose];
    
    return photosViewSize.height +10;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
