//
//  PurACommendTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/5/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const PurACommendTableViewCellID;

@protocol PurACommendTableViewCellDelegate <NSObject>
@optional

- (void)reNewBatch;
- (void)goStoreIndex:(NSInteger)item;
- (void)attentionStoreIndex:(NSInteger)item;

@end

@interface PurACommendTableViewCell : UITableViewCell

@property (nonatomic ,weak) id<PurACommendTableViewCellDelegate> delegate;

- (void)updateData:(id)model isType:(NSInteger)type;

- (void)updatePoint;

@end
