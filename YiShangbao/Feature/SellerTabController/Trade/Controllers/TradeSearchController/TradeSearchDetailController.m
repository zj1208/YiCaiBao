//
//  TradeSearchDetailController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/8/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "TradeSearchDetailController.h"
#import "WYTradeTableViewCell.h"
#import "WYTradeAdvCell.h"

#import "ZXEmptyViewController.h"
#import "XLPhotoBrowser.h"

#import "AlertChoseController.h"

@interface TradeSearchDetailController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate,ZXEmptyViewControllerDelegate,ZXPhotosViewDelegate,XLPhotoBrowserDatasource,UIScrollViewDelegate,ZXAlertChoseControllerDelegate,UITableViewDataSourcePrefetching>

@property(nonatomic, strong) UIButton *searchBtn;

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WYTradeTableViewCell *tradeTableCell;
@property (nonatomic, strong) WYTradeAdvCell *tradeAdvCell;
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) NSMutableArray *dataMArray;
@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, assign) NSInteger pageNo; //第几页
@property (nonatomic, strong) NSString *responseId ;//前一次请求返回来的responseId

@end

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseAdvIdentifier = @"advCell";

@implementation TradeSearchDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO]; //接生意viewWillAppear

    [self setData];
    
    [self requestSearchData:1];

    [self setUI];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.searchBtn && !self.searchBtn.superview) {
        [self.navigationController.navigationBar addSubview:self.searchBtn];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBtn removeFromSuperview];

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
//footer
- (void)footerWithRefreshingIfNeed
{
    if (!self.tableView.mj_footer)
    {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestPageData_Add_1)];
        footer.stateLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12.f)];
        self.tableView.mj_footer = footer;
    }
}
-(void)requestPageData_Add_1
{
    [self requestSearchData:_pageNo+1];
}
#pragma mark - request Data
-(void)requestSearchData:(NSInteger )pageNo
{
    [[[AppAPIHelper shareInstance] getTradeMainAPI] getSearchTradeBussinessListPageNo:pageNo pageSize:@(10) keywords:self.searchKeyword requestId:self.responseId success:^(id data, PageModel *pageModel, NSString *responseId) {
        
        [self.tableView.mj_footer endRefreshing];
        if ([data count]<10)
        {
            self.tableView.mj_footer = nil;
        }else{
            [self footerWithRefreshingIfNeed];
        }
        
        self.responseId = responseId;
        if (pageNo==1) {
            self.dataMArray = [NSMutableArray arrayWithArray:data];
            _pageNo =1;
        }else{
            [self.dataMArray addObjectsFromArray:data];
            _pageNo ++;
        }
        
        [self.tableView reloadData];

         [self.emptyViewController addEmptyViewInController:self hasLocalData:self.dataMArray.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"我的接单生意为空"] emptyTitle:@"哎呀～没有相关的生意诶，试试\n搜索别的关键词吧～" updateBtnHide:YES];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];

        if (pageNo==1)
        {
            [self.emptyViewController addEmptyViewInController:self hasLocalData:self.dataMArray.count>0?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        }else{
            [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
        }
    }];
}
-(void)clickSearchBtn:(UIButton *)sender
{
    if (!self.searchVC) {
        UIStoryboard* SB = [UIStoryboard storyboardWithName:storyboard_Trade bundle:[NSBundle mainBundle]];
        TradeSearchController *tradeSearchVC= [SB instantiateViewControllerWithIdentifier:SBID_TradeSearchController];
        self.searchVC = tradeSearchVC;
    }
    self.searchVC.searchKeyword = self.searchKeyword;
    [self presentViewController:self.searchVC animated:NO completion:nil];
}

- (void)setData{
    
    _pageNo = 1;
    self.dataMArray = [NSMutableArray array];
    self.photoArray = [NSMutableArray array];

    
    // 已接单
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedTradeFinish:) name:Noti_Trade_haveReceivedTrade object:nil];
//
//    // 重复接单 或  已经被别人接单了；
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedTradeFinish:) name:Noti_Trade_subjectCompleted object:nil];
    
}

- (void)setUI
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40,6, LCDW-78-10, 32)];
    btn.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    [btn setImage:[UIImage imageNamed:@"search_search"] forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    [btn setTitleColor:[UIColor colorWithHexString:@"2F2F2F"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 5);
    btn.layer.cornerRadius = 16.f;
    btn.layer.masksToBounds = YES;
    self.searchBtn = btn;
    [self.searchBtn setTitle:self.searchKeyword forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(clickSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.navigationBar addSubview:self.searchBtn];
    
//    UIView *customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, LCDW, 32)];
//    [customTitleView addSubview:btn];
//    self.navigationItem.titleView = customTitleView;//在iOS10上，放回按钮位置较大，导致向右平移无法按照设计图

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor = WYUISTYLE.colorF3F3F3;
    [self.view addSubview:_tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WYTradeTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"WYTradeAdvCell" bundle:nil] forCellReuseIdentifier:reuseAdvIdentifier];
    
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if ([self.tableView respondsToSelector:@selector(prefetchDataSource)])
    {
        self.tableView.prefetchDataSource = self;
    }
    self.tradeTableCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    self.tradeAdvCell = [self.tableView dequeueReusableCellWithIdentifier:reuseAdvIdentifier];
    
 
}
-(void)setSearchKeyword:(NSString *)searchKeyword
{
    _searchKeyword = searchKeyword;
    if (self.searchBtn) {
        [self.searchBtn setTitle:_searchKeyword forState:UIControlStateNormal];
    }
}
//失败氛围图
-(ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
        emptyVC.delegate = self;
        emptyVC.view.frame = self.view.frame;
        self.emptyViewController = emptyVC;
    }
    return _emptyViewController;
}
#pragma mark - 请求失败／列表为空时候的代理请求
- (void)zxEmptyViewUpdateAction
{
    [self requestSearchData:1];
}


#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataMArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataMArray.count>0)
    {
        WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        if (model.cellType ==WXCellType_Trade)
        {
            WYTradeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
//            cell.delegate = self;
            cell.photosView.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deleteBtn.hidden = YES;//不需要删除功能
            cell.goTrade.userInteractionEnabled = NO;//按钮事件关闭，由cell代理处理点击事件
            [cell setData:model];
            return cell;
        }
    }
    WYTradeAdvCell *advCell = (WYTradeAdvCell *)[tableView dequeueReusableCellWithIdentifier:reuseAdvIdentifier forIndexPath:indexPath];
    advCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataMArray.count>0)
    {
        WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        [advCell setData:model];
    }
    return advCell;
}

#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataMArray.count>0)
    {
        WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        if (model.cellType ==WXCellType_Trade) {
            CGFloat height = [self.tradeTableCell getCellHeightWithContentData:model];
            return height;
        }
        else
        {
            return [self.tradeAdvCell getCellHeightWithContentData:model];
        }
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    if (model.cellType ==WXCellType_Trade)
    {
        if (model.orderingBtnModel.buttonType ==1)
        {
            if ([self xm_performActionWithIsLogin:ISLOGIN withPopAlertView:NO])
            {
                [self xm_pushStoryboardViewControllerWithStoryboardName:storyboard_Trade identifier:SBID_TradeDetailController withData:@{@"postId":model.postId,@"nTitle":@"生意"}];
//                [MobClick event:kUM_gotoBuild];
//                self.selectedIndexPath = indexPath;
            }
        }
        else
        {
            [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"这个生意已经被人抢啦，下次来早点哦～" message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"知道了" doHandler:nil];
        }
    }
    else
    {
//        if (_relatedToMeListType == TradeRelatedToMeListType_all) {
//            //最新发布
//            [self requestClickAdvWithAreaId:@1007 advId:model.postId];
//        }
//        else if (_relatedToMeListType == TradeRelatedToMeListType_systemRecommend) { //与我相关
//            [self requestClickAdvWithAreaId:@10072 advId:model.postId];
//        }
//        else if (_relatedToMeListType == TradeRelatedToMeListType_inventory){
//            //智能排序-库存专区
//            [self requestClickAdvWithAreaId:@10071 advId:model.postId];
//        }
        [[WYUtility dataUtil]routerWithName:model.h5Url withSoureController:self];
    }
}

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (self.dataMArray.count>indexPath.section)
        {
            WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
            if (model.cellType ==WXCellType_Trade)
            {
                WYTradeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                NSURL *headUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:model.URL.absoluteString];
                [cell.headBtn sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:AppPlaceholderHeadImage];
            }
        }
        
    }];
}
- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (self.dataMArray.count>indexPath.section)
        {
            WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
            if (model.cellType ==WXCellType_Trade)
            {
                WYTradeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell.headBtn sd_cancelImageLoadForState:UIControlStateNormal];
            }
        }
        
    }];
}
#pragma mark - 预览图片
#pragma  mark - MWPhotoBrowser
- (void)zx_photosView:(ZXPhotosView *)photosView didSelectWithIndex:(NSInteger)index photosArray:(NSArray *)photos userInfo:(nullable id)userInfo
{
    
    [_photoArray removeAllObjects];
    //大图浏览
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *zxPhoto = (ZXPhoto*)obj;
        NSURL *url = [NSURL URLWithString:zxPhoto.original_pic];
        //大图浏览
        [_photoArray addObject:url];
    }];
    
    //大图浏览
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:photos.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
    
    //点击大图统计
    [[[AppAPIHelper shareInstance]getTradeMainAPI]getTradePicClickWithTradeId:userInfo success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark    -   XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return _photoArray[index];
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
