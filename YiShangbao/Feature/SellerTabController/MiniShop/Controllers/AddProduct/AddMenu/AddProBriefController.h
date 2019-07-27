//
//  AddProBriefController.h
//  YiShangbao
//
//  Created by simon on 17/2/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"
@interface AddProBriefController : UIViewController

- (IBAction)savaBarItemAction:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;

@end
