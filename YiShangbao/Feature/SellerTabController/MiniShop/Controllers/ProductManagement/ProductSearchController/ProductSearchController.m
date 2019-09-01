//
//  ProductSearchController.m
//  YiShangbao
//
//  Created by simon on 2017/11/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ProductSearchController.h"
#import "SellingProductCell.h"
#import "AddProductController.h"
#import "ZXEmptyViewController.h"
#import "MessageModel.h"
#import "SoldOutProductSearchCell.h"

#import "ProMListTableView.h"
#import "ExtendProductViewController.h"
#import "ProductSearchCell.h"

@interface ProductSearchController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate,UISearchControllerDelegate>
@property (nonatomic, strong)UISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *dataMArray;

@property (nonatomic) NSInteger pageNo;
@property (nonatomic,assign) NSInteger totalPage;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation ProductSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    //    [UIView zx_NSLogSubviewsFromView:self.searchBar andLevel:1];
    
    [self setUI];
    
    [self setData];
}

- (void)dealloc
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.searchController.active = YES;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        UISearchBar *bar = [[UISearchBar alloc] init];
        bar.searchBarStyle = UISearchBarStyleMinimal;
        bar.tintColor = UIColorFromRGB(255.f, 84.f, 52.f);
        bar.placeholder = @"输入产品关键词、型号搜索产品";
        [bar sizeToFit];
        bar.delegate = self;
        bar.barTintColor = [UIColor clearColor];
        bar.showsCancelButton = YES;
        UIImage *image = [UIImage imageNamed:@"bg_search"];
        UIImage *resizableImage = [image resizableImageWithCapInsets: UIEdgeInsetsMake(0, image.size.width/2, 0, image.size.width/2)];
        [bar setSearchFieldBackgroundImage:resizableImage forState:UIControlStateNormal];
        
        if (Device_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(11))
        {
            UITextField *txfSearchField = [bar valueForKey:@"_searchField"];
            [txfSearchField setDefaultTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.5]}];
            bar.searchTextPositionAdjustment = UIOffsetMake(2, 0);
        }
        _searchBar = bar;
    }
    return _searchBar;
}



//- (UISearchController *)searchController
//{
//    if (!_searchController)
//    {
//        UISearchController *search = [[UISearchController alloc] initWithSearchResultsController:nil];
//        search.hidesNavigationBarDuringPresentation = NO;
//        search.dimsBackgroundDuringPresentation = NO;
//        search.delegate = self;
//        _searchController = search;
//
//        UISearchBar *bar = search.searchBar;
//        bar.tintColor = UIColorFromRGB(255.f, 84.f, 52.f);
//        bar.placeholder = @"输入产品关键词、型号搜索产品";
//        [bar sizeToFit];
//        bar.delegate = self;
//        bar.barTintColor = [UIColor clearColor];
//        UIImage *image = [UIImage imageNamed:@"bg_search"];
//        UIImage *resizableImage = [image resizableImageWithCapInsets: UIEdgeInsetsMake(0, image.size.width/2, 0, image.size.width/2)];
//        [bar setSearchFieldBackgroundImage:resizableImage forState:UIControlStateNormal];
//    }
//    return _searchController;
//}

- (void)setUI
{
//    [self zx_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
//    [self zx_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];

    self.view.backgroundColor = WYUISTYLE.colorBGgrey;

    
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
    
//    self.navigationItem.titleView = self.searchController.searchBar;
  
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
    
}

- (void)cancleAction:(id)sender
{
    if([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)presentSearchController:(UISearchController *)searchController
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.searchController.searchBar becomeFirstResponder];
//    });
//}
//
//
//- (void)willDismissSearchController:(UISearchController *)searchController
//{
//    if([searchController.searchBar isFirstResponder])
//    {
//        [searchController.searchBar resignFirstResponder];
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar isFirstResponder])
    {
        [searchBar resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [MobClick event:kUM_b_ordersearchinput];

    [_emptyViewController hideEmptyViewInController:self];
    [self.tableView.mj_header beginRefreshing];
    if([searchBar isFirstResponder])
    {
        [searchBar resignFirstResponder];
    }
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"];
    cancelBtn.enabled = YES;
}


- (void)setData{
    
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
    
    // 编辑及删除
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCurrentController:) name:Noti_ProductManager_Edit_goBackUpdate object:nil];
}

- (void)headerRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (![NSString zhIsBlankString:weakSelf.searchBar.text])
        {
            [weakSelf requestHeaderData];
        }
        else
        {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
}

- (void)requestHeaderData
{
    WS(weakSelf);
    [ProductMdoleAPI getSellerProductsWithProductType:MyProductType_None keyword:self.searchBar.text pageNo:1 pageSize:@(10) success:^(id data, PageModel *pageModel) {
        
        [weakSelf.dataMArray removeAllObjects];
        [weakSelf.dataMArray addObjectsFromArray:data];
        NSString *emptyStr = [NSString stringWithFormat:@"没有搜索到相关产品,\n%@",@"检查下您的关键词是否正确哦～"];
        [_emptyViewController addEmptyViewInController:weakSelf hasLocalData:_dataMArray.count error:nil emptyImage:[UIImage imageNamed:@"无人接单"] emptyTitle:emptyStr updateBtnHide:YES];
        [weakSelf.tableView reloadData];
        _pageNo = 1;
        _totalPage = [pageModel.totalPage integerValue];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf footerWithRefreshing:[pageModel.totalPage integerValue]];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        [_emptyViewController addEmptyViewInController:weakSelf hasLocalData:_dataMArray.count error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        
    }];
}

- (void)footerWithRefreshing:(NSInteger)totalPage
{
    if (_pageNo >=totalPage)
    {
        if (self.tableView.mj_footer)
        {
            self.tableView.mj_footer = nil;
        }
        return;
    }
    WS(weakSelf);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestFooterData];
        
    }];
}

- (void)requestFooterData
{
    WS(weakSelf);
    [ProductMdoleAPI getSellerProductsWithProductType:MyProductType_None keyword:self.searchBar.text pageNo:_pageNo+1 pageSize:@(10) success:^(id data, PageModel *pageModel) {
        
        [weakSelf.dataMArray addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        _pageNo ++;
        _totalPage = [pageModel.totalPage integerValue];
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0)
        {
            weakSelf.tableView.mj_footer = nil;
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
    
}

- (void)zxEmptyViewUpdateAction
{
    [self.tableView.mj_header beginRefreshing];
}


// 发送通知更新当前控制器，主要用于编辑返回，删除返回等；
- (void)updateCurrentController:(NSNotification *)notification
{
   [self performSelector:@selector(requestHeaderData) withObject:nil afterDelay:1.f];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataMArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SellingProductCell *cell = (SellingProductCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];//搞错了cell吧
    ProductSearchCell *cell = (ProductSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    SoldOutProductSearchCell *outCell = (SoldOutProductSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"SoldOutCell" forIndexPath:indexPath];
    if (self.dataMArray.count>0)
    {
        MyProductSearchModel *model = [self.dataMArray objectAtIndex:indexPath.row];
        if (model.type ==MyProductType_soldoution)
        {
            [outCell setData:model];
            [outCell.previewBtn addTarget: self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [outCell.promotionBtn addTarget:self action:@selector(promotionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [outCell.editBtn addTarget:self action:@selector(editProduct:) forControlEvents:UIControlEventTouchUpInside];
            return outCell;
        }
        else
        {
            [cell setData:model];
            [cell.previewBtn addTarget: self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.editBtn addTarget:self action:@selector(editProduct:) forControlEvents:UIControlEventTouchUpInside];
            [cell.promotionBtn addTarget:self action:@selector(promotionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
       
    }
 
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }

    MyProductSearchModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    NSString *productId = model.productId;
    
    [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_AddProductController withData:@{@"productId":productId,@"controllerDoingType":@(ControllerDoingType_EditProduct)}];
    
}

- (IBAction)backItemAction:(UIBarButtonItem *)sender {
    
    WS(weakSelf);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"11111" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return  [self.tableView isRefreshing];
}

#pragma mark - 预览
- (void)previewBtnAction:(UIButton *)sender
{
    if([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }
    
//    http://wykj.microants.cn/ycb/page/ycbProductDetailYcb.html?id={productId}&token={token}&ttid={ttid}&channel=110&trackId=110&trackSpm=searchSellerProds
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    MyProductSearchModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    
    NSString *string= [model.link stringByReplacingOccurrencesOfString:@"{productId}" withString:model.productId];
    NSString *string2 = [NSMutableString stringWithString:string];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"{token}" withString:[UserInfoUDManager getToken]];
    NSString *string3 =[string2 stringByReplacingOccurrencesOfString:@"{ttid}" withString:[BaseHttpAPI getCurrentAppVersion]];
    
    [[WYUtility  dataUtil]routerWithName:string3 withSoureController:self];

    
}
#pragma mark - 设置
- (void)editProduct:(UIButton *)sender
{
    [MobClick event:kUM_b_productcontrol_set];

    if([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }
    
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    MyProductSearchModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    
    NSArray *arrayTitle = [self getPopViewTitles:model];
    ProMListTableView *popListView = [[ProMListTableView alloc] initWithTitles:arrayTitle];
    [ProMListTableView show:popListView touchBtn:sender offSet:CGPointMake(0,10) didSelectBlock:^(NSInteger index,NSString *title) {
        if ([title isEqualToString:@"下架"])
        {
            [MobClick event:kUM_b_productcontrol_soldout];

            [self soldOutProduct:model];
        }
        else if ([title isEqualToString:@"删除"])
        {
            [MobClick event:kUM_b_productcontrol_delete];
            
            [self deleteProduct:model];
        }
        else if ([title isEqualToString:@"转为私密"])
        {
            [self toPrivateProduct:model];
        }
        else if ([title isEqualToString:@"上架"] || [title isEqualToString:@"公开上架"])
        {
            [MobClick event:kUM_b_productcontrol_putaway];
            [self toPublicProduct:model];
        }
        else if ([title isEqualToString:@"取消主营"])
        {
            [self cancelMainProduct:model];
        }
        else if ([title isEqualToString:@"设为主营"])
        {
            [self toMainProduct:model];
        }
    }];
}
//获取快捷功能标题
-(NSArray *)getPopViewTitles:(MyProductSearchModel *)model
{
    NSMutableArray *arrayM = [NSMutableArray array];
    if (model.type == MyProductType_soldoution)
    { //已下架
        [arrayM addObject:@"上架"];
        [arrayM addObject:@"删除"];
        [arrayM addObject:@"转为私密"];
        
    }else if (model.type == MyProductType_public)
    {//公开出售的产品列表
        [arrayM addObject:@"下架"];
        [arrayM addObject:@"删除"];
        [arrayM addObject:@"转为私密"];
        if (model.isMain) {
            [arrayM addObject:@"取消主营"];
        }else{
            [arrayM addObject:@"设为主营"];
        }
        
    }else if (model.type ==MyProductType_privacy)
    {//私密产品列表
        [arrayM addObject:@"下架"];
        [arrayM addObject:@"删除"];
        [arrayM addObject:@"公开上架"]; 
        
    }
    return arrayM;
}
#pragma mark - 推广
- (void)promotionBtnAction:(UIButton *)sender
{
    if([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }
    
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    MyProductSearchModel *productModel = [self.dataMArray objectAtIndex:indexPath.row];
    
//    ExtendProductViewController* product = [[ExtendProductViewController alloc] init];
//    product.numId = @(1);
//    product.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:product animated:YES];
//    return;
    
    WS(weakSelf);
    //分享
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [[[AppAPIHelper shareInstance] getMessageAPI] getShareWithType:@23 success:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:nil];
        
        shareModel *model = data;
        NSString *titleStr = [model.title stringByReplacingOccurrencesOfString:@"{productName}" withString:productModel.name];
        NSString *link = [model.link stringByReplacingOccurrencesOfString:@"{id}" withString:productModel.productId];
        
        NSString *picStr = [productModel.iconURL absoluteString];
        //1、创建分享参数 model.pic
        //        [WYSHARE shareSDKWithImage:picStr Title:titleStr Content:model.content withUrl:link];
        
        [WYShareManager shareInVC:weakSelf withImage:picStr withTitle:titleStr withContent:model.content withUrl:link];
        [WYShareManager canPushInAPPWithShareType:^(WYShareType type) {
            //推产品、清库存
            ExtendSelectProcuctModel *eSPModel = [[ExtendSelectProcuctModel alloc] init];
            eSPModel.iid = [NSNumber numberWithInteger:productModel.productId.integerValue ];
            eSPModel.url = link;
            AliOSSPicUploadModel *aModel = [[AliOSSPicUploadModel alloc] init];
            aModel.w = productModel.picWidth.floatValue;
            aModel.h = productModel.picHeight.floatValue;
            aModel.p = [productModel.iconURL absoluteString];
            eSPModel.mainPic = aModel;
            
            if (type == WYShareTypeHotProduct) {
                [MobClick event:kUM_b_productcontrol_generalize];

                ExtendProductViewController* product = [[ExtendProductViewController alloc] init];
                product.numId = @(1);
                product.selProModel = eSPModel;
                product.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:product animated:YES];
            }
            if (type == WYShareTypeStock) {
                [MobClick event:kUM_b_productcontrol_acquisition];

                ExtendProductViewController* product = [[ExtendProductViewController alloc] init];
                product.numId = @(2);
                product.selProModel = eSPModel;
                product.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:product animated:YES];
            }
        }];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
    
}
#pragma mark - ----设置接口----
//《由于搜索引擎延迟，立即去请求查找的数据状态未及时更新可能和实际不符，所以统一本地操作数据源》
#pragma mark  删除
- (void)deleteProduct:(MyProductSearchModel *)model
{
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"删除后数据无法恢复，确定删除吗？" message:nil cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:@"确认删除" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
        [ProductMdoleAPI postDeleteProductWithProductId:model.productId success:^(id data) {
            
            [MBProgressHUD zx_showSuccess:@"删除成功" toView:nil];
            //由于搜索引擎延迟，立即去请求查找的数据状态未及时更新可能和实际不符，所以统一本地操作数据源
            [self.dataMArray removeObject:model];
            [self.tableView reloadData];
            
            switch (model.type) {
                case MyProductType_soldoution:
                    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updateSoldouting object:nil userInfo:nil];
                    break;
                case MyProductType_public:
                    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil userInfo:nil];
                    break;
                case MyProductType_privacy:
                    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil userInfo:nil];
                    break;
                default:
                    break;
            }
        } failure:^(NSError *error) {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }];
    }];
}
#pragma mark  下架
- (void)soldOutProduct:(MyProductSearchModel *)model
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [ProductMdoleAPI postSoldoutProductWithProductId:model.productId success:^(id data) {
        
        [MBProgressHUD zx_showSuccess:@"下架成功" toView:nil];
//        [self.tableView.mj_header beginRefreshing];
        model.typeName = @"下架";
        model.type = MyProductType_soldoution;
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updateSoldouting object:nil userInfo:nil];
        switch (model.type) {
            case MyProductType_public:
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil userInfo:nil];
                break;
            case MyProductType_privacy:
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil userInfo:nil];
                break;
            default:
                break;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}
#pragma mark  转为私密
- (void)toPrivateProduct:(MyProductSearchModel *)model
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [ProductMdoleAPI postMyProductToProtectedWithProductId:model.productId Success:^(id data) {
        
        [MBProgressHUD zx_showSuccess:@"成功转为私密" toView:nil];
//        [self.tableView.mj_header beginRefreshing];
        model.typeName = @"私密";
        model.type = MyProductType_privacy;
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil userInfo:nil];
        switch (model.type) {
            case MyProductType_soldoution:
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updateSoldouting object:nil userInfo:nil];
                break;
            case MyProductType_public:
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil userInfo:nil];
                break;
            default:
                break;
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
    
}
#pragma mark  转为公开
- (void)toPublicProduct:(MyProductSearchModel *)model
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [ProductMdoleAPI postMyProductToPublicWithProductId:model.productId Success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"成功转为公开上架" toView:nil];
//        [self.tableView.mj_header beginRefreshing];
        model.typeName = @"公开";
        model.type = MyProductType_public;
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil userInfo:nil];
        switch (model.type) {
            case MyProductType_soldoution:
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updateSoldouting object:nil userInfo:nil];
                break;
            case MyProductType_privacy:
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil userInfo:nil];
                break;
            default:
                break;
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}
#pragma mark  设置主营
- (void)toMainProduct:(MyProductSearchModel *)model
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [ProductMdoleAPI postMyProductToMainWithProductId:model.productId Success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"已成功设为主营" toView:nil];
//        [self.tableView.mj_header beginRefreshing];
        model.isMain = YES;
        [self.tableView reloadData];
        
        //刷新上架中(上架中总数刷新就让他刷新一次吧)
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil userInfo:nil];

    } failure:^(NSError *error) {
        [MBProgressHUD zx_hideHUDForView:nil];
        
        NSString *code = [error.userInfo objectForKey:@"code"];
        if ([code isEqualToString:@"main_prod_limited"])
        {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"只能设置20个主营产品，请取消其他主营产品，再进行设置" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:actionCancel];
            [self presentViewController:alertC animated:YES completion:nil];
            
        }else{
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }
    }];
}
#pragma mark  取消主营
- (void)cancelMainProduct:(MyProductSearchModel *)model
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [ProductMdoleAPI postMyProductToCancelMainWithProductId:model.productId Success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"已取消主营" toView:nil];
        
//        [self.tableView.mj_header beginRefreshing];
        model.isMain = NO;
        [self.tableView reloadData];
        
        //刷新上架中
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil userInfo:nil];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
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

@end
