//
//  AddSpecsViewController.h
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"

@interface AddSpecsViewController : UIViewController

- (IBAction)savaBarItemAction:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;

@end
