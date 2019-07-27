//
//  SettingViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SettingViewController.h"
//#import "AccountInfoTableViewCell.h"
#import "WYSettingTableViewCell.h"

#import "AccountSafeViewController.h"
#import "MessageSoundSetViewController.h"

#import "WYDataCache.h"
#import "WYTimeManager.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
//tableView
@property (nonatomic, strong) UITableView * mainTableView;
@property (nonatomic, strong) UIButton *exitBtn;

@property (nonatomic, strong) NSArray *array;

@end

@implementation SettingViewController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        self.array = @[@[@"账户及安全",@"清理缓存"],
                       @[@"意见反馈",@"帮助中心",@"关于我们"],
                       @[@"去评分"]];
    }else{
        self.array = @[@[@"消息设置",@"账户及安全",@"清理缓存"],
                       @[@"意见反馈",@"帮助中心",@"关于我们"],
                       @[@"去评分"]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self exitBtnStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *timeArray = self.array[section];
    return timeArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 12;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:WYSettingTableViewCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[WYSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYSettingTableViewCellID];
    }
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        if(indexPath.section == 0 && indexPath.row == 1){
            float tmpSize = [[SDImageCache sharedImageCache] getSize];
            NSString *string = [NSString stringWithFormat:@"%.2fM",tmpSize/1000.0/1000.0];
            [cell updataName:@"清理缓存" content:string showArrow:NO];
            return cell;
        }
    }else{
        if(indexPath.section == 0 && indexPath.row == 2){
            float tmpSize = [[SDImageCache sharedImageCache] getSize];
            
//             NSArray *array = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
            
            NSString *string = [NSString stringWithFormat:@"%.2fM",tmpSize/1000.0/1000.0];
            [cell updataName:@"清理缓存" content:string showArrow:NO];
            return cell;
        }
    }
    NSArray *timeArray = self.array[indexPath.section];
    [cell updataName:timeArray[indexPath.row] showArrow:YES];
    return cell;
}

#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
            if (indexPath.row == 0) {
                //账户及安全
                if ([self xm_performIsLoginActionWithPopAlertView:NO])
                {
                    AccountSafeViewController *vc = [[AccountSafeViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if(indexPath.row == 1){
                //清理缓存
                [self clearImageCache];
            }
        }else{
            if (indexPath.row == 0) {
                //消息设置
                if ([self xm_performIsLoginActionWithPopAlertView:NO])
                {
                    MessageSoundSetViewController *vc = [[MessageSoundSetViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if(indexPath.row == 1){
                //账户及安全
                if ([self xm_performIsLoginActionWithPopAlertView:NO])
                {
                    AccountSafeViewController *vc = [[AccountSafeViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if(indexPath.row == 2){
                //清理缓存
                [self clearImageCache];
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            if ([self xm_performIsLoginActionWithPopAlertView:NO])
            {
                if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
                //意见反馈
//                    NSString *webUrl = [NSString stringWithFormat:@"%@/ycb/page/ycbSuggestFeedBack.html",[WYUserDefaultManager getkAPP_H5URL]];
//                    [self goWebViewByUrl:webUrl];
                    LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
                    NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbSuggestFeedBack;
                    [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbSuggestFeedBack withSoureController:self];
                }else{
//                    NSString *webUrl = [NSString stringWithFormat:@"%@/ycb/page/suggestFeedBack.html",[WYUserDefaultManager getkAPP_H5URL]];
//                    [self goWebViewByUrl:webUrl];
                    LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
                    NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.suggestFeedBack;
                    [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_suggestFeedBack withSoureController:self];
                }
            }
        }else if (indexPath.row == 1){
            if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
                //帮助中心
//                NSString *webUrl = [NSString stringWithFormat:@"%@/ycb/page/ycbHelpCenter.html",[WYUserDefaultManager getkAPP_H5URL]];
//                [self goWebViewByUrl:webUrl];
                LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
                NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbHelpCenter;
                [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbHelpCenter withSoureController:self];
            }else{
                //帮助中心
//                NSString *webUrl = [NSString stringWithFormat:@"%@/ysb/page/helpCenter.html",[WYUserDefaultManager getkAPP_H5URL]];
//                [self goWebViewByUrl:webUrl];
                LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
                NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.helpCenter;
                [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_helpCenter withSoureController:self];
            }
        }else if (indexPath.row == 2){
            // 关于我们
//            NSString *webUrl = [NSString stringWithFormat:@"%@/ysb/page/aboutUs.html",[WYUserDefaultManager getkAPP_H5URL]];
//            [self goWebViewByUrl:webUrl];
            LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
            NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.aboutUs;
            [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_aboutUs withSoureController:self];
        }
    }else if (indexPath.section == 2){
        //去评分
        NSString *appstoreUrlString = [NSString stringWithFormat:
                                       @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1180821282"];
        
        NSURL * url = [NSURL URLWithString:appstoreUrlString];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication]openURL:url];
        }else{
            NSLog(@"can not open");
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Private Function
- (void)creatUI{
    self.title = @"设置";
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    
    //tableview
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = WYUISTYLE.colorBGgrey;
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        //        if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        //            make.height.equalTo(@(293+64-45));
        //        }else{
        //            make.height.equalTo(@(293+64));
        //        }
    }];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    //    self.mainTableView.bounces = NO;
    self.mainTableView.scrollEnabled= NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.mainTableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    [self.mainTableView registerClass:[WYSettingTableViewCell class] forCellReuseIdentifier:WYSettingTableViewCellID];
    
    
    //退出登录
    self.exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT-65-40, SCREEN_WIDTH-30, 40)];
    [self.exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.exitBtn.layer.masksToBounds= YES;
    self.exitBtn.layer.cornerRadius =20.f;
    self.exitBtn.layer.borderColor =[UIColor clearColor].CGColor;
    [self.exitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitBtn];
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        const CGFloat location[] ={0,1};
        const CGFloat components[] ={
            1.00,0.73,0.29,1,
            1.00,0.55,0.19,1
            
        };
        UIImage *backgroundImage = [UIImage zh_getGradientImageWithSize:self.exitBtn.frame.size locations:location components:components count:2];
        [self.exitBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }else{
        const CGFloat location[] ={0,1};
        const CGFloat components[] ={
            0.99,0.47,0.33,1,
            1.00,0.32,0.28,1
            
        };
        UIImage *backgroundImage = [UIImage zh_getGradientImageWithSize:self.exitBtn.frame.size locations:location components:components count:2];
        [self.exitBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    
    //版本号
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.text = [NSString stringWithFormat:@"版本号：v%@",kAppVersion];
    label.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1.0];
    label.font = WYUISTYLE.fontWith24;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.exitBtn.mas_top).offset(-15);
    }];
}

- (void)goWebViewByUrl:(NSString *)url{
    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
}

-(void)exitBtnStatus{
    if ([UserInfoUDManager isLogin]){
        self.exitBtn.hidden = NO;
    }else{
        self.exitBtn.hidden = YES;
    }
}

#pragma mark action
- (void)exitAction
{
    [[[AppAPIHelper shareInstance] getUserModelAPI] UserLoginOutWithClientId:[[NSUserDefaults standardUserDefaults] objectForKey:ud_GTClientId] success:^(id data) {
        [UserInfoUDManager loginOut];
        // 移除这个登陆时间
        if (Device_SYSTEMVERSION.floatValue>8 && Device_SYSTEMVERSION.floatValue<11)
        {
            [[WYTimeManager shareTimeManager]removeCurrentTimeWithLastLogin];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)clearImageCache{
    WS(weakSelf)
    
    //清理网页缓存
    [UserInfoUDManager cleanWebsiteDataWithCompletionHandler:^{
        
    }];
    //
    [[WYDataCache shareDataCache]removeDataCache:^(NSString * _Nonnull description) {
        
    }];
    
    [MBProgressHUD zx_showGifWithGifName:@"clear_loading" Text:@"清理中" toView:self.view];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [weakSelf.mainTableView reloadData];
        [MBProgressHUD zx_showGifWithGifName:@"clear_loading_success" Text:@"清理完成" time:0.92 toView:weakSelf.view];
    }];
}

@end
