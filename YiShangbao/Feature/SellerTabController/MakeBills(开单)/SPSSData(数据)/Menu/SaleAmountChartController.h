//
//  SaleAmountChartController.h
//  YiShangbao
//
//  Created by simon on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleAmountChartController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UILabel *dateLab;

- (IBAction)choseDateButtonAction:(id)sender;
@end
