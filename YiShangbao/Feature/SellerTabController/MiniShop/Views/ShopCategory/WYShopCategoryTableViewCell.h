//
//  WYShopCategoryTableViewCell.h
//  YiShangbao
//
//  Created by light on 2017/12/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShopCategoryOperationType) {
    ShopCategoryOperationTypeEdit,
    ShopCategoryOperationTypeExtend,
    ShopCategoryOperationTypeShiftUp,
    ShopCategoryOperationTypeShiftDown,
};

extern NSString *const WYShopCategoryTableViewCellID;

@protocol WYShopCategoryDelegate <NSObject>
@optional

- (void)selectedType:(ShopCategoryOperationType)type index:(NSInteger)index;

@end

@interface WYShopCategoryTableViewCell : UITableViewCell

@property (nonatomic ,weak) id<WYShopCategoryDelegate> delegate;

- (void)updateData:(id)model index:(NSInteger)index;

@end
