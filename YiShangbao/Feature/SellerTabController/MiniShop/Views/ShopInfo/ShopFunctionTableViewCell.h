//
//  ShopFunctionTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/1/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ShopFunctionTableViewCellID;

@interface ShopFunctionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *businessInformationButton;
@property (weak, nonatomic) IBOutlet UIButton *shopNoticesButton;
@property (weak, nonatomic) IBOutlet UIButton *shopRealPhotoButton;

@end
