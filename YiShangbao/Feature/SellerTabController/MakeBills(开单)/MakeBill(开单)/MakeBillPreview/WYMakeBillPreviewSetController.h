//
//  WYMakeBillPreviewSetController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/2/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"
@interface WYMakeBillPreviewSetController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *shopDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopGoDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *shopSetBtn;
@property (weak, nonatomic) IBOutlet UISwitch *termsSwitch;
@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *termsSaveBtn;
@property (weak, nonatomic) IBOutlet UITextField *bankTextFild;

@end
