//
//  MyCustomerLookCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/27.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomerLookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTitleLabelBottm_descLabelTopLayout;

@end
