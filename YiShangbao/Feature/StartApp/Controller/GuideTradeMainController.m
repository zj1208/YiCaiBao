//
//  GuideTradeMainController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/8/29.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "GuideTradeMainController.h"

@interface GuideTradeMainController ()

@end

@implementation GuideTradeMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topLayoutCon.constant += HEIGHT_STATEBAR-20;
    
    self.rightLayCon.constant = LCDScale_iPhone6_Width(60.f);
}
- (IBAction)iknowBtn:(id)sender {
    [WYUserDefaultManager setNewFunctionGuide_Trade];
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    if (self.parentViewController) {
        [self removeFromParentViewController];
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
