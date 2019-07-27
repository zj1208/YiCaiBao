//
//  OSTradeTypeTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TradeType){
    TradeTypeNo = 0,
    TradeTypeDomestic = 1,//内销
    TradeTypeForeign = 2,//外贸
};

@protocol OSTradeTypeTableViewCellDelegate <NSObject>

- (void)tradeType:(NSInteger)type;

@end

extern NSString *const OSTradeTypeTableViewCellID;

@interface OSTradeTypeTableViewCell : UITableViewCell

@property (nonatomic ,weak) id<OSTradeTypeTableViewCellDelegate> delegate;

@end
