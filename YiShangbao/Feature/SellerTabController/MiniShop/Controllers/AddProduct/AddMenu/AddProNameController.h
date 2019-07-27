//
//  AddProNameController.h
//  YiShangbao
//
//  Created by simon on 17/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"
#import "JLTextView.h"

@interface AddProNameController : UIViewController

@property (weak, nonatomic) IBOutlet JLTextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *reminderLab;

- (IBAction)saveBarItemAction:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;
@end
