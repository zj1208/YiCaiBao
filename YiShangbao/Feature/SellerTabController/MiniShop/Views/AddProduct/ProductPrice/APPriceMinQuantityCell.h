//
//  APPriceMinQuantityCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPriceMinQuantityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *numstextFild;
@property (weak, nonatomic) IBOutlet UITextField *priceTextfild;
@property (weak, nonatomic) IBOutlet UILabel *minQuaLabel;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;

//yes将输入框变红，文字也变红
@property (assign, nonatomic) BOOL numsTextFildRed;
@property (assign, nonatomic) BOOL priceTextfildRed;

@end
