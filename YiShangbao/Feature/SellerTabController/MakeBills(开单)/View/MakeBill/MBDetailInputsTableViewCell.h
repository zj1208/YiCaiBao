//
//  MBDetailInputsTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/3/2.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MBDetailInputsTableViewCellID;

@protocol MBDetailInputsTableViewCellDelegate <NSObject>
@optional

- (void)inputString:(NSString *)string;

@end


@interface MBDetailInputsTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic ,weak) id<MBDetailInputsTableViewCellDelegate> delegate;

- (void)updateName:(NSString *)name value:(NSString *)value;

@end
