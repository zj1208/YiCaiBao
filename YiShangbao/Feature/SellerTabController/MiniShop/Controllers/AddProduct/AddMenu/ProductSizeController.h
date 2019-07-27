//
//  ProductSizeController.h
//  YiShangbao
//
//  Created by simon on 17/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//箱规
#import <UIKit/UIKit.h>

@interface ProductSizeController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *volumnField;

- (IBAction)savaBarItemAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *weightField;

@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *unitInBoxField;
@end
