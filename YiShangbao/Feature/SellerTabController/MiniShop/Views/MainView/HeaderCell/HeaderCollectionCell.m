//
//  HeaderCollectionCell.m
//  YiShangbao
//
//  Created by simon on 17/3/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "HeaderCollectionCell.h"
@implementation HeaderCollectionCell

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


    self.topContainerView.backgroundColor = UIColorFromRGB_HexValue(0xBF352D);
    
    [self.cardContainerView zx_setShadowAndCornerRadius:6.f borderWidth:0 borderColor:nil shadowColor:[UIColor blackColor] shadowOpacity:0.2 shadowOffset:CGSizeMake(0, 0) shadowRadius:5.f];
    
    self.erWeiMaLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(12.f)];
    self.isNewErWeiMaView.hidden = YES;
    [self.isNewErWeiMaView zx_setCornerRadius:self.isNewErWeiMaView.frame.size.height/2 borderWidth:0 borderColor:nil];
    self.isNewErWeiMaView.image = [UIImage zx_imageWithColor:UIColorFromRGB_HexValue(0xE23728) andSize:self.isNewErWeiMaView.frame.size];
    
    
    
    [self.headContainerView zx_setCornerRadius:self.headContainerView.frame.size.height/2 borderWidth:1.f borderColor:nil];
    self.headContainerView.backgroundColor = [UIColor whiteColor];
    [self.headImgView zx_setCornerRadius:self.headImgView.frame.size.height/2 borderWidth:1.f borderColor:nil];
    
    self.companyNameLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(16.f)];

    
    self.btnContainerView.backgroundColor = [UIColor whiteColor];
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    [self.iconsContainerView addSubview:iconsView];
    iconsView.minimumInteritemSpacing = 2.f;
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
    
    self.fansNumLab.text = @"0";
    self.visitorNumLab.text = @"0";
    [self.vistitorIsNewImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(LCDScale_iPhone6_Width(8));
    }];
    [self.fansIsNewImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(LCDScale_iPhone6_Width(8));
    }];

    self.fansNumLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(15.f)];
    self.visitorNumLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(15.f)];
    self.fansLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(13.f)];
    self.visitorLab.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(13.f)];
    
//    [self.advBtn setTitle:nil forState:UIControlStateNormal];
//    [self.advBtn setBackgroundColor:[UIColor clearColor]];
//    [self.advBtn zh_setButtonImageViewScaleAspectFill];
//  编辑信息按钮
    [self.editInfomationBtn setBackgroundColor:[UIColor clearColor]];
    
}

- (UIImage *)getGradientImageWithSize:(CGSize)size
                            locations:(const CGFloat[])locations
                           components:(const CGFloat[])components
                                count:(NSInteger)count
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
    CGColorSpaceRelease(colorSpace);
    CGPoint startPoint = (CGPoint){0,0};
    CGPoint endPoint = (CGPoint){size.width,0};
    
    CGContextDrawLinearGradient(context, colorGradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(colorGradient);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void)setData:(id)data
{
    ShopHomeInfoModel *model = (ShopHomeInfoModel *)data;
    
    NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.shopIconURL.absoluteString];
    [self.headImgView sd_setImageWithURL:picUrl placeholderImage:AppPlaceholderShopImage];
    

    NSMutableArray *imgIcons = [NSMutableArray array];
    [model.identifierIcons enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
    
    [self layoutIfNeeded];

    CGSize size  = [self.iconsView sizeWithContentData:self.iconsView.dataMArray];
    NSLog(@"size =%@",NSStringFromCGSize(size));
    [self.iconsContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo (size.height);
        make.width.mas_equalTo(size.width);
        
    }];
    
    self.companyNameLab.text = model.shopName;
    
    ShopHomeInfoModelFansVisiSub *fansAndVisitor = model.fansAndVisitors;
    
    self.fansNumLab.text = [NSString stringWithFormat:@"%@",fansAndVisitor.fans];
    self.visitorNumLab.text = [NSString stringWithFormat:@"%@",fansAndVisitor.visitors];
    
    self.fansIsNewImgView.hidden = !fansAndVisitor.fansReddot;
    self.vistitorIsNewImgView.hidden = !fansAndVisitor.visitorsReddot;
    
    self.isNewErWeiMaView.hidden = !model.ercodeReddot;
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
