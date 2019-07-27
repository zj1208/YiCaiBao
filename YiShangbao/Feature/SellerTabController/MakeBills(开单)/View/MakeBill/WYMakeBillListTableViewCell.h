//
//  WYMakeBillListTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/1/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MakeBillOperationType) {
    MakeBillOperationTypePreview,
    MakeBillOperationTypeDelete,
    MakeBillOperationTypeEdit,
};

extern NSString *const WYMakeBillListTableViewCellID;

@protocol WYMakeBillListTableViewCellDelegate <NSObject>
@optional

- (void)selectedType:(MakeBillOperationType)type index:(NSInteger)index;

@end

@interface WYMakeBillListTableViewCell : UITableViewCell

@property (nonatomic ,weak) id<WYMakeBillListTableViewCellDelegate> delegate;
- (void)updateData:(id)model index:(NSInteger)index;

@end
