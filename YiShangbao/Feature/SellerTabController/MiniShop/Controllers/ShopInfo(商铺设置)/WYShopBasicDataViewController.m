//
//  WYShopBasicDataViewController.m
//  YiShangbao
//
//  Created by light on 2018/1/22.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYShopBasicDataViewController.h"
#import "ShopBasicHeadTableViewCell.h"
#import "ShopBasicDataTableViewCell.h"
//图片上传
#import "AliOSSUploadManager.h"
#import "UIViewController+XHPhoto.h"

#import "ShopIntroViewController.h"
#import "ShopAddressViewController.h"
#import "WYWriteShopNameViewController.h"

@interface WYShopBasicDataViewController ()<UITableViewDelegate,UITableViewDataSource,WYWriteShopNameDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ShopInfoModel *shopInfoModel;

@end

@implementation WYShopBasicDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商铺信息";
    [self setUI];
    //初始化oss上传
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self shopInfoRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 列表点击事件

//商铺头像
-(void)setHeadImageAction{
    /*
     上传
     edit:照片需要裁剪:传YES,不需要裁剪传NO(默认NO)
     */
    WS(weakSelf);
    [self showCanEdit:YES photo:^(UIImage *photo) {
        if(photo){
            NSData *imageData = [WYUtility zipNSDataWithImage:photo];
            //            NSData *imageData = UIImageJPEGRepresentation(photo, 0.7);
            [MBProgressHUD zx_showLoadingWithStatus:NSLocalizedString(@"正在上传", nil) toView:weakSelf.view];
            [[AliOSSUploadManager sharedInstance] putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_shopHeadIcon uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {

                [[[AppAPIHelper shareInstance] getShopAPI] modifyShopIconWithIcon:imagePath success:^(id data) {
       
                    weakSelf.shopInfoModel.iconUrl = imagePath;
                    [weakSelf.tableView reloadData];
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
                }];
            } failure:^(NSError *error) {
                [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];

            }];
        }
    }];
}
//商铺名称
- (void)shopNameAction{
    if (self.shopInfoModel.canModify.boolValue){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"修改商铺名称，请联系客服400-666-0998", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"关闭", nil)  style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"联系客服", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006660998"]];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:doAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        WYWriteShopNameViewController  *writeShopNameVC = [[WYWriteShopNameViewController alloc]init];
        writeShopNameVC.hidesBottomBarWhenPushed = YES;
        writeShopNameVC.shopName = self.shopInfoModel.shopName;
        writeShopNameVC.isChangeShopName = YES;
        [self.navigationController pushViewController:writeShopNameVC animated:YES];
    }
}

//商铺简介
-(void)setShopIntroAction{
    ShopIntroViewController *vc = [[ShopIntroViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//商铺地址
-(void)setShopAddressAction{
    ShopAddressViewController *vc = [[ShopAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- WYWriteShopNameDelegate
- (void)confirmShopName:(NSString *)name{
    
}

#pragma mark- Request
- (void)shopInfoRequest{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:@"" toView:self.view];
    [[[AppAPIHelper shareInstance] getShopAPI] getShopStoreShopInfoNewSuccess:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        weakSelf.shopInfoModel = data;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}


#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ShopBasicHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopBasicHeadTableViewCellID];
        [cell setName:@"商铺头像" imageName:self.shopInfoModel.iconUrl];
        return cell;
    }else{
        ShopBasicDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopBasicDataTableViewCellID];
        if (indexPath.row == 0) {
            [cell setName:@"商铺名称" value:self.shopInfoModel.shopName];
        }else if (indexPath.row == 1){
            [cell setName:@"商铺简介" value:self.shopInfoModel.outline];
        }else if (indexPath.row == 2){
            [cell setName:@"商铺地址" value:self.shopInfoModel.address];
        }
        return cell;
    }
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 75.0;
    }else{
        return 45.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [view setBackgroundColor:[UIColor colorWithHex:0xE5E5E5]];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self setHeadImageAction];
    }else if (indexPath.row == 0){
        [self shopNameAction];
    }else if (indexPath.row == 1){
        [self setShopIntroAction];
    }else if (indexPath.row == 2){
        [self setShopAddressAction];
    }
}

#pragma Private

- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//分割线
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
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
