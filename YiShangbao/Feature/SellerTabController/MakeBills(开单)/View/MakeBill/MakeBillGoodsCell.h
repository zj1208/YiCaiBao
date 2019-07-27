//
//  MakeBillGoodsCell.h
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MakeBillGoodsCellID;

@protocol MakeBillGoodsCellDelegate <NSObject>
@optional

- (void)deleteGoodsIndex:(NSInteger)index;

@end

@interface MakeBillGoodsCell : UITableViewCell

@property (nonatomic, weak) id<MakeBillGoodsCellDelegate> delegate;
- (void)updateData:(id)model index:(NSInteger)index;

@end
