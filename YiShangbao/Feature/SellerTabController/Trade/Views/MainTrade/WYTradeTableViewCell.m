//
//  WYTradeTableViewCell.m
//  YiShangbao
//
//  Created by simon on 17/1/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//





#import "WYTradeTableViewCell.h"

#define PhotoMargin 10*LCDW/375  //间距
#define ContentWidth LCDW-30


@interface WYTradeTableViewCell ()



@end
@implementation WYTradeTableViewCell



- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.photoContainerView.backgroundColor = [UIColor whiteColor];
    self.titleTypeLab.textColor = UIColorFromRGB(69.f, 164.f, 232.f);
    [self.goTrade setBackgroundColor:WYUISTYLE.colorMred];
    self.leftTimeLab.backgroundColor = [UIColor whiteColor];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    
    self.contentLab.numberOfLines = 3;
//    [self.goTrade addTarget:self action:@selector(goTradeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.goTrade.userInteractionEnabled = NO;
    
    // 创建一个流水布局photosView(默认为流水布局)
    ZXPhotosView *photoView   = [ZXPhotosView photosView];
    photoView.autoLayoutWithWeChatSytle = YES;
    photoView.photoMaxCount = 6;
    photoView.photoMargin = PhotoMargin;
    photoView.photoWidth = (ContentWidth-PhotoMargin*2)/3;
    photoView.photoHeight = photoView.photoWidth;
    self.photosView = photoView;
    
    photoView.photoModelItemViewBlock = ^(UIView *itemView)
    {
        [itemView zx_setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    };
    [self.photoContainerView addSubview:self.photosView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.photoContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
    
    [self.headBtn zh_setButtonImageViewScaleAspectFill];

    [self.dotImageView zx_setBorderWithRoundItem];
    //打印nib中约束的frame，永远是布局上已有的frame大小，所以在自动布局中，你不能用frame来给动态的值；
//    NSLog(@"self.photoContainerView.frame=%@",NSStringFromCGRect(self.photoContainerView.frame));
    

    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    iconsView.minimumInteritemSpacing = 2.f;
    [self.iconsContainerView addSubview:iconsView];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];
    
    self.contentLab.rectInsets = NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0, 0, -10, 0));
}



- (void)setData:(id)data
{
    WYTradeModel *model = (WYTradeModel *)data;
    
    NSURL *headUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:[data URL].absoluteString];
    [self.headBtn sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:AppPlaceholderHeadImage];
    self.nickNameLab.text = model.userName;
    self.companyLab.text = model.companyName;
    

    self.titleTypeLab.text = model.tradeTypeTitle;
    self.titleLab.text =[NSString stringWithFormat:@"%@",model.title];
    self.contentLab.text = [data content];
    [self.goTrade setTitle:model.orderingBtnModel.buttonTitle forState:UIControlStateNormal];
    if (model.orderingBtnModel.buttonType ==1)
    {
        UIImage *backgroundImage = [WYUTILITY getCommonVersion2RedGradientImageWithSize:_goTrade.frame.size];
        [self.goTrade setBackgroundImage:backgroundImage forState:UIControlStateNormal];
       self.leftTimeLab.text = [NSString stringWithFormat:@"发布时间：%@",model.publishTime];
    }
    else
    {
        UIImage *backgroundImage = [WYUTILITY getCommonVersion2GreenGradientImageWithSize:_goTrade.frame.size];
        [self.goTrade setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        self.leftTimeLab.text = [NSString stringWithFormat:@"发布时间：%@",model.publishTime];
    }
    
    NSMutableArray *imgIcons = [NSMutableArray array];
    [model.buyerBadges enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
    
    CGSize size  = [self.iconsView sizeWithContentData:self.iconsView.dataMArray];
    [self.iconsContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(size.width);
        
    }];
    
    
    self.photoContainerView.hidden = model.photosArray.count>0?NO:YES;
    self.photosView.hidden = self.photoContainerView.hidden;
    
    NSMutableArray *picMArray = [NSMutableArray array];
     [model.photosArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
         AliOSSPicModel *picModel = (AliOSSPicModel *)obj;
         ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:picModel.picURL];
         NSURL *thumbnail_pic = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:picModel.picURL];
        
         photo.thumbnail_pic = thumbnail_pic.absoluteString;
         [picMArray addObject:photo];
         
     }];
    self.photosView.photoModelArray = picMArray;
    self.photosView.userInfo = model.postId;
    
    CGSize size_photo  = [self.photosView sizeWithPhotoCount:self.photosView.photoModelArray.count photosState:ZXPhotosViewStateDidCompose];
    [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(size_photo);
    }];
    



//    if (model.photosArray.count==1)
//    {
//        ZXPhoto *photo = [picMArray firstObject];
//        NSLog(@"%@",photo);
//
//        CGSize photoSize =  [self.photosView getSinglePhotoViewLayoutWithOrignialSize:CGSizeMake(photo.width, photo.height)];
//        self.photosView.photoWidth = photoSize.width;
//        self.photosView.photoHeight = photoSize.height;
//    }
//    else
//    {
//        self.photosView.photoWidth =(ContentWidth-PhotoMargin*2)/3;
//        self.photosView.photoHeight = self.photosView.photoWidth;
//    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];

}




- (CGFloat)getCellHeightWithContentData:(id)data
{

    [self.contentLab setPreferredMaxLayoutWidth:ContentWidth];
    [self.contentLab layoutIfNeeded];
    
    self.contentLab.text = [data content];
    [self.contentView layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    NSArray *picMArray =[data photosArray];
//    if (picMArray.count==1)
//    {
//        AliOSSPicModel *photo = [picMArray firstObject];
//        CGSize photoSize =  [self.photosView getSinglePhotoViewLayoutWithOrignialSize:CGSizeMake(photo.width, photo.height)];
//        self.photosView.photoWidth = photoSize.width;
//        self.photosView.photoHeight = photoSize.height;
//    }
//    else
//    {
//        self.photosView.photoWidth =(ContentWidth-PhotoMargin*2)/3;
//        self.photosView.photoHeight = self.photosView.photoWidth;
//
//    }
    CGSize photosViewSize  = [self.photosView sizeWithPhotoCount:picMArray.count photosState:ZXPhotosViewStateDidCompose];

    return size.height+1.0f-90+photosViewSize.height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//- (void)goTradeAction:(UIButton *)sender
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(haveTrade:)]) {
//        [self.delegate haveTrade:self];
//    }
//}

@end
