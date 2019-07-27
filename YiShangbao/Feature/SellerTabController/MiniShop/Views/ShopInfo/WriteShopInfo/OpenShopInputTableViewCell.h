//
//  OpenShopInputTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const OpenShopInputTableViewCellID;

@interface OpenShopInputTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void)updateTitle:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder;

@end
