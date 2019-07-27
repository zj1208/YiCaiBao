//
//  PurANewsTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/5/31.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PurANewsTableViewCell.h"
#import "ZXImgIconsCollectionView.h"
#import "ZXPhotosView.h"
#import "WYAttentionModel.h"

NSString *const PurANewsTableViewCellID = @"PurANewsTableViewCellID";

@interface PurANewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *photoContainerView;

@property (nonatomic, strong) ZXImgIconsCollectionView *iconsView;
@property (nonatomic, weak) WYAttentionMessageModel *model;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation PurANewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImageView.layer.cornerRadius = 20.0;
    self.headImageView.layer.masksToBounds = YES;
    self.attentionButton.layer.cornerRadius = 12.5;
    self.attentionButton.layer.masksToBounds = YES;
    
    self.vImageView.contentMode=UIViewContentModeScaleAspectFit;
    
//    [self.attentionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [self.attentionButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    iconsView.minimumInteritemSpacing = 2.f;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
    
    // 创建一个流水布局photosView(默认为流水布局)
    ZXPhotosView *photoView   = [ZXPhotosView photosView];
    photoView.autoLayoutWithWeChatSytle = YES;
    photoView.photoMaxCount = 9;
    photoView.photoMargin = 10;
    photoView.photoWidth = (SCREEN_WIDTH - 50)/3;
    photoView.photoHeight = photoView.photoWidth;
    self.photoView = photoView;
    
    photoView.photoModelItemViewBlock = ^(UIView *itemView){
        [itemView setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    };
    [self.photoContainerView addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.photoContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)attentionButtonAction:(id)sender {
    if (self.model.showFollow) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(attentionStoreId:isAttention:)]) {
            [self.delegate attentionStoreId:self.model.shopId isAttention:[NSString stringWithFormat:@"%d",!self.model.isAttention]];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(contactShoperByStoreId:)]) {
            [self.delegate contactShoperByStoreId:self.model.shopId];
        }
    }
}

- (IBAction)storeButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goStoreUrl:)]) {
        [self.delegate goStoreUrl:self.model.shopUrl];
    }
}


- (void)updateData:(WYAttentionMessageModel *)model{
    self.model = model;
    if (model.showFollow){
        [self attentionButtonType:model.isAttention];
    }else {
        [self isIMButton];
    }
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.shopHeadPicUrl] placeholderImage:AppPlaceholderShopImage];
    self.storeNameLabel.text = model.shopName;
    self.timeLabel.text = model.time;
    self.contentLabel.attributedText = [self stringWithContent:model.desc type:model.followType typeName:model.followTypeName];
    
    if (model.icons.count > 0){
        WYIconModlel *vModel = model.icons[0];
        [self.vImageView sd_setImageWithURL:[NSURL URLWithString:vModel.iconUrl]];
    }
    //icons 认证图标等展示
    NSMutableArray *imgIcons = [NSMutableArray array];
    [model.icons enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    if (imgIcons.count > 0) {
        [imgIcons removeObject:imgIcons[0]];
    }
    [self.iconsView setData:imgIcons];
    CGSize size  = [self.iconsView sizeWithContentData:self.iconsView.dataMArray];
    [self.iconsContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(size.width);
//        make.width.mas_equalTo(size.width);
    }];
    //产品九宫格图片
    NSMutableArray *picMArray = [NSMutableArray array];
    [model.products enumerateObjectsUsingBlock:^(WYAttentionProdutModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:obj.picUrl];
        NSURL *thumbnail_pic = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:obj.picUrl];
        photo.thumbnail_pic = thumbnail_pic.absoluteString;
        [picMArray addObject:photo];
    }];
    self.photoView.photoModelArray = picMArray;
    
    CGSize size_photo  = [self.photoView sizeWithPhotoCount:self.photoView.photoModelArray.count photosState:ZXPhotosViewStateDidCompose];
    [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size_photo);
    }];
    
}

- (void)isIMButton{
    [self.attentionButton setTitle:NSLocalizedString(@"在线沟通", @"在线沟通") forState:UIControlStateNormal];
    [self.attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.attentionButton sizeToFit];
    self.attentionButton.layer.borderWidth = 0.0;
    self.gradientLayer.frame = CGRectMake(0, 0, self.attentionButton.frame.size.width, 25);
    [self.attentionButton.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)attentionButtonType:(BOOL)isAttention{
    if (isAttention){
        [self.attentionButton setTitle:NSLocalizedString(@"已关注", @"已关注") forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:[UIColor colorWithHex:0xF58F23] forState:UIControlStateNormal];
        self.attentionButton.layer.borderWidth = 0.5;
        self.attentionButton.layer.borderColor = [UIColor colorWithHex:0xF58F23].CGColor;
        [self.gradientLayer removeFromSuperlayer];
    }else{
        [self.attentionButton setTitle:NSLocalizedString(@"关注", @"关注") forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.attentionButton.layer.borderWidth = 0.0;
        self.gradientLayer.frame = CGRectMake(0, 0, 72, 25);
        [self.attentionButton.layer insertSublayer:self.gradientLayer atIndex:0];
        
    }
}

- (NSAttributedString *)stringWithContent:(NSString *)contentStr type:(NSNumber *)type typeName:(NSString *)typeName{
    UIColor *typeColor;
    switch (type.integerValue) {
        case 1:
            typeColor = [UIColor colorWithHex:0x42B5FF];
            break;
        case 2:
            typeColor = [UIColor colorWithHex:0xF58F23];
            break;
        case 3:
            typeColor = [UIColor colorWithHex:0xFF5434];
            break;
        default:
            typeColor = [UIColor colorWithHex:0x42B5FF];
            break;
    }
    
    // 创建一个富文本
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:typeName];
    NSDictionary * attriType = @{NSForegroundColorAttributeName:typeColor,NSFontAttributeName:
//                                     [UIFont fontWithName:@"PingFangSC-Medium"size:15.0f]
                                 [UIFont systemFontOfSize:15.0f]
                                 };
    [attriStr addAttributes:attriType range:NSMakeRange(0, 2)];

    
    NSMutableAttributedString * attriStr2 = [[NSMutableAttributedString alloc] initWithString:@" • "];
    NSDictionary * attriDot = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0xD8D8D8],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    [attriStr2 addAttributes:attriDot range:NSMakeRange(0, 3)];
    
    [attriStr appendAttributedString:attriStr2];
//
//    /**
//     添加图片到指定的位置
//     */
//    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
//    // 表情图片
//    attchImage.image = AppPlaceholderShopImage;
//    // 设置图片大小
//    attchImage.bounds = CGRectMake(0, 0, 40, 15);
//    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
////    [attriStr insertAttributedString:stringImage atIndex:6];
//
    
    
    NSMutableAttributedString * attriStr3 = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSDictionary * attriContent = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333],NSFontAttributeName:[UIFont systemFontOfSize:15]};
    [attriStr3 addAttributes:attriContent range:NSMakeRange(0, contentStr.length)];
    [attriStr appendAttributedString:attriStr3];
    
    return attriStr;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.frame = CGRectMake(0, 0, 72, 25);
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFFBA49].CGColor,(id)[UIColor colorWithHex:0xFF8D32].CGColor, nil];
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}

@end
