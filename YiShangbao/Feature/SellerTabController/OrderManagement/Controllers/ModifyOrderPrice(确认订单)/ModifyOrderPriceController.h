//
//  ModifyOrderPriceController.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyOrderPriceController : UIViewController


@property (nonatomic, copy) NSString *bizOrderId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;


@property (weak, nonatomic) IBOutlet UIView *finalPriceContainerView;

//原价
@property (weak, nonatomic) IBOutlet UILabel *prodsPriceLab;

//运费
@property (weak, nonatomic) IBOutlet UILabel *transFeeLab;

//折扣
@property (weak, nonatomic) IBOutlet UILabel *discountLab;

//总额
@property (weak, nonatomic) IBOutlet UILabel *finalPriceLab;

@end
