//
//  HeaderCollectionCell2.m
//  YiShangbao
//
//  Created by simon on 2018/4/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "HeaderCollectionCell2.h"

@implementation HeaderCollectionCell2
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.erWeiMaLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(12.f)];
    self.isNewErWeiMaView.hidden = YES;
    [self.isNewErWeiMaView zx_setCornerRadius:self.isNewErWeiMaView.frame.size.height/2 borderWidth:0 borderColor:nil];
    self.isNewErWeiMaView.image = [UIImage zx_imageWithColor:UIColorFromRGB_HexValue(0xE23728) andSize:self.isNewErWeiMaView.frame.size];
    
    [self.headContainerView zx_setCornerRadius:self.headContainerView.frame.size.height/2 borderWidth:1.f borderColor:nil];
    self.headContainerView.backgroundColor = [UIColor whiteColor];
    [self.headImgView zx_setCornerRadius:self.headImgView.frame.size.height/2 borderWidth:1.f borderColor:nil];
    self.companyNameLab.font = [UIFont boldSystemFontOfSize:LCDScale_5Equal6_To6plus(16.f)];
    

    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    [self.iconsContainerView addSubview:iconsView];
    iconsView.minimumInteritemSpacing = 2.f;
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
  make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];
    UIFont *font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(12.f)];
    self.tradeLevelBtn.titleLabel.font =  font;

//    self.tradeLevelBtn.titleLabel.font = ;
//    UIImage *levelBackgroundImage = [UIImage zx_getGradientImageFromHorizontalTowColorWithSize:CGSizeMake(80, 30) startColor:UIColorFromRGB_HexValue(0xE32626) endColor:UIColorFromRGB_HexValue(0xFD5353)];
//    [self.tradeLevelBtn setBackgroundImage:levelBackgroundImage forState:UIControlStateNormal];
    [self.tradeLevelBtn zx_setCornerRadius:20.f/2 borderWidth:0.5 borderColor:UIColorFromRGB_HexValue(0xE32626)];

    //    粉丝访客容器
    
    self.btnContainerView.backgroundColor = [UIColor whiteColor];
    self.fansNumLab.text = @"0";
    self.visitorNumLab.text = @"0";
    [self.vistitorIsNewImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(LCDScale_iPhone6_Width(8));
    }];
    [self.fansIsNewImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(LCDScale_iPhone6_Width(8));
    }];
    self.fansLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];
    self.fansNumLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(15.f)];
    
    self.visitorLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];
    self.visitorNumLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(15.f)];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
}

//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
//{
//    UIView * view = [super hitTest:point withEvent:event];
//        NSLog(@"%@",view);
////    return view;
////    让子控件有需要响应事件的，返回自己；比如按钮，头像等
//    if ([view isEqual:self.headContainerView])
//    {
//        return view;
//    }
//   else if ([view isEqual:self.companyNameLab])
//    {
//        return view;
//    }
//    return view;
//}

- (void)setData:(id)data
{
    ShopHomeInfoModel *model = (ShopHomeInfoModel *)data;
    
    NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.shopIconURL.absoluteString];
    [self.headImgView sd_setImageWithURL:picUrl placeholderImage:AppPlaceholderShopImage];
    
    NSString *iconurl = [[model.identifierIcons firstObject] iconUrl];
    [self.renZhenImgView sd_setImageWithURL:[NSURL URLWithString:iconurl]];
    
    NSMutableArray *imgIcons = [NSMutableArray array];
    [model.identifierIcons enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    NSArray *imgArray = nil;
    if (imgIcons.count>1)
    {
        imgArray = [imgIcons subarrayWithRange:NSMakeRange(1, imgIcons.count-1)];
    }
    [self.iconsView setData:imgArray];
    
    [self layoutIfNeeded];
    
    
    CGSize size  = [self.iconsView sizeWithContentData:self.iconsView.dataMArray];
    NSLog(@"size =%@",NSStringFromCGSize(size));
    [self.iconsContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo (size.height);
        make.width.mas_equalTo(size.width);
        
    }];
    
    self.companyNameLab.text = model.shopName;
    [self.tradeLevelBtn setTitle:[NSString stringWithFormat:@"交易得分  %@",model.tradeScore] forState:UIControlStateNormal];

    self.tradeLevelBtn.hidden = !ISLOGIN;
    CGSize levelSize = ZX_TEXTSIZE(self.tradeLevelBtn.currentTitle, self.tradeLevelBtn.titleLabel.font);
    [self.tradeLevelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(levelSize.width+self.tradeLevelBtn.frame.size.height);
        
    }];
    if (model)
    {
        if (ISLOGIN)
        {
            self.companyTopLayout.constant = 0;
            self.companyBtnTopLayout.constant = 0;
        }
        else
        {
            self.companyTopLayout.constant = 20;
            self.companyBtnTopLayout.constant = 20;
        }
    }

    self.isNewErWeiMaView.hidden = !model.ercodeReddot;

    
//    粉丝访客容器
    ShopHomeInfoModelFansVisiSub *fansAndVisitor = model.fansAndVisitors;
    
    self.fansNumLab.text = [NSString stringWithFormat:@"%@",fansAndVisitor.fans];
    self.visitorNumLab.text = [NSString stringWithFormat:@"%@",fansAndVisitor.visitors];
    
    self.fansIsNewImgView.hidden = !fansAndVisitor.fansReddot;
    self.vistitorIsNewImgView.hidden = !fansAndVisitor.visitorsReddot;
    
    ShopHomeExposeModel *exposeModel = model.exposeModel;
    self.exposureNumLab.text = exposeModel.exposeNum;
    if ([exposeModel.exposeNum isEqualToString:@"0"])
    {
        self.exposureCenterXLayout.constant = 0;
        self.exposureArrowImgView.hidden = YES;
    }
    else
    {
        self.exposureCenterXLayout.constant = -6;
        self.exposureArrowImgView.hidden = NO;
    }
}


- (void)setNewFansOrVisitor:(BOOL)isNewFans visitor:(BOOL)isNewVisitor
{
    self.fansIsNewImgView.hidden = !isNewFans;
    self.vistitorIsNewImgView.hidden = !isNewVisitor;
}


- (void)setRightAdvData:(advArrModel *)model
{
    self.advBtn.hidden = !model;
    NSURL *url = model.pic?[NSURL URLWithString:model.pic]:nil;
    [self.advBtn sd_setImageWithURL:url forState:UIControlStateNormal];
}
@end
