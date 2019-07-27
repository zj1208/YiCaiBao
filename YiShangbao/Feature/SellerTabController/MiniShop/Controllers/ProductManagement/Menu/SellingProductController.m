//
//  SellingProductController.m
//  YiShangbao
//
//  Created by simon on 17/2/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SellingProductController.h"
#import "SellingProductCell.h"
#import "AddProductController.h"
#import "ZXEmptyViewController.h"
#import "MessageModel.h"

#import "PopView.h"
#import "ProMListTableView.h"
#import "ExtendProductViewController.h"

@interface SellingProductController ()<ZXEmptyViewControllerDelegate>

@property (nonatomic,strong)NSMutableArray *dataMArray;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic,assign) NSInteger totalPage;

@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@end

@implementation SellingProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    // Uncomment the following line to preserve selection between presentations.
  
    [self setData];
}

- (void)setUI
{
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.estimatedRowHeight = 100.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);    
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate =self;
    emptyVC.view.zx_y = 10;
    emptyVC.view.zx_height = LCDH-150;
    self.emptyViewController = emptyVC;
}

- (void)updateData:(id)notification
{
    if (self.dataMArray.count>0) {//多页数据beginRefreshing不能滚动顶部bug
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    [self.tableView.mj_header beginRefreshing];
}
//时间排序
-(void)setDirection:(BOOL)direction
{
    _direction = direction;
    [self updateData:nil];
}
//只看主营
-(void)setOnlyMain:(BOOL)onlyMain
{
    _onlyMain = onlyMain;
    [self updateData:nil];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)zxEmptyViewUpdateAction
{
    [self.tableView.mj_header beginRefreshing];
}


- (void)setData
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData:) name:Noti_ProductManager_updatePublic object:nil];

    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
    [self.tableView.mj_header beginRefreshing];
}


- (void)headerRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestHeaderData];
    }];
    
}
- (void)requestHeaderData
{
    WS(weakSelf);
    [ProductMdoleAPI getMyProductListWithType:MyProductType_public onlyMain:self.onlyMain direction:self.direction pageNo:1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
        
        [weakSelf.dataMArray removeAllObjects];
        [weakSelf.dataMArray addObjectsFromArray:data];
        
        if (weakSelf.onlyMain) {
            [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count error:nil emptyImage:[UIImage imageNamed:@"产品公开为空"] emptyTitle:@"您还没设置主营产品噢～\n主营产品会展示在商铺首页，且搜索权重会加分，快去上传产品设置为主营吧～" updateBtnHide:YES];
        }else{
            [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count error:nil emptyImage:[UIImage imageNamed:@"产品公开为空"] emptyTitle:@"产品多了，客人自然也多了，点上货马上传产品" updateBtnHide:YES];
        }
        
        [weakSelf.tableView reloadData];
        weakSelf.pageNo = 1;
        weakSelf.totalPage = [pageModel.totalPage integerValue];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf footerWithRefreshing:[pageModel.totalPage integerValue]];

    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
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
    [ProductMdoleAPI getMyProductListWithType:MyProductType_public onlyMain:self.onlyMain direction:self.direction pageNo:_pageNo+1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
        
        [weakSelf.dataMArray addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        weakSelf.pageNo ++;
        weakSelf.totalPage = [pageModel.totalPage integerValue];
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0)
        {
            weakSelf.tableView.mj_footer = nil;
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    SellingProductCell *cell = (SellingProductCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.dataMArray.count>0)
    {
        [cell setData:[self.dataMArray objectAtIndex:indexPath.row]];
    }
    [cell.previewBtn addTarget: self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(editProduct:) forControlEvents:UIControlEventTouchUpInside];
    [cell.promotionBtn addTarget:self action:@selector(promotionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}



#pragma mark - 编辑状态回调
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
/*
// 左侧按钮滑动事件的自定义
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos)
{
    if (@available(iOS 11.0, *))
    {
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"增加" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//           UIContextualActionStyleNormal样式的时候， 回调YES或NO都不会移除这个cell
            completionHandler(YES);
        }];
        UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
        return configuration;
    } else {
        // Fallback on earlier versions
        return nil;
    }
}

// 右侧按钮滑动事件的自定义
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos)
{
    if (@available(iOS 11.0, *)) {
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            [self deleteAction:indexPath completion:completionHandler];
            completionHandler(YES);
        }];
        UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
        return configuration;
        
    } else {
        // Fallback on earlier versions
        return nil;
    }
}


// iOS11之前的方法

- (NSArray <UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteAction:indexPath completion:nil];
        NSLog(@"删除");
    }];
    return @[action1];
}

#pragma mark - 删除

- (void)deleteDataInTableViewWithIndexPath:(NSIndexPath *)indexPath
{
    [_dataMArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (_dataMArray.count==0)
    {
        [MBProgressHUD zx_hideHUDForView:nil];
        if (self.tableView.mj_footer)
        {
            self.tableView.mj_footer = nil;
        }
        //展示氛围图
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:[UIImage imageNamed:@"产品公开为空"] emptyTitle:@"产品多了，客人自然也多了，点上货马上传产品" updateBtnHide:YES];
    }
    else
    {
        [MBProgressHUD zx_showSuccess:@"成功删除该产品" toView:nil];
        if (self.tableView.contentSize.height<(LCDH+self.tableView.rowHeight) &&_totalPage>1 &&_pageNo<_totalPage)
        {
            [self requestHeaderData];
        }
    }
}

- (void)deleteAction:(NSIndexPath *)indexPath completion:(void(^)(BOOL completion))completionHandler
{
    ShopMyProductModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    NSString *productId = model.productId;
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"确认删除该产品？" message:nil cancelButtonTitle:@"关闭" cancleHandler:^(UIAlertAction * _Nonnull action){
        if (completionHandler)
        {
            completionHandler(NO);
        }
        else
        {
            self.tableView.editing = NO;
        }

    } doButtonTitle:@"确认删除" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
        
        [ProductMdoleAPI postDeleteProductWithProductId:productId success:^(id data) {
            
            [weakSelf deleteDataInTableViewWithIndexPath:indexPath];
            if (completionHandler)
            {
                completionHandler(YES);
            }
            
        } failure:^(NSError *error) {
            
            if (completionHandler)
            {
                completionHandler(NO);
            }
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            
        }];
    }];
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ShopMyProductModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    NSString *productId = model.productId;

    [self xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_AddProductController withData:@{@"productId":productId,@"controllerDoingType":@(ControllerDoingType_EditProduct)}];
    
}

#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return  [self.tableView isRefreshing];
}

#pragma mark - 预览
- (void)previewBtnAction:(UIButton *)sender
{
    
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    ShopMyProductModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    
    NSString *string= [model.link stringByReplacingOccurrencesOfString:@"{0}" withString:model.productId];
    NSString *string2 = [NSMutableString stringWithString:string];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"&wxtoken={1}" withString:@""];
    NSString *string3 =[string2 stringByReplacingOccurrencesOfString:@"{2}" withString:[BaseHttpAPI getCurrentAppVersion]];
    
    [[WYUtility dataUtil]routerWithName:string3 withSoureController:self];
}
#pragma mark - 设置
- (void)editProduct:(UIButton *)sender
{
    [MobClick event:kUM_b_productcontrol_set];

    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    ShopMyProductModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    NSString *productId = model.productId;
   
    NSMutableArray *arrayM = [NSMutableArray arrayWithObjects:@"下架",@"删除",@"转为私密", nil];
    model.isMain?[arrayM addObject:@"取消主营"]:[arrayM addObject:@"设为主营"];
    ProMListTableView *popListView = [[ProMListTableView alloc] initWithTitles:arrayM];
    [ProMListTableView show:popListView touchBtn:sender offSet:CGPointMake(0,10) didSelectBlock:^(NSInteger index,NSString *title) {
        if ([title isEqualToString:@"下架"])
        {
            [MobClick event:kUM_b_productcontrol_soldout];
            [self soldOutProduct:productId];
        }
        else if ([title isEqualToString:@"删除"])
        {
            [MobClick event:kUM_b_productcontrol_delete];

            [self deleteProduct:productId];
        }
        else if ([title isEqualToString:@"转为私密"])
        {
            [self toPrivateProduct:productId];
        }
        else if ([title isEqualToString:@"取消主营"])
        {
            [self cancelMainProduct:productId];
        }
        else if ([title isEqualToString:@"设为主营"])
        {
            [self toMainProduct:productId];
        }        
    }];

}
#pragma mark  推广
- (void)promotionBtnAction:(UIButton *)sender
{
   
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    ShopMyProductModel *productModel = [self.dataMArray objectAtIndex:indexPath.row];

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
        
        [WYShareManager shareInVC:self withImage:picStr withTitle:titleStr withContent:model.content withUrl:link];
        [WYShareManager canPushInAPPWithShareType:^(WYShareType type) {
            //推产品、清库存
            ExtendSelectProcuctModel *eSPModel = [[ExtendSelectProcuctModel alloc] init];
            eSPModel.iid = [NSNumber numberWithInteger:productModel.productId.integerValue ];
            eSPModel.url = link;
            eSPModel.mainPic = productModel.pic;
            
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
#pragma mark  删除
- (void)deleteProduct:(NSString *)productId
{
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"删除后数据无法恢复，确定删除吗？" message:nil cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:@"确认删除" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
        [ProductMdoleAPI postDeleteProductWithProductId:productId success:^(id data) {
            
            [MBProgressHUD zx_showSuccess:@"删除成功" toView:nil];
            //1.容器视图收到更新公开上架产品总数;2.自身收到下啦刷新
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil userInfo:nil];
        } failure:^(NSError *error) {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }];
    }];
}
#pragma mark  下架
- (void)soldOutProduct:(NSString *)productId
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [ProductMdoleAPI postSoldoutProductWithProductId:productId success:^(id data) {

        [MBProgressHUD zx_showSuccess:@"下架成功" toView:nil];
        //1.容器视图收到更新公开上架产品总数;2.自身收到下拉刷新
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updateSoldouting object:nil userInfo:nil];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}
#pragma mark  转为私密
- (void)toPrivateProduct:(NSString *)productId
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [ProductMdoleAPI postMyProductToProtectedWithProductId:productId Success:^(id data) {

        [MBProgressHUD zx_showSuccess:@"成功转为私密" toView:nil];
        //1.容器视图收到更新公开上架产品总数;2.自身收到下拉刷新
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
        
}
#pragma mark  转为公开
- (void)toPublicProduct:(NSString *)productId
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [ProductMdoleAPI postMyProductToPublicWithProductId:productId Success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"成功转为公开上架" toView:nil];
       
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}
#pragma mark  设置主营
- (void)toMainProduct:(NSString *)productId
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [ProductMdoleAPI postMyProductToMainWithProductId:productId Success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"已成功设为主营" toView:nil];
        [self updateData:nil];

    } failure:^(NSError *error) {
        [MBProgressHUD zx_hideHUDForView:nil];

        NSString *code = [error.userInfo objectForKey:@"code"];
        if ([code isEqualToString:@"main_prod_limited"])
        {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:[error localizedDescription] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:actionCancel];
            [self presentViewController:alertC animated:YES completion:nil];
            
        }else{
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }
    }];
}
#pragma mark  取消主营
- (void)cancelMainProduct:(NSString *)productId
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [ProductMdoleAPI postMyProductToCancelMainWithProductId:productId Success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"已取消主营" toView:nil];
        [self updateData:nil];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
