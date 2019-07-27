//
//  BRCodePresentController.m
//  YiShangbao
//
//  Created by simon on 2018/2/2.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BRCodePresentController.h"

@interface BRCodePresentController ()

@end

@implementation BRCodePresentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view zx_setCornerRadius:<#(CGFloat)#> borderWidth:<#(CGFloat)#> borderColor:<#(nullable UIColor *)#>];

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

- (IBAction)doBtnAction:(UIButton *)sender {
    
    if (self.doActionHandleBlock)
    {
        self.doActionHandleBlock();
    }
}

- (IBAction)cancleBtnAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    if (self.cancleActionHandleBlock)
//    {
//        self.cancleActionHandleBlock();
//    }
}
@end
