//
//  ScanErrorViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/7/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ScanErrorViewController.h"

@interface ScanErrorViewController ()
@property(nonatomic, strong)UILabel *errorLabel;
@end

@implementation ScanErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"错误";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.errorLabel = [[UILabel alloc] init];
    [self.view addSubview:self.errorLabel];
    self.errorLabel.numberOfLines = 0;
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.text = [NSString stringWithFormat:@"该二维码内容为:%@，无法正常跳转，暂时只能扫义采宝商铺二维码哦～",self.errorStr];
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@(SCREEN_WIDTH-30));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
