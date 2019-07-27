//
//  PurANewsTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/5/31.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXPhotosView;

extern NSString *const PurANewsTableViewCellID;

@protocol PurANewsTableViewCellDelegate <NSObject>
@optional

- (void)contactShoperByStoreId:(NSString *)storeId;
- (void)goStoreUrl:(NSString *)storeId;
- (void)attentionStoreId:(NSString *)storeId isAttention:(NSString *)isAttention;

@end

@interface PurANewsTableViewCell : UITableViewCell

@property (nonatomic, strong) ZXPhotosView *photoView;

@property (nonatomic ,weak) id<PurANewsTableViewCellDelegate> delegate;

- (void)updateData:(id)model;

@end
