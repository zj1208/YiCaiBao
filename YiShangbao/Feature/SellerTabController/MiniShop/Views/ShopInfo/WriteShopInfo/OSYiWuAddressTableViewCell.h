//
//  OSYiWuAddressTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OSYiWuAddressTableViewCellDelegate <NSObject>

- (void)addressMenString:(NSString *)men louString:(NSString *)lou jieString:(NSString *)jie shopNumberString:(NSString *)shopNumber;

@end

extern NSString *const OSYiWuAddressTableViewCellID;

@interface OSYiWuAddressTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic ,weak) id<OSYiWuAddressTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *menTextField;
@property (weak, nonatomic) IBOutlet UITextField *louTextField;
@property (weak, nonatomic) IBOutlet UITextField *jieTextField;
@property (weak, nonatomic) IBOutlet UITextField *shopNumberTextField;

- (void)updateMen:(NSString *)men lou:(NSString *)lou jie:(NSString *)jie shopNumber:(NSString *)shopNumber;

@end
