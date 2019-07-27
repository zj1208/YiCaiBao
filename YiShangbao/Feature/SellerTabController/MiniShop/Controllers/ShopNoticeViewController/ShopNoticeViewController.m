//
//  ShopNoticeViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopNoticeViewController.h"
#import "ShopNoticeView.h"

@interface ShopNoticeViewController ()
@property(nonatomic, copy)NSString *shopId;
@end

@implementation ShopNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void) creatUI{
    self.title = @"商铺公告";
    ShopNoticeView *view = [[ShopNoticeView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    
    [view.btn_confirm addTarget:self action:@selector(confirmTip) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initData{
    [[[AppAPIHelper shareInstance] shopAPI] getShopAnnouncementWithsuccess:^(id data) {
        ShopNoticeView *view = (ShopNoticeView *)self.view;
        [view initUI:data];
        self.shopId = [data objectForKey:@"shopId"];
        
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
 }

-(void)confirmTip{
    ShopNoticeView *view = (ShopNoticeView *)self.view;
    [[[AppAPIHelper shareInstance] shopAPI] addShopAnnouncementWithshopId:self.shopId content:view.textContent.text success:^(id data) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

@end
