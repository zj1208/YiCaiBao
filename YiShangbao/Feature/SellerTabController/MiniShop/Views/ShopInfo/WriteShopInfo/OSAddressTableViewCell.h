//
//  OSAddressTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OSAddressTableViewCellDelegate <NSObject>

- (void)addressDetail:(NSString *)address;

@end

extern NSString *const OSAddressTableViewCellID;

@interface OSAddressTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) id<OSAddressTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@end
