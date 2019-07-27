//
//  MyCustomerTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/4/13.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MyCustomerTableViewCell.h"
#import "ZXImgIconsCollectionView.h"

NSString *const MyCustomerTableViewCellID = @"MyCustomerTableViewCellID";

@interface MyCustomerTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;

@end

@implementation MyCustomerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self updateConstraintsIfNeeded];
    self.headImageView.layer.cornerRadius = 20.0;
    self.headImageView.layer.masksToBounds = YES;
    
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    iconsView.minimumInteritemSpacing = 2.f;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];
    
    // Initialization code
}

- (void)updateData:(OnlineCustomerListModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headIcon] placeholderImage:AppPlaceholderHeadImage];
    self.nameLabel.text = model.nickName;
    self.companyLabel.text = model.companyName;
   
    //标识
    NSMutableArray *imgIcons = [NSMutableArray array];
    [model.buyerBadges enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
    
    [self layoutIfNeeded];
    CGSize size  = [self.iconsView sizeWithContentData:imgIcons];
    
    [self.iconsContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo (size.height);
        make.width.mas_equalTo(size.width);
        
    }];
}

@end
