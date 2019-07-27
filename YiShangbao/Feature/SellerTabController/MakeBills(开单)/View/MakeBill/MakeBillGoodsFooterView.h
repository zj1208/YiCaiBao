//
//  MakeBillGoodsFooterView.h
//  YiShangbao
//
//  Created by light on 2018/1/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MakeBillGoodsFooterViewID;

@interface MakeBillGoodsFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *tapButton;

- (void)updateData:(id)model;

@end
