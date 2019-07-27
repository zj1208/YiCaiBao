//
//  APPriceSelectCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APPriceSelectCell;
@protocol APPriceSelectCellDelegate <NSObject>
@optional
/**
 cell上当前选中的按钮
 @param selected YES设置价格、NO面议
 */
-(void)jl_APPriceSelectCell:(APPriceSelectCell *)cell setPriceBtnSelectedChanged:(BOOL)selected ;
@end

@interface APPriceSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;

@property (weak, nonatomic) IBOutlet UIButton *negotiableBtn;


@property (nonatomic,weak) id<APPriceSelectCellDelegate>delegate;

@end
