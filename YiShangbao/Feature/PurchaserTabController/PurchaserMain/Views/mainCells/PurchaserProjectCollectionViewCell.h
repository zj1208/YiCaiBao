//
//  PurchaserProjectCollectionViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PurchaserProjectCollectionViewCellStyle){
    PurchaserProjectCollectionViewCellShop         = 0, //商铺专题cell
    
    PurchaserProjectCollectionViewCellProduct      = 1, //产品专题cel
};
@class PurchaserProjectCollectionViewCell;
@protocol PurchaserProjectCollectionViewCellDelegate <NSObject>

@optional
-(void)jl_PurchaserProjectCollectionViewCell:(PurchaserProjectCollectionViewCell*)cell didSelectItemAtInteger:(NSInteger)integer;

@end
@interface PurchaserProjectCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backGroundView;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property (weak, nonatomic) IBOutlet UILabel *TitleLAbel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@property (weak, nonatomic) IBOutlet UIImageView *firstIMG;
@property (weak, nonatomic) IBOutlet UILabel *firstdescLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *secondIMG;
@property (weak, nonatomic) IBOutlet UILabel *seconddescLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *thirdIMG;
@property (weak, nonatomic) IBOutlet UILabel *thirddescLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdPriceLabel;


@property(nonatomic,assign)PurchaserProjectCollectionViewCellStyle type;
@property(nonatomic,assign)id<PurchaserProjectCollectionViewCellDelegate>delegate;

-(void)settData:(id)data;
@end
