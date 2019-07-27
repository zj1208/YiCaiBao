//
//  WYTradeDetailTableViewCell.h
//  YiShangbao
//
//  Created by simon on 17/1/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYTradeDetailTableViewCell.h"

#define PhotoMargin 10*LCDW/375  //间距
#define ContentWidth LCDW-30

@interface WYTradeDetailTableViewCell ()



@end

@implementation WYTradeDetailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.titleTypeLab.textColor = UIColorFromRGB(69.f, 164.f, 232.f);
    self.contentLab.numberOfLines = 0;
    
    //长按复制功能
//    self.contentLab.isNeedCopy = YES;
//    self.titleLab.isNeedCopy = YES;
//    WS(weakSelf);//此处复制标题+内容拼接到粘贴板
//    self.contentLab.textDidCopyHandler = ^(UILabel * _Nonnull label) {
//        NSMutableString *str = [NSMutableString stringWithFormat:@"%@\n%@", weakSelf.titleLab.text,weakSelf.contentLab.text];
//        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//        [pboard setString:str];
//    };
//    self.titleLab.textDidCopyHandler = ^(UILabel * _Nonnull label) {
//        NSMutableString *str = [NSMutableString stringWithFormat:@"%@\n%@", weakSelf.titleLab.text,weakSelf.contentLab.text];
//        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//        [pboard setString:str];
//    };
    
    [self.headBtn zh_setButtonImageViewScaleAspectFill];
    
    
    UIButton *personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:personBtn];
    _personalBtn = personBtn;

    [personBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.contentView.mas_top).offset(0);
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(55.f);
    }];
    
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    iconsView.minimumInteritemSpacing = 2.f;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];
    
  
}


- (void)setData:(id)data
{
    
    TradeDetailModel *model = (TradeDetailModel *)data;
    NSURL *headUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:[data URL]];
    [self.headBtn sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:AppPlaceholderHeadImage];
    
    
    self.nickNameLab.text = model.userName;
 
    NSMutableArray *imgIcons = [NSMutableArray array];
    [model.buyerBadges enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
    
    
    self.companyLab.text = model.companyName;
    self.numTradeLab.text = [NSString stringWithFormat:@"求购:%@次",model.totalNiches];
    self.numLabLeadingCompanyConstraint.constant = [NSString zhIsBlankString:model.companyName]?0.f:18.f;
    
    self.titleTypeLab.text = model.tradeTypeTitle;
    
    self.titleLab.text =[NSString stringWithFormat:@"%@",model.title];
    self.contentLab.text = [data content];
    
    
    
    
    
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
}


/**

- (CGFloat)getCellHeightWithContentData:(id)data
{
    [self.contentLab setPreferredMaxLayoutWidth:ContentWidth];
    [self.contentLab layoutIfNeeded];
    self.contentLab.text = [data content];
    
   
    [self.contentView layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
//    NSArray *picMArray =[data photosArray];
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
//    CGSize photosViewSize  = [self.photosView sizeWithPhotoCount:picMArray.count photosState:ZXPhotosViewStateDidCompose];
    
    return size.height+1.0f-90+photosViewSize.height ;
}

*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
