//
//  CustomerMangerController.h
//  YiShangbao
//
//  Created by simon on 2018/1/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomerModel.h"

typedef void(^DidClcikBlock)(SMCustomerSubModel *model);
@interface CustomerMangerController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textFild;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)dissmissControllerAction:(id)sender;

@property (nonatomic)BOOL isSelectCustomer;
@property (nonatomic,copy)DidClcikBlock didClcikBlock;

@end
