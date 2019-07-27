//
//  SetBankAccountViewController.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@interface SetBankAccountViewController : UIViewController
@property(nonatomic, strong)NSNumber *type;   //1.新增 2.修改
@property(nonatomic, strong)NSNumber *channel;   //1新增时，增加渠道（提现需要），可为空，默认为0，0-商铺 1-提现 2-我的银行卡

@property(nonatomic, strong)AcctInfoModel *accInfoModel;
@property(nonatomic, strong)BankModel *bankModel;

@end
