//
//  MakeBillInputsTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/1/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MakeBillGoodsInfo) {
    MakeBillGoodsProductName,//品名
    MakeBillGoodsUnitPrice,//单价
    MakeBillGoodsTotalNumber,//总数量
    MakeBillGoodsNo,//货号
    MakeBillGoodsUnit,//单位
    MakeBillGoodsBoxNumber,//箱数
    MakeBillGoodsPerBoxNumber,//每箱数量
    MakeBillGoodsVolume,//体积
    MakeBillGoodsTotalPrice,//总价
};

extern NSString *const MakeBillInputsTableViewCellID;

@protocol MakeBillInputsTableViewCellDelegate <NSObject>
@optional

- (void)inputString:(NSString *)string goodsInfoType:(MakeBillGoodsInfo)goodsInfoType;

- (void)changeString:(NSString *)string;
- (void)hiddenHistoryView;

@end

@interface MakeBillInputsTableViewCell : UITableViewCell

@property (nonatomic ,weak) id<MakeBillInputsTableViewCellDelegate> delegate;

- (void)updateInputText:(NSString *)name index:(NSIndexPath *)indexPath;

@end
