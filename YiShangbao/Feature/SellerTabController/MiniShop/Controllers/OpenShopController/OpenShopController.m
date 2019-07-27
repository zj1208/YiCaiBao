//
//  OpenShopController.m
//  YiShangbao
//
//  Created by simon on 17/3/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "OpenShopController.h"
#import "WYPerfectShopInfoViewController.h"
//#import "ShopGuideCell.h"


@interface OpenShopController ()

@end

@implementation OpenShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title =@"开通商铺，获得更多生意";
    [self setUI];
    [self setData];
    
}

- (void)setUI
{
//    [MBProgressHUD zx_showGifWithGifName:@"loading.gif" toView:nil];
    [self xm_navigationItem_titleCenter];
//    
//    self.visibleCellNum = 5;
//    
//    NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
//    self.timer = timer1;
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_tableBg"]];
//    [self.view addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(_lineImgView.mas_bottom);
//        make.left.equalTo(imageView.superview.mas_left);
//        make.right.equalTo(imageView.superview.mas_right);
//        make.height.mas_equalTo(LCDScale_iPhone6_Width(216.f));
//    }];
//    
//    self.tableView.scrollEnabled = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setData
{
//    NSArray *arr = [NSArray array];
//    self.dataArray = arr;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:kNotificationUserLoginIn object:nil];
//    [self requestInitData];
}

//- (void)requestInitData
//{
//    WS(weakSelf);
//    [ProductMdoleAPI getShopOpenGuideWithSuccess:^(id data) {
//        
//        _dataArray = data;
//        [_tableView reloadData];
//        
//    } failure:^(NSError *error) {
//        
//        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
//    }];
//}


//-(void)viewDidDisappear:(BOOL)animated
//{
//    if (![self.navigationController.viewControllers containsObject:self])
//    {
//        if ([self.timer isValid])
//        {
//            [self.timer invalidate];
//        }
//    }
//}



//- (void)timerFired:(NSTimer *)timer
//{
//    
//    NSInteger rows =[self.tableView numberOfRowsInSection:0];
//    if (_row<rows-self.visibleCellNum+1)
//    {
//        _row++;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }else if (_row ==rows-self.visibleCellNum+1)
//    {
//        _row =0;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    }
//}
//
//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    
//    if (LCDH<=568)
//    {
//        self.bottomLayout.constant =20.f;
//    }
//}
//

- (void)loginIn:(id)notification
{
    if ([UserInfoUDManager isOpenShop])
    {
        UITabBarController *tabController = (UITabBarController *)APP_keyWindow.rootViewController;
        
        UINavigationController *selectedNav = tabController.selectedViewController;
        if ([selectedNav.topViewController isKindOfClass:[OpenShopController class]])
        {
            [selectedNav popToRootViewControllerAnimated:NO];
        }        
        tabController.selectedIndex = 1;
    }
    else
    {
        WYPerfectShopInfoViewController *vc = [[WYPerfectShopInfoViewController alloc]init];
        vc.soureControllerType = SourceControllerType_OpenShopGuide;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.dataArray.count >0)
    {
        [cell setTitle:[self.dataArray objectAtIndex:indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGRectGetHeight(tableView.frame)/self.visibleCellNum;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
*/
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

- (IBAction)openShopBtnAction:(UIButton *)sender {
    
    if ([self xm_performIsLoginActionWithPopAlertView:NO])
    {
        WYPerfectShopInfoViewController *vc = [[WYPerfectShopInfoViewController alloc]init];
        vc.soureControllerType = SourceControllerType_OpenShopGuide;
        [self.navigationController pushViewController:vc animated:YES];
    }
       
}
@end
