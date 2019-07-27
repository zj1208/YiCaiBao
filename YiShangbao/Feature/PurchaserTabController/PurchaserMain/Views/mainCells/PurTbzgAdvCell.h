//
//  PurTbzgAdvCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PurTbzgAdvCellBtnType){
    PurTbzgAdvCellBtnType_DiJiaBtn            = 1, //库存处理
    PurTbzgAdvCellBtnType_ReXiaoBtn           = 2, //热销产品
    PurTbzgAdvCellBtnType_TaoBaoBtn           = 3, //淘宝直供
    
};
@class PurTbzgAdvCell;
@protocol PurTbzgAdvCellDelegate <NSObject>
//按钮代理
-(void)jl_PurTbzgAdvCell:(PurTbzgAdvCell *)cell type:(PurTbzgAdvCellBtnType)type;
@end

@interface PurTbzgAdvCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *tabbaozhigongBtn;
@property (weak, nonatomic) IBOutlet UIButton *dijiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *rexiaoBtn;

-(void)setDatalowPriceStockAdv:(NSArray*)lowPriceStockAdv hotShopAdv:(NSArray*)hotShopAdv tbzgAdv:(NSArray*)tbzgAdv;

@property(nonatomic,weak)id<PurTbzgAdvCellDelegate>delegate;

@end
