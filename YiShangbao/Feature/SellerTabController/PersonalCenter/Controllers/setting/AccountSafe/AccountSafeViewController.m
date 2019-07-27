//
//  AccountSafeViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AccountSafeViewController.h"
#import "AccountInfoTableViewCell.h"

#import "ChangePasswordViewController.h"
#import "PhoneSetPasswordViewController.h"

#import "WXApi.h"
#import "AppDelegate.h"

#import "PurchaserModel.h"
#import "UserModel.h"

#import "ChangePhoneStepOneViewController.h"

@interface AccountSafeViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate, WXDelegate>
{
    AppDelegate *appdelegate;
}
//tableView
@property (nonatomic, strong) UITableView * mainTableView;
//data
@property(nonatomic, strong) BuyerUserModel *buyeruserModel;
@property(nonatomic, strong) UserModel *businessUserModel;

@end

@implementation AccountSafeViewController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)creatUI{
    self.title = @"账户及安全";
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    //tableview
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
//        make.height.equalTo(@(147+64));
    }];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    //    self.mainTableView.bounces = NO;
    self.mainTableView.scrollEnabled= NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.mainTableView.backgroundColor = WYUISTYLE.colorBGgrey;
    [self.mainTableView registerClass:[AccountInfoTableViewCell class] forCellReuseIdentifier:kCellIdentifier_AccountInfoTableViewCell];
}

-(void)initData{
    if (![UserInfoUDManager isLogin])
    {
        return;
    }
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        [[[AppAPIHelper shareInstance] getPurchaserAPI] getBuyerInfoWithsuccess:^(id data) {
            self.buyeruserModel = data;
            [_mainTableView reloadData];
        } failure:^(NSError *error) {
            [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }else{
        [[[AppAPIHelper shareInstance] getUserModelAPI] getMyInfomationWithSuccess:^(id data) {
            self.businessUserModel = data;
            [_mainTableView reloadData];
        } failure:^(NSError *error) {
            [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
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

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountInfoTableViewCell * cell = [_mainTableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountInfoTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lbl_sub.hidden = YES;
    cell.userImage.hidden = YES;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.lbl_title.text = @"更换手机号";
            cell.lbl_sub.hidden = NO;
//            cell.image_arrow.hidden = YES;
             if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
                 cell.lbl_sub.text = self.buyeruserModel.phone;
             }else{
                 cell.lbl_sub.text = [NSString  stringWithFormat:@"%@ %@",self.businessUserModel.countryCode, self.businessUserModel.nickPhone];
             }
            
        }else if(indexPath.row == 1){
            cell.lbl_title.text = @"更换密码";
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.lbl_sub.hidden = NO;
            cell.lbl_title.text = @"微信绑定";
            if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
                if (self.buyeruserModel.bindWechat.integerValue) {
                    cell.lbl_sub.text = @"已绑定";
                    cell.lbl_sub.textColor = [UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1.0];
                }else{
                    cell.lbl_sub.text = @"立即绑定";
                    cell.lbl_sub.textColor = [UIColor colorWithRed:0.34 green:0.67 blue:0.91 alpha:1.0];
                }
            }else{
                if (self.businessUserModel.bindWechat.integerValue) {
                    cell.lbl_sub.text = @"已绑定";
                    cell.lbl_sub.textColor = [UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1.0];
                }else{
                    cell.lbl_sub.text = @"立即绑定";
                    cell.lbl_sub.textColor = [UIColor colorWithRed:0.34 green:0.67 blue:0.91 alpha:1.0];
                }
            }

        }
    }
    return cell;
}

#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
                ChangePhoneStepOneViewController *vc = [[ChangePhoneStepOneViewController alloc] init];
                vc.phoneStr = self.buyeruserModel.phone;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                ChangePhoneStepOneViewController *vc = [[ChangePhoneStepOneViewController alloc] init];
                vc.codeStr = self.businessUserModel.countryCode;
                vc.phoneStr = self.businessUserModel.nickPhone;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if(indexPath.row == 1){
            //更换密码
            if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
                if (self.buyeruserModel.needSetPwd.integerValue) {
                    PhoneSetPasswordViewController *vc = [[PhoneSetPasswordViewController alloc] init];
                    vc.phone = self.buyeruserModel.phone;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    ChangePasswordViewController *vc =[[ChangePasswordViewController  alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                if (self.businessUserModel.needSetPwd.integerValue) {
                    PhoneSetPasswordViewController *vc = [[PhoneSetPasswordViewController alloc] init];
                    vc.phone = self.businessUserModel.phone;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    ChangePasswordViewController *vc =[[ChangePasswordViewController  alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //微信绑定
            if ([WXApi isWXAppInstalled]) {
                if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
                    if (self.buyeruserModel.bindWechat.integerValue) {
                        [self alertBind];
                    }else{
                        [self wechatBind];
                    }
                }else{
                    if (self.businessUserModel.bindWechat.integerValue) {
                        [self alertBind];
                    }else{
                        [self wechatBind];
                    }
                }
            }else{
                //未安装微信
                [self zhHUD_showErrorWithStatus:@"请先安装微信哦～"];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)alertBind{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"解除微信绑定后，所有数据保留至手机账号，是否解除微信？", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"关闭", nil)  style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"解绑微信", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self zhHUD_showWithStatus:@"解绑中loading"];
        [[[AppAPIHelper shareInstance] getUserModelAPI] postAppUnbindWechatWithSuccess:^(id data) {
            [self zhHUD_showSuccessWithStatus:@"解绑成功"];
            [self initData];
        } failure:^(NSError *error) {
//            [self zhHUD_showErrorWithStatus:[error localizedDescription]];
            [self zhHUD_showErrorWithStatus:@"解绑失败，请稍后再试"];
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)wechatBind{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    
    req.openID = [WYUserDefaultManager getkURL_WXAPPID];
    req.state = @"123456";
    //微信要求这样写
    appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.wxDelegate = self;
    [WXApi sendReq:req];
}


#pragma mark - 微信登录代理

-(void)loginSuccessByCode:(NSString *)code{
    NSLog(@"code %@",code);
    [[[AppAPIHelper shareInstance] getUserModelAPI] postAppBindWechatWithCode:code Success:^(id data) {
        [self zhHUD_showSuccessWithStatus:@"绑定成功"];
        [self initData];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}
@end
