//
//  MakeBillGoodNameView.h
//  YiShangbao
//
//  Created by light on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MakeBillGoodNameViewDelegate <NSObject>
@optional

- (void)selectedGoodsName:(NSString *)goodsName;

@end

@interface MakeBillGoodNameView : UIView

@property (nonatomic, weak) id<MakeBillGoodNameViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;

- (void)updateData:(NSArray *)historyList;

@end
