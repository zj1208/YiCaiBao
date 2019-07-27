//
//  GuideMineController.m
//  YiShangbao
//
//  Created by simon on 17/5/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "GuideMineController.h"

@interface GuideMineController ()

- (IBAction)dissmissAction:(UIButton *)sender;
@end

@implementation GuideMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if ([WYUserDefaultManager getUserTargetRoleType] ==WYTargetRoleType_seller){
        [bpath appendPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(15, 290, SCREEN_WIDTH - 30, 70)] bezierPathByReversingPath]];
    }else{
        [bpath appendPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(15, 300, SCREEN_WIDTH - 30, 70)] bezierPathByReversingPath]];
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    self.view.layer.mask = shapeLayer;
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

- (IBAction)dissmissAction:(UIButton *)sender {
    
    if (self.parentViewController) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        [WYUserDefaultManager setNewFunctionGuide_MineV1];
    }
}
@end
