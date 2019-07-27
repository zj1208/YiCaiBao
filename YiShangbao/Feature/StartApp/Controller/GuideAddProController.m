//
//  GuideAddProController.m
//  YiShangbao
//
//  Created by simon on 2018/5/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "GuideAddProController.h"

@interface GuideAddProController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pro1WidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pro2WidthLayout;
@end

@implementation GuideAddProController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    if (IS_IPHONE_XXX)
    {
        self.topLayoutConstraint.constant = 24+64+25 +16;
    }
    else
    {
        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
        {
            self.pro1WidthLayout.constant = 63.f;
            self.pro2WidthLayout.constant = 63.f*1.2;
        }
        else if (IS_IPHONE_6P)
        {
            self.pro1WidthLayout.constant = 87.f;
            self.pro2WidthLayout.constant = 87.f*1.2;
        }
        self.topLayoutConstraint.constant = 64+25 +LCDScale_iPhone6_Width(18);
    }
}


- (IBAction)dissmissAction:(UIButton *)sender {
    
    if (self.parentViewController) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        [WYUserDefaultManager setNewFunctionGuide_AddProPicV1];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
