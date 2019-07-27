//
//  ManageMainProController.h
//  YiShangbao
//
//  Created by simon on 17/2/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"

@interface ManageMainProController : UIViewController

- (IBAction)saveBarItemAction:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;
@end
