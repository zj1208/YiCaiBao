//
//  WYAttentionListViewController.m
//  YiShangbao
//
//  Created by light on 2018/5/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYAttentionListViewController.h"
#import "PurACommendTableViewCell.h"
#import "PurANewsTableViewCell.h"
#import "PurAEmptyTableViewCell.h"
#import "PurAADVTableViewCell.h"
#import "WYAttentionModel.h"

#import "ZXEmptyViewController.h"
#import "ZXPhotosView.h"
#import "XLPhotoBrowser.h"
#import "WYNIMAccoutManager.h"

#import "NTESSessionViewController.h"

@interface WYAttentionListViewController () <UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate,PurACommendTableViewCellDelegate,PurANewsTableViewCellDelegate,XLPhotoBrowserDatasource,ZXPhotosViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;


@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSArray *sellerArray;
@property (nonatomic) NSInteger page;
//@property (nonatomic) NSInteger totalPage;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic) BOOL isNewBatch;//需要刷新换一批

@property (nonatomic, weak) PurACommendTableViewCell *commendCell;

@end

@implementation WYAttentionListViewController

#pragma mark ------LifeCircle------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self addEmptyView];
    self.page = 1;
    self.requestId = @"";
    self.photoArray = [NSMutableArray array];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData{
    if (self.isNeedReload){
        [self.tableView.mj_header beginRefreshing];
        self.isNeedReload = NO;
    }else{
        [self reloadNewBatch];
    }
}

//精选供应商换一批
- (void)reloadNewBatch{
    [MobClick event:kUM_c_list_change];
    [self requestNewBatch];
}

//下拉刷新
- (void)headRequest{
    [MobClick event:kUM_c_list_pulldown];
    [self requestData];
    [self reloadNewBatch];
}

#pragma mark ------PurANewsTableViewCellDelegate------
//在线沟通
- (void)contactShoperByStoreId:(NSString *)storeId{
    [MobClick event:kUM_c_list_message];
    [self requestIMWithStoreId:storeId];
}

//推荐信息店铺
- (void)goStoreUrl:(NSString *)storeUrl{
    [MobClick event:kUM_c_list_head];
//    NSString* strurl = [NSString stringWithFormat:@"%@/ycb/page/ycbShopDetail.html?id=%@&token=%@&ttid=%@&trackld=%@",[WYUserDefaultManager getkAPP_H5URL],storeId,[UserInfoUDManager getToken],[BaseHttpAPI getCurrentAppVersion],@"115"];
    [[WYUtility dataUtil] routerWithName:storeUrl withSoureController:self];
}

//推荐消息关注/取消关注
- (void)attentionStoreId:(NSString *)storeId isAttention:(NSString *)isAttention{
    //关注首页关注时
    if ([isAttention isEqualToString:@"1"]) {
        [MobClick event:kUM_c_list_follow];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_update_WYAttentionViewController object:nil];
    }
    [self requestAttentionShopId:storeId status:isAttention];
}

#pragma mark ------PurACommendTableViewCellDelegate------
//换一批精选供应商
- (void)reNewBatch{
    [self requestNewBatch];
}
//精选供应商店铺页面
- (void)goStoreIndex:(NSInteger)item{
    [MobClick event:kUM_c_acrosslist_head];
    WYSupplierModel *supplierModel = self.sellerArray[item];
//    NSString* strurl = [NSString stringWithFormat:@"%@/ycb/page/ycbShopDetail.html?id=%@&token=%@&ttid=%@&trackld=%@",[WYUserDefaultManager getkAPP_H5URL],supplierModel.shopId,[UserInfoUDManager getToken],[BaseHttpAPI getCurrentAppVersion],@"115"];
    [[WYUtility dataUtil] routerWithName:supplierModel.link withSoureController:self];
}
//精选供应商关注
- (void)attentionStoreIndex:(NSInteger)item{
    WYSupplierModel *supplierModel = self.sellerArray[item];
    if (!supplierModel.isAttention){
        [MobClick event:kUM_c_acrosslist_follow];
    }
    [self requestAttentionShopId:supplierModel.shopId.stringValue status:[NSString stringWithFormat:@"%d",!supplierModel.isAttention]];
}

#pragma mark ------ZXEmptyViewControllerDelegate------
- (void)zxEmptyViewUpdateAction{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ------Request------

- (void)requestData{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance ] getAttentionAPI] getFollowShopsDynamicsPageNo:@(1) pageSize:@10 type:@(self.attentionType) requestId:self.requestId success:^(id data) {
        [weakSelf.tableView.mj_header endRefreshing];
        WYAttentionsModel *model = data;
        weakSelf.remark = model.remark;
        [weakSelf showRemarkString:model.remark];
        weakSelf.array = [NSMutableArray array];
        [weakSelf.array addObjectsFromArray:model.list];
        weakSelf.requestId = model.responseId;
        [weakSelf.tableView reloadData];
        weakSelf.page = 1;
//        weakSelf.totalPage = [model.page.totalPage integerValue];
        if ([model.page.pageSize integerValue] != 10){
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
        weakSelf.array = [NSMutableArray array];
        [weakSelf.tableView reloadData];
//        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestMoreData{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance ] getAttentionAPI ] getFollowShopsDynamicsPageNo:@(self.page + 1) pageSize:@10 type:@(self.attentionType) requestId:self.requestId success:^(id data) {
        WYAttentionsModel *model = data;
        [weakSelf.array addObjectsFromArray:model.list];
        weakSelf.requestId = model.responseId;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.page ++;
//        weakSelf.totalPage = [model.page.totalPage integerValue];
        if ([model.page.pageSize integerValue] != 10){
            weakSelf.tableView.mj_footer = nil;
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.parentViewController.view];
    }];
}

//换一批精选供应商
- (void)requestNewBatch{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance ] getAttentionAPI ] getBuyerPriseSuppliersType:@(self.attentionType) success:^(id data) {
        
        weakSelf.sellerArray = [NSMutableArray array];
        weakSelf.sellerArray = data;
        weakSelf.isNewBatch = YES;
        
        if (weakSelf.commendCell) {
            if (self.sellerArray.count > 0){
                [weakSelf.commendCell updateData:self.sellerArray isType:self.attentionType];
            }
        }else {
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.parentViewController.view];
    }];
}

//关注
- (void)requestAttentionShopId:(NSString *)shopId status:(NSString *)status{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getShopAPI] postShopAttentionShopId:shopId status:status success:^(id data) {
        if ([status isEqualToString:@"1"]){
            [MBProgressHUD zx_showSuccess:NSLocalizedString(@"关注成功", @"关注成功") toView:weakSelf.parentViewController.view];
        }else{
            [MBProgressHUD zx_showSuccess:NSLocalizedString(@"已取消关注",@"已取消关注") toView:weakSelf.parentViewController.view];
        }
        [weakSelf changeAttentionShopId:shopId status:status];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.parentViewController.view];
    }];
}

//IM聊天
- (void)requestIMWithStoreId:(NSString *)storeId{
    WS(weakSelf);
    if ([[WYNIMAccoutManager shareInstance]cheackAccoutEnable:self]){
        [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.parentViewController.view];
        [[[AppAPIHelper shareInstance]getNimAccountAPI]getChatUserIMInfoWithIDType:NIMIDType_Shop thisId:storeId success:^(id data) {
            
            [MBProgressHUD zx_hideHUDForView:weakSelf.parentViewController.view];
            
            NSString *accid = [data objectForKey:@"accid"];
            NSString *hisUrl = [data objectForKey:@"url"];
            NSString *shopUrl = [data objectForKey:@"shopUrl"];
            NIMSession *session = [NIMSession session:accid type:NIMSessionTypeP2P];
            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
            vc.hisUrl = hisUrl;
            vc.shopUrl = shopUrl;
            //                vc.hideUnreadCountView = NO;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.parentViewController.view];
        }];
        
    }
}
#pragma  mark - MWPhotoBrowser
//点击大图预览
- (void)zx_photosView:(ZXPhotosView *)photosView didSelectWithIndex:(NSInteger)index photosArray:(NSArray *)photos userInfo:(nullable id)userInfo{
    [MobClick event:kUM_c_list_pic];
    NSIndexPath *indexPath = userInfo;
    WYAttentionContentModel *model = self.array[indexPath.section];
    
    //产品Url处理
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < model.baseVO.products.count; ++i) {
        WYAttentionProdutModel *produtModel = model.baseVO.products[i];
        XLPhotoUrlModel *model = [[XLPhotoUrlModel alloc] init];
        if (produtModel.linkUrl.length > 0) {
            model.goodsUrl = produtModel.linkUrl;
        }
        [arrayM addObject:model];
    }
    WS(weakSelf)
    [_photoArray removeAllObjects];
    //大图浏览
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *zxPhoto = (ZXPhoto*)obj;
        NSURL *url = [NSURL URLWithString:zxPhoto.original_pic];
        //大图浏览
        [weakSelf.photoArray addObject:url];
    }];
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoAndProductBrowserWithCurrentImageIndex:index  imageCount:photos.count goodsUrlList:arrayM datasource:self];
    //大图浏览
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
    
//    //点击大图统计
//    [[[AppAPIHelper shareInstance]getTradeMainAPI]getTradePicClickWithTradeId:userInfo success:^(id data) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

#pragma mark ------XLPhotoBrowserDatasource------
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return _photoArray[index];
}

#pragma mark ------UITableviewDatasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10.0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [[UIView alloc]initWithFrame:CGRectZero];
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYAttentionContentModel *model = self.array[indexPath.section];
    if (model.contentType.integerValue == 1) {
        PurANewsTableViewCell *cell = (PurANewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PurANewsTableViewCellID];
        cell.delegate = self;
        cell.photoView.delegate = self;
        cell.photoView.userInfo = indexPath;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell updateData:model.baseVO];
        return cell;
    }else if (model.contentType.integerValue == 2) {
        PurACommendTableViewCell *cell = (PurACommendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PurACommendTableViewCellID];
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (self.sellerArray.count > 0){
            [cell updateData:self.sellerArray isType:self.attentionType];
        }
        if (self.isNewBatch) {
            self.isNewBatch = NO;
            [cell updatePoint];
        }
        self.commendCell = cell;
        return cell;
    }else if (model.contentType.integerValue == 4) {
        PurAEmptyTableViewCell *cell = (PurAEmptyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PurAEmptyTableViewCellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell updateData:self.remark];
        return cell;
    }else {
        // contentType  3
        PurAADVTableViewCell *cell = (PurAADVTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PurAADVTableViewCellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell updateData:model.adVO];
        return cell;
    }
}

#pragma mark ------UITableViewDelegate------
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WYAttentionContentModel *model = self.array[indexPath.section];
    if (model.contentType.integerValue == 1) {
        [self goStoreUrl:model.baseVO.shopUrl];
    }else if (model.contentType.integerValue == 3) {
        [[WYUtility dataUtil] routerWithName:model.adVO.adUrl withSoureController:self];
    }
}

#pragma mark ------Private------

- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 170.0;
    
    [_tableView registerNib:[UINib nibWithNibName:@"PurANewsTableViewCell" bundle:nil] forCellReuseIdentifier:PurANewsTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"PurACommendTableViewCell" bundle:nil] forCellReuseIdentifier:PurACommendTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"PurAEmptyTableViewCell" bundle:nil] forCellReuseIdentifier:PurAEmptyTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"PurAADVTableViewCell" bundle:nil] forCellReuseIdentifier:PurAADVTableViewCellID];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRequest)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (void)showRemarkString:(NSString *)remark{
    self.tipLabel.text = remark;
    if (remark.length > 0 && self.attentionType == WYAttentionTypeAll) {
        self.tableViewTopConstraint.constant = 0;
    }else{
        self.tipLabel.text = @"";
        self.tableViewTopConstraint.constant = -12;
    }
}

- (void)addEmptyView{
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate =self;
    emptyVC.contentOffest =CGSizeMake(0, 10);
    self.emptyViewController = emptyVC;
    
    [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];
    
}

//修改对店铺关注状态
- (void)changeAttentionShopId:(NSString *)shopId status:(NSString *)status{
    for (WYAttentionContentModel *model in self.array) {
        if ([model.baseVO.shopId isEqualToString:shopId]){
            model.baseVO.isAttention = status.boolValue;
        }
    }
    for (WYSupplierModel *model in self.sellerArray) {
        if ([model.shopId.stringValue isEqualToString:shopId]) {
            model.isAttention = status.boolValue;
        }
    }
    [self.tableView reloadData];
}

- (void)showEmptyView:(NSString *)string{
    [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:NO];
    [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
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
