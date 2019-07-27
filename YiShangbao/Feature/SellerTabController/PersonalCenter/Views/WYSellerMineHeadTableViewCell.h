//
//  WYSellerMineHeadTableViewCell.h
//  YiShangbao
//
//  Created by light on 2017/10/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const WYSellerMineHeadTableViewCellID;

//@interface WYSellerFunctionView : UIView
//
//@property (nonatomic ,strong) UILabel *numberLabel;
//@property (nonatomic ,strong) UILabel *nameLabel;
//@property (nonatomic ,strong) UIButton *button;
//
//@end

@interface WYSellerMineHeadTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *headButton;
@property (nonatomic, strong) UIButton *integralButton;
//@property (nonatomic ,strong) WYSellerFunctionView *pushProductView;
//@property (nonatomic ,strong) WYSellerFunctionView *clearInventoryView;
//@property (nonatomic ,strong) WYSellerFunctionView *acceptBusinessView;
//@property (nonatomic ,strong) WYSellerFunctionView *wantBuyView;

- (void)updateData:(id)model;

@end
