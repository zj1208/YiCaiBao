//
//  GuideAddProController.h
//  YiShangbao
//
//  Created by simon on 2018/5/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideAddProController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;

- (IBAction)dissmissAction:(UIButton *)sender;
@end

/*
- (void)lauchFirstNewFunction
{
    if (![WYUserDefaultManager getNewFunctionGuide_AddProPicV1])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GuideAddProController *vc = [sb instantiateViewControllerWithIdentifier:SBID_GuideAddProController];
        [self.tabBarController addChildViewController:vc];
        [self.tabBarController.view addSubview:vc.view];
    }
}
*/
