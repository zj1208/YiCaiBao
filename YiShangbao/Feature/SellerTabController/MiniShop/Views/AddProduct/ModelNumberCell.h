//
//  ModelNumberCell.h
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  型号

#import "BaseTableViewCell.h"

@interface ModelNumberCell : BaseTableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMagin;

@end
