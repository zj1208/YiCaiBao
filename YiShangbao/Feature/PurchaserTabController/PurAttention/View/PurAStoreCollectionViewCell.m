//
//  PurAStoreCollectionViewCell.m
//  YiShangbao
//
//  Created by light on 2018/5/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PurAStoreCollectionViewCell.h"
#import "WYAttentionModel.h"

NSString *const PurAStoreCollectionViewCellID = @"PurAStoreCollectionViewCellID";

@interface PurAStoreCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;//认证标志

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainBusinessLabel;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation PurAStoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.cornerRadius = 6.0;
    self.backView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 25.0;
    self.headImageView.layer.masksToBounds = YES;
    self.attentionButton.layer.cornerRadius = 12.5;
    self.attentionButton.layer.masksToBounds = YES;
    
    self.vImageView.contentMode=UIViewContentModeScaleAspectFit;
    // Initialization code
}

- (void)updateData:(WYSupplierModel *)model {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.shopIcon] placeholderImage:AppPlaceholderShopImage];
//    [self.vImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    if (model.authStatus) {
        [self.vImageView setImage:[UIImage imageNamed:@"yilenzheng"]];
    }else{
        [self.vImageView setImage:[UIImage imageNamed:@"weirenzheng"]];
    }
    self.storeNameLabel.text = model.shopName;
    self.mainBusinessLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"主营", @"主营"),model.mainSell];
    
    [self attentionButtonType:model.isAttention];
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
        [self.attentionButton.layer insertSublayer:self.gradientLayer atIndex:0];
        
    }
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
