//
//  WYShopCateDetailViewController.m
//  YiShangbao
//
//  Created by light on 2017/12/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYShopCateDetailViewController.h"
#import "WYShopGoodsListTableViewCell.h"

#import "WYShopCateManageViewController.h"
#import "MessageModel.h"
#import "AddProductController.h"
#import "ExtendProductViewController.h"

@interface WYShopCateDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addGoodsButton;
@property (weak, nonatomic) IBOutlet UIButton *manageButton;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic ,strong) NSMutableArray *array;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger totalPage;

@end

@implementation WYShopCateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.shopCatgName;
    [self setUI];
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:Noti_ShopCateProducts_update object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData) name:Noti_ProductManager_Edit_goBackUpdate object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_ShopCateProducts_update object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_ProductManager_Edit_goBackUpdate object:nil];
}

- (void)updateData{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark- ButtonAction

- (IBAction)addGoodsButtonAction:(id)sender {
    [MobClick event:kUM_b_pd_newproduct];
    CodeModel *model = [[CodeModel alloc]init];
    model.code = @(self.shopCatgId.integerValue);
    model.value = self.shopCatgName;
    NSArray *modelAarray;
    if (model.code.integerValue == 0){
        modelAarray = @[];
    }else{
        modelAarray = @[model];
    }
    [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_AddProductController withData:@{@"addProductPushType":@(AddProudctPushType_goBackShopClassifySetting),@"shopClassifys":modelAarray,@"controllerDoingType":@(ControllerDoingType_AddProduct)}];
}
//批量管理
- (IBAction)manageButtonAction:(id)sender {
    if (self.array.count == 0){
        [MBProgressHUD zx_showError:@"老板，先添加几个产品吧～" toView:self.view];
        return;
    }
    WYShopCateManageViewController *vc = (WYShopCateManageViewController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_WYShopCateManageViewController];
    vc.shopCatgId = self.shopCatgId;
    vc.shopCatgName = self.shopCatgName;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//预览
- (void)previewBtnAction:(UIButton *)sender{
    //    http://wykj.microants.cn/ycb/page/ycbProductDetailYcb.html?id={productId}&token={token}&ttid={ttid}&channel=110&trackId=110&trackSpm=searchSellerProds
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    WYShopCategoryGoodsModel *model = [self.array objectAtIndex:indexPath.row];
    
    NSString *string= [model.prodUrl stringByReplacingOccurrencesOfString:@"{productId}" withString:[NSString stringWithFormat:@"%@",@(model.goodsId)]];
    NSString *string2 = [NSMutableString stringWithString:string];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"&token={token}" withString:@""];
    NSString *string3 =[string2 stringByReplacingOccurrencesOfString:@"{ttid}" withString:[BaseHttpAPI getCurrentAppVersion]];
    
    [[WYUtility  dataUtil]routerWithName:string3 withSoureController:self];
    
    
}

//编辑
- (void)editProduct:(UIButton *)sender{
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    WYShopCategoryGoodsModel *model = [self.array objectAtIndex:indexPath.row];
    NSString *productId = [NSString stringWithFormat:@"%@",@(model.goodsId)];
    
    [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_AddProductController withData:@{@"productId":productId,@"controllerDoingType":@(ControllerDoingType_EditProduct)}];
    
}

//推广
- (void)promotionBtnAction:(UIButton *)sender{
    WS(weakSelf)
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    WYShopCategoryGoodsModel *productModel = [self.array objectAtIndex:indexPath.row];
    
    //分享
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [[[AppAPIHelper shareInstance] getMessageAPI] getShareWithType:@23 success:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:nil];
        shareModel *model = data;
        NSString *titleStr = [model.title stringByReplacingOccurrencesOfString:@"{productName}" withString:productModel.name];
        NSString *link = [model.link stringByReplacingOccurrencesOfString:@"{id}" withString:[NSString stringWithFormat:@"%@",@(productModel.goodsId)]];
        NSString *picStr = productModel.pic.p;
        //1、创建分享参数 model.pic
        [WYShareManager shareInVC:weakSelf withImage:picStr withTitle:titleStr withContent:model.content withUrl:link];
        [WYShareManager canPushInAPPWithShareType:^(WYShareType type) {
            //推产品、清库存
            ExtendSelectProcuctModel *eSPModel = [[ExtendSelectProcuctModel alloc] init];
            eSPModel.iid = [NSNumber numberWithInteger:productModel.goodsId];
            eSPModel.url = link;
            AliOSSPicUploadModel *picModel = [[AliOSSPicUploadModel alloc]init];
            picModel.h = productModel.pic.h;
            picModel.w = productModel.pic.w;
            picModel.p = productModel.pic.p;
            eSPModel.mainPic = picModel;
            
            if (type == WYShareTypeHotProduct) {
                [MobClick event:kUM_b_productcontrol_generalize];

                ExtendProductViewController* product = [[ExtendProductViewController alloc] init];
                product.numId = @(1);
                product.selProModel = eSPModel;
                product.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:product animated:YES];
            }
            if (type == WYShareTypeStock) {
                [MobClick event:kUM_b_productcontrol_acquisition];

                ExtendProductViewController* product = [[ExtendProductViewController alloc] init];
                product.numId = @(2);
                product.selProModel = eSPModel;
                product.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:product animated:YES];
            }
        }];
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}

//上架
- (void)upperBtnAction:(UIButton *)sender{
//    WS(weakSelf)
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    WYShopCategoryGoodsModel *productModel = [self.array objectAtIndex:indexPath.row];
    
    NSString *producrId = [NSString stringWithFormat:@"%@",@(productModel.goodsId)];
    [UIAlertController zx_presentCustomAlertInViewController:self withTitle:@"确认产品转移为公开上架吗？" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"公开上架"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex ==controller.firstOtherButtonIndex)
        {
            [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
            [ProductMdoleAPI postMyProductToPublicWithProductId:producrId Success:^(id data) {
                [MBProgressHUD zx_showSuccess:@"成功转为公开上架" toView:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_Edit_goBackUpdate object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ShopCateProducts_update object:nil userInfo:nil];
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            }];
        }
        
    }];
    
}

#pragma mark- ZXEmptyViewControllerDelegate
- (void)zxEmptyViewUpdateAction{
    [self requestData];
}

#pragma mark- Request
- (void)requestData{
    WS(weakSelf)
    NSString *shopId = [UserInfoUDManager getShopId];
    [ProductMdoleAPI getShopCategoryListByShopId:shopId shopCatgId:self.shopCatgId pageNo:1 pageSize:10 success:^(id data, PageModel *pageModel) {
        weakSelf.array = [NSMutableArray array];
        [weakSelf.array addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.page = 1;
        weakSelf.totalPage = [pageModel.totalPage integerValue];
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }else{
            weakSelf.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(requestMoreData)];
        }
        if (weakSelf.array.count == 0){
            [weakSelf showEmptyView:nil];
        }else{
            [weakSelf.emptyViewController hideEmptyViewInController:weakSelf];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf showEmptyView:[error localizedDescription]];
    }];
}

- (void)requestMoreData{
    WS(weakSelf)
    NSString *shopId = [UserInfoUDManager getShopId];
    
    [ProductMdoleAPI getShopCategoryListByShopId:shopId shopCatgId:self.shopCatgId pageNo:self.page + 1 pageSize:10 success:^(id data, PageModel *pageModel) {
        
        [weakSelf.array addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.page ++;
        weakSelf.totalPage = [pageModel.totalPage integerValue];
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        //        [weakSelf showEmptyView:[error localizedDescription]];
    }];
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYShopGoodsListTableViewCell *cell = (WYShopGoodsListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WYShopGoodsListTableViewCellID" forIndexPath:indexPath];
    [cell setData:self.array[indexPath.row]];
    [cell.previewBtn addTarget:self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(editProduct:) forControlEvents:UIControlEventTouchUpInside];
    [cell.promotionBtn addTarget:self action:@selector(promotionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.upperBtn addTarget:self action:@selector(upperBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 178.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WYShopCategoryGoodsModel *model = [self.array objectAtIndex:indexPath.row];
    NSString *productId = [NSString stringWithFormat:@"%@",@(model.goodsId)];
    
    [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_AddProductController withData:@{@"productId":productId,@"controllerDoingType":@(ControllerDoingType_EditProduct)}];
}

#pragma mark- Private
- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//分割线
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    
    [self.addGoodsButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    self.addGoodsButton.layer.cornerRadius = 22.5;
    self.addGoodsButton.layer.masksToBounds = YES;
    
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1, 0);
    gradientLayer2.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0 - 25 , 45);
    gradientLayer2.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5247].CGColor, nil];
    [self.manageButton.layer insertSublayer:gradientLayer2 atIndex:0];
    self.manageButton.layer.cornerRadius = 22.5;
    self.manageButton.layer.masksToBounds = YES;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.emptyViewController = [[ZXEmptyViewController alloc] init];
    self.emptyViewController.delegate = self;
}

- (void)showEmptyView:(NSString *)string{
    if (!string) {
        string = @"该分类下还没有产品，快添加些产品吧～";
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:YES];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-60);
            } else {
                make.height.equalTo(self.view).offset(-60);
            }
        }];
    }else{
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:NO];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-60);
            } else {
                make.height.equalTo(self.view).offset(-60);
            }
        }];
    }
    
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
