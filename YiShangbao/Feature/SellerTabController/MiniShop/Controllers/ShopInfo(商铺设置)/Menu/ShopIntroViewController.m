//
//  ShopIntroViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopIntroViewController.h"
#import "ShopIntroView.h"

@interface ShopIntroViewController ()

@end

@implementation ShopIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void) creatUI{
    self.title = @"商铺简介";
    ShopIntroView *view = [[ShopIntroView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    
    [view.btn_confirm addTarget:self action:@selector(confirmTip) forControlEvents:UIControlEventTouchUpInside];
}


-(void)initData{
    [[[AppAPIHelper shareInstance] shopAPI] getShopIntroduceWithsuccess:^(id data) {
        ShopIntroView *view = (ShopIntroView *)self.view;
        [view initUI:data];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

-(void)confirmTip{
    ShopIntroView *view = (ShopIntroView *)self.view;
    [[[AppAPIHelper shareInstance] shopAPI] modifyShopIntroduceWithoutline:view.textContent.text success:^(id data) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}
@end
