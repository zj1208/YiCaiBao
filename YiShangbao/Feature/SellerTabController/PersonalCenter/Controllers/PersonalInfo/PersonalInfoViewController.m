    //
//  PersonalInfoViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "AccountInfoTableViewCell.h"
#import "NickNameEditViewController.h"
#import "UIViewController+XHPhoto.h"
//图片上传
#import "AliOSSUploadManager.h"

@interface PersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic, strong) UITableView * accountTableview;
@property (nonatomic, strong) UserModel *userInfo;

@end

@implementation PersonalInfoViewController

#pragma mark life cycle 
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
    //初始化oss上传
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![UserInfoUDManager isLogin])
    {
        return;
    }
    [self creatData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - pravite function
- (void)creatUI{
    self.title =@"个人资料";
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    
    //tableview
    _accountTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_accountTableview];
    [_accountTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    UIView *line = [[UIView alloc] init];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@0.5);
    }];
    _accountTableview.scrollEnabled= NO;
    _accountTableview.dataSource = self;
    _accountTableview.delegate = self;
    _accountTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_accountTableview setSeparatorColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0]];
    [_accountTableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    
    [_accountTableview registerClass:[AccountInfoTableViewCell class] forCellReuseIdentifier:kCellIdentifier_AccountInfoTableViewCell];
}
-(void)creatData{
    [[[AppAPIHelper shareInstance] getUserModelAPI] getMyInfomationWithSuccess:^(id data) {
        self.userInfo = data;
        [_accountTableview reloadData];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 1;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section == 1) {
        view.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountInfoTableViewCell * cell = [_accountTableview dequeueReusableCellWithIdentifier:kCellIdentifier_AccountInfoTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (0 == indexPath.row) {
            cell.lbl_sub.hidden = YES;
            cell.userImage.hidden = NO;
            cell.lbl_title.text = @"头像";
            cell.lbl_title.font = [UIFont systemFontOfSize:17];
            cell.userImage.layer.cornerRadius = 20.f;
            [cell.userImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@40);
                make.height.equalTo(@40);
            }];
            
            if (self.userInfo.headURL) {
                [cell.userImage sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:self.userInfo.headURL] placeholderImage:[UIImage imageNamed:@"ic_empty_person"] options:SDWebImageRetryFailed|SDWebImageRefreshCached];
            }else{
                cell.userImage.image = [UIImage imageNamed:@"ic_empty_person"];
            }
            
        }
    }else if(indexPath.section == 1){
        if (0 == indexPath.row) {
            cell.lbl_title.text = @"姓名";
            cell.lbl_sub.hidden = NO;
            cell.userImage.hidden = YES;
            cell.lbl_sub.text =self.userInfo.nickname;
        }else if (1 == indexPath.row){
            cell.lbl_title.text = @"性别";
            cell.lbl_sub.hidden = NO;
            cell.userImage.hidden = YES;
            switch (self.userInfo.sex.integerValue) {
                case -1:
                    cell.lbl_sub.text = @"";
                    break;
                case 0:
                    cell.lbl_sub.text = @"女士";
                    break;
                case 1:
                    cell.lbl_sub.text = @"先生";
                    break;
                default:
                    break;
            }
//            cell.lbl_sub.text =self.userInfo.sex.description;
        }
    }
    return cell;
}

#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 76;
    }else{
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            /*
             上传
             edit:照片需要裁剪:传YES,不需要裁剪传NO(默认NO)
             */
            WS(weakSelf)
            [self showCanEdit:YES photo:^(UIImage *photo) {
                if(photo){
                    NSData *imageData = [WYUtility zipNSDataWithImage:photo];
                    //                    NSData *imageData = UIImageJPEGRepresentation(photo, 0.7);
                    [weakSelf zhHUD_showHUDAddedTo:weakSelf.view labelText:@"正在上传"];
                    [[AliOSSUploadManager sharedInstance] putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_userHeadIcon uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                    } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
                        [[[AppAPIHelper shareInstance] getUserModelAPI] updateHeadIcon:imagePath success:^(id data) {
                            [weakSelf zhHUD_hideHUDForView:weakSelf.view];
                            weakSelf.userInfo.headURL = imagePath;
                            [tableView reloadData];
                        } failure:^(NSError *error) {
                            [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
                        }];
                    } failure:^(NSError *error) {
                        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
                    }];
                }
            }];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NickNameEditViewController *vc =[[NickNameEditViewController  alloc] init];
            vc.nickName = self.userInfo.nickname;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            //性别选择
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"先生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateSex:@"1"];
                NSLog(@"先生");
            }];
            UIAlertAction *womanAction = [UIAlertAction actionWithTitle:@"女士" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self updateSex:@"0"];
                NSLog(@"女士");
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            [alertController addAction:manAction];
            [alertController addAction:womanAction];
            [alertController addAction:cancelAction];

            [self presentViewController:alertController animated:YES completion:^{
                NSLog(@"presented");
            }];
        }
    }
}

-(void)updateSex:(NSString *)sex{
    [[[AppAPIHelper shareInstance] getUserModelAPI] updateSex:sex success:^(id data) {
        self.userInfo.sex = @(sex.integerValue);
        [_accountTableview reloadData];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

@end
