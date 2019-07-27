//
//  ShopInfoOtherTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/8/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShopInfoOtherTableViewCell.h"
#import "ZXImgIconsCollectionView.h"

NSString *const ShopInfoOtherTableViewCellID = @"ShopInfoOtherTableViewCellID";

@interface ShopInfoOtherTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *certificationIconsView;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;//认证图标控件

@end

@implementation ShopInfoOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    iconsView.iconHeight = 20.0;
    iconsView.minimumInteritemSpacing = 7.0;
    self.iconsView = iconsView;
    [self.certificationIconsView addSubview:iconsView];
    self.certificationIconsView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.certificationIconsView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
    
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateName:(NSString *)name content:(NSString *)content score:(NSString *)score icons:(NSArray *)icons{
    self.nameLabel.text = name;
    self.contentLabel.text = content;
    if (score.length > 0){
        self.scoreLabel.text = score;
        self.scoreLabel.hidden = NO;
        self.iconsView.hidden = YES;
    }else {
//        icons = @[@"http://public-read-bkt.microants.cn/app/cert/flag/ic_name_normal.png",@"http://public-read-bkt.microants.cn/app/cert/flag/ic_name_normal.png"];
        NSMutableArray *imgIcons = [NSMutableArray array];
        [icons enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj];
            icon.width = 20.0;
            icon.height = 20.0;
            [imgIcons addObject:icon];
        }];
        [self.iconsView setData:imgIcons];
        self.scoreLabel.hidden = YES;
        self.iconsView.hidden = NO;
    }
}

@end
