//
//  BuyerInfoController.m
//  YiShangbao
//
//  Created by simon on 17/2/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BuyerInfoController.h"
#import "CommonTradePersonalCell.h"
#import "ZXTitleView.h"
#import "BuyerInfoContentCell.h"
#import "WYSurveySearchResultViewController.h"
#import "RecentlyTradeTextCell.h"
#import "RecentlyFindLabCell.h"
#import "XLPhotoBrowser.h"
#import "ZXCenterBottomToolView.h"
#import "NTESSessionViewController.h"
#import "WYNIMAccoutManager.h"
#import "TradeDetailController.h"
#import "WYReleaseBusinessListViewController.h"
#import "BuyerEvaluatedCell.h"

#import "EvaluateListViewController.h"
#import "MyCustomerAddEditController.h"

static NSString *reuse_personalCell  = @"personalCell";
static NSString *reuse_investigationCell = @"investigationCell";
static NSString *reuse_contentCell = @"contentCell";
static NSString *reuse_recentlyPushTrandeCell = @"recentlyPushTrandeCell";
static NSString *reuse_recentlyFindCell = @"recentlyFindCell";
static NSString *reuse_evaluateCell = @"evaluateCell";


static NSInteger section_recentlyFindProduct = 2;
static NSInteger section_recentlyPushTrande = 1;
static NSInteger section_evaluateList = 3;
static NSInteger section_content = 4;


@interface BuyerInfoController ()<ZXEmptyViewControllerDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) ShopPurchaserInfoModel *purchaserModel;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic ,strong) NSMutableArray *searchProTextArray;


@end

@implementation BuyerInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self setUI];
        
    [self setData];
}
- (void)dealloc
{
    
}

- (void)setUI
{
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedSectionFooterHeight = 10.f;
//    self.tableView.separatorColor = [UIColor redColor];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    [self.tableView registerNib:[UINib nibWithNibName:Xib_CommonTradePersonalCell bundle:nil] forCellReuseIdentifier:reuse_personalCell];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BuyerEvaluatedCell class]) bundle:nil] forCellReuseIdentifier:reuse_evaluateCell];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;

    if (self.boolChat)
    {
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.bottom = 60.f;
        self.tableView.contentInset = inset;
        
        UIEdgeInsets indicatorInset = self.tableView.scrollIndicatorInsets;
        indicatorInset.bottom = 60.f;
        self.tableView.scrollIndicatorInsets =indicatorInset;
        self.bottomContainerView.hidden = YES;
    }
    else
    {
        self.bottomContainerView.hidden = YES;
    }
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        if (@available(iOS 11.0, *)) {
//            make.edges.mas_equalTo(self.view.safeAreaInsets);
//        } else {
//            make.edges.mas_equalTo(self.view);
//        }
//    }];
}

#pragma mark - 删除客户
- (void)addRightDeleteCustomButtonItem:(BOOL)show
{
    if (show)
    {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"删除客户", nil) style:UIBarButtonItemStylePlain target:self action:@selector(deleteCustomerAction:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)deleteCustomerAction:(id)sender
{
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:NSLocalizedString(@"是否确定删除该客户？", nil) message:nil cancelButtonTitle:NSLocalizedString(@"取消", nil) cancleHandler:nil doButtonTitle:NSLocalizedString(@"确认删除", nil) doHandler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf deleteCustomer];
    }];
    
  
}

- (void)deleteCustomer
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getUserModelExtendAPI]postDeleteOnlineCustomerWithBuyerBizId:_bizId success:^(id data) {
        
        [MBProgressHUD zx_showSuccess:[NSString stringWithFormat:NSLocalizedString(@"已成功删除客户", nil)] toView:weakSelf.view];
        [weakSelf addBottomView];
        [weakSelf addRightDeleteCustomButtonItem:NO];
       
        //删除后、返回时跳过 查看客户信息 页面
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_remove_LookMyCustomerController object:nil];

        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}


#pragma mark - 底部按钮

- (void)addOnlyBtnBottomView
{
    [self.bottomContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    ZXCenterBottomToolView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXCenterBottomToolView owner:self options:nil] firstObject];
    view.backgroundColor = [UIColor clearColor];
  
    view.centerBtnLeadingLayout.constant = LCDScale_5Equal6_To6plus(15.f);
    view.centerBtnTopLayout.constant = LCDScale_5Equal6_To6plus(8.f);
    UIImage *backgroundImage2 = [WYUTILITY getCommonVersion2RedGradientImageWithSize:view.onlyCenterBtn.frame.size];
    [view.onlyCenterBtn setBackgroundImage:backgroundImage2 forState:UIControlStateNormal];
    [view.onlyCenterBtn setTitle:NSLocalizedString(@"在线沟通", nil) forState:UIControlStateNormal];
    [view.onlyCenterBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    
    [view.onlyCenterBtn addTarget:self action:@selector(imBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomContainerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.bottomContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
}

- (void)addBottomView
{
    [self.bottomContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    ZXTowBtnBottomToolView * view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXTowBtnBottomToolView class]) owner:self options:nil] firstObject];
    view.backgroundColor = [UIColor clearColor];
 
    UIImage *backgroundImage1 = [UIImage zx_getGradientImageFromHorizontalTowColorWithSize:view.leftBtn.frame.size startColor:UIColorFromRGB(253.f, 171.f, 83.f) endColor:UIColorFromRGB(253.f, 121.f, 83.f)];
    [view.leftBtn setBackgroundImage:backgroundImage1 forState:UIControlStateNormal];

    [view.leftBtn setTitle:NSLocalizedString(@"添加到客户", nil) forState:UIControlStateNormal];
    [view.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view.leftBtnWidthLayout.constant = LCDScale_iPhone6_Width(165.f);
    [view.leftBtn addTarget:self action:@selector(addCustomerAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *backgroundImage = [WYUTILITY getCommonVersion2RedGradientImageWithSize:view.rightBtn.frame.size];
    [view.rightBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    view.rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [view.rightBtn setTitle:NSLocalizedString(@"在线沟通", nil) forState:UIControlStateNormal];
    [view.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view.rightBtn addTarget:self action:@selector(imBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomContainerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bottomContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
}



- (void)addCustomerAction:(id)sender forEvent:(UIEvent *)event
{
    [MobClick event:kUM_b_buyerdetails_addclient];
    
    if (self.purchaserModel.purchaserType ==WYPurchaserType_app)
    {
        MyCustomerAddEditController *VC = (MyCustomerAddEditController *)[self zx_getControllerWithStoryboardName:sb_ShopCustomer controllerWithIdentifier:@"MyCustomerAddEditControllerID"];
        VC.buyerBizId = _bizId;
        VC.source = _sourceType;
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if (self.purchaserModel.purchaserType ==WYPurchaserType_weiXin)
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"该用户为没有手机注册的微信公众号用户，不能添加为客户奥~", nil) toView:self.view];
    }
    else if (self.purchaserModel.purchaserType == WYPurchaserType_tourist)
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"该用户为未登录游客，不能添加为客户奥~", nil) toView:self.view];
    }
}

- (void)imBtnAction:(id)sender
{
    [MobClick event:kUM_b_businessIM_2];

    if ([[WYNIMAccoutManager shareInstance]cheackAccoutEnable:self])
    {
        WS(weakSelf);
        [[[AppAPIHelper shareInstance]getNimAccountAPI]getChatUserIMInfoWithIDType:NIMIDType_User thisId:self.bizId success:^(id data) {
            
            NSString *accid = [data objectForKey:@"accid"];
            NSString *hisUrl = [data objectForKey:@"url"];
            NIMSession *session = [NIMSession session:accid type:NIMSessionTypeP2P];
            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
            vc.hisUrl = hisUrl;
            NSString *shopUrl = [data objectForKey:@"shopUrl"];
            vc.shopUrl = shopUrl;
            vc.hideUnreadCountView = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
        
    }

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    NSLog(@"%f",self.topLayoutGuide.length);    
}

//- (ShopPurchaserInfoModel *)purchaserModel
//{
//    if (!_purchaserModel)
//    {
//        ShopPurchaserInfoModel *model = [[ShopPurchaserInfoModel alloc] init];
//        return model;
//    }
//    return _purchaserModel;
//}

- (void)setData
{
    
    self.searchProTextArray = [NSMutableArray array];

    [self headerRefresh];
    [self.tableView.mj_header beginRefreshing];
    
    //新增客户、删除客户更新采购商信息页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:Noti_update_BuyerInfoController object:nil];
}
-(void)updateData:(id)sender
{
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
    [ProductMdoleAPI getBuyerInfoWithbizId: _bizId Success:^(id data) {
        
        weakSelf.purchaserModel = nil;
        weakSelf.purchaserModel = [[ShopPurchaserInfoModel alloc] init];
        weakSelf.purchaserModel = data;
        [weakSelf.emptyViewController hideEmptyViewInController:weakSelf hasLocalData:weakSelf.purchaserModel?YES:NO];
        if (weakSelf.boolChat)
        {
            weakSelf.bottomContainerView.hidden = NO;
        }
        if (weakSelf.purchaserModel.showCustomer)
        {
            [weakSelf addBottomView];
        }
        else
        {
            [weakSelf addOnlyBtnBottomView];
        }
        [weakSelf addRightDeleteCustomButtonItem:!weakSelf.purchaserModel.showCustomer];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (weakSelf.purchaserModel.lastProducts.count>0)
        {
            [weakSelf.searchProTextArray removeAllObjects];
            [weakSelf.searchProTextArray addObjectsFromArray:[weakSelf exchangeLastProductsTextFromData]];
        }
        
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.purchaserModel?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}



- (void)zxEmptyViewUpdateAction
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (!self.purchaserModel)
    {
        return 0;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section)
    {
        case 0:return self.purchaserModel.companyName.length>0?2:1;
            break;
        case 1:return self.purchaserModel.lastBizs.count;break;
        case 2:return self.purchaserModel.lastProducts.count>0?1:0;break;
        case 3:return self.purchaserModel.subjectPurchaseRate?1:0;break;
        default:return 1;
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if(indexPath.section==0)
    {
       if (indexPath.row==0)
       {
           CommonTradePersonalCell *cell1 = [tableView dequeueReusableCellWithIdentifier:reuse_personalCell forIndexPath:indexPath];
           cell1.selectionStyle = UITableViewCellSelectionStyleNone;
           [cell1.headBtn addTarget:self action:@selector(clickHeadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
           [cell1 setData:self.purchaserModel];
           return cell1;
       }
    }
    else if (indexPath.section ==section_recentlyPushTrande)
    {
        RecentlyTradeTextCell *recentlyCell = [tableView dequeueReusableCellWithIdentifier:reuse_recentlyPushTrandeCell forIndexPath:indexPath];
        [recentlyCell setData:[self.purchaserModel.lastBizs objectAtIndex:indexPath.row]];
        return recentlyCell;
    }
    else if (indexPath.section ==section_recentlyFindProduct)
    {
        RecentlyFindLabCell *recentlyFindProCell = [tableView dequeueReusableCellWithIdentifier:reuse_recentlyFindCell forIndexPath:indexPath];
        recentlyFindProCell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (self.purchaserModel.lastProducts.count>0)
        {
            [recentlyFindProCell setData:_searchProTextArray];
        }
        return recentlyFindProCell;
    }
    else if (indexPath.section ==section_evaluateList)
    {
        BuyerEvaluatedCell *contentCell = [tableView dequeueReusableCellWithIdentifier:reuse_evaluateCell forIndexPath:indexPath];
        [contentCell setData:self.purchaserModel.subjectPurchaseRate];
        return contentCell;
    }
    else if (indexPath.section ==section_content)
    {
        BuyerInfoContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:reuse_contentCell forIndexPath:indexPath];
        [contentCell setData:self.purchaserModel];
        return contentCell;
    }
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:reuse_investigationCell forIndexPath:indexPath];
    return cell2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {

        case 1:return self.purchaserModel.lastBizs.count==0?0.01:LCDScale_iPhone6_Width(50.f); break;
        case 2:return self.purchaserModel.lastProducts.count==0?0.01:LCDScale_iPhone6_Width(50.f); break;
        case 3:return self.purchaserModel.subjectPurchaseRate?LCDScale_iPhone6_Width(50.f):0.01; break;
        case 4:return self.purchaserModel?LCDScale_iPhone6_Width(50.f):0.01; break;
        default:return 0.01;
            break;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section ==section_recentlyPushTrande)
    {
        if (self.purchaserModel.lastBizs.count>0)
        {
            ZXActionAdditionalTitleView *titleView = [ZXActionAdditionalTitleView viewFromNib];
            titleView.titleLab.text =[NSString stringWithFormat:@"最近发布的生意(%@)",self.purchaserModel.totalNiches];
            titleView.accessoryImageView.image = [UIImage imageNamed:@"pic-jiantou"];
            titleView.detailTitleLab.text = NSLocalizedString(@"查看全部", nil);
            [titleView.tapGestureRecognizer addTarget:self action:@selector(goTradeListAction:)];
            return titleView;
        }
    }
    else if (section ==section_recentlyFindProduct)
    {
        if (self.purchaserModel.lastProducts.count>0)
        {
            ZXTitleView * titleLab = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] firstObject];
            titleLab.titleLab.text = NSLocalizedString(@"最近在找的产品", nil);
            titleLab.backgroundColor =[UIColor whiteColor];
            return titleLab;
        }
    }
    else if (section ==section_evaluateList)
    {
        if (self.purchaserModel.subjectPurchaseRate)
        {
            ZXActionAdditionalTitleView *titleView = [ZXActionAdditionalTitleView viewFromNib];
            titleView.titleLab.text =[NSString stringWithFormat:@"最近收到的评价(%@)",self.purchaserModel.countSubjectPurchaseRates];
            titleView.accessoryImageView.image = [UIImage imageNamed:@"pic-jiantou"];
            titleView.detailTitleLab.text = NSLocalizedString(@"查看全部", nil);
            [titleView.tapGestureRecognizer addTarget:self action:@selector(goEvaluateListAction:)];
            titleView.bottomLine.hidden = NO;
            return titleView;
        }
    }
    else if (section ==section_content)
    {
        if (self.purchaserModel)
        {
            
            ZXTitleView * titleView = [ZXTitleView viewFromNib];
            titleView.titleLab.text = NSLocalizedString(@"基本资料", nil);
            titleView.backgroundColor =[UIColor whiteColor];
            titleView.bottomLine.hidden = NO;
            return titleView;
        }
    }
    //透明的view；
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==section_recentlyPushTrande)
    {
        return LCDScale_5Equal6_To6plus(38.f);
    }
    else if (indexPath.section ==section_recentlyFindProduct)
    {
        static RecentlyFindLabCell *cell =  nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            cell = [tableView dequeueReusableCellWithIdentifier:reuse_recentlyFindCell];
        });
        return [cell getCellHeightWithContentIndexPath:indexPath data:self.purchaserModel.lastProducts];
    }
    return  tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 1:return self.purchaserModel.lastBizs.count==0?0.01:LCDScale_iPhone6_Width(10.f); break;
        case 2:return self.purchaserModel.lastProducts.count==0?0.01:LCDScale_iPhone6_Width(10.f); break;
        case 3:return self.purchaserModel.lastProducts.count==0?0.01:LCDScale_iPhone6_Width(10.f); break;
        default:return LCDScale_iPhone6_Width(10.f);
            break;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0 && indexPath.row ==1)
    {
        WYSurveySearchResultViewController *vc = [[WYSurveySearchResultViewController alloc] init];
        vc.text = self.purchaserModel.companyName;
        [self.navigationController pushViewController:vc animated:YES];
        
        [MobClick event:kUM_b_warningview];
    }
    else if (indexPath.section ==section_recentlyPushTrande)
    {
        RecentlyBizsModel *model =  [self.purchaserModel.lastBizs objectAtIndex:indexPath.row];
        if (model.valid)
        {
           [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_Trade identifier:SBID_TradeDetailController withData:@{@"postId":model.subjectId}];
        }
        else
        {
           [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:NSLocalizedString(@"这个生意已经被人抢啦，下次来早点哦～", nil) message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:NSLocalizedString(@"知道了", nil) doHandler:nil];
        }
     }
//    评价列表
    else if (indexPath.section ==section_evaluateList)
    {
        [self goEvaluateListAction:nil];
    }
}


- (void)clickHeadBtnAction:(UIButton *)sender
{
//    //大图浏览
    XLPhotoBrowser *browser2 = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:0 imageCount:1 datasource:self];
    browser2.browserStyle = XLPhotoBrowserStyleCustom;
    browser2.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
}


#pragma mark    -   XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    
    return self.purchaserModel.iconURL;
}


//最近在找的产品超过8个字时，多余的用省略号
- (NSMutableArray *)exchangeLastProductsTextFromData
{
    NSMutableArray *newTextArray = [NSMutableArray array];
    [self.purchaserModel.lastProducts enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (obj.length>8)
        {
            obj = [obj substringToIndex:8];
            obj = [obj stringByAppendingString:@"..."];
        }
        [newTextArray addObject:obj];
    }];
    return newTextArray;
}



- (void)goTradeListAction:(id)sender
{
    WYReleaseBusinessListViewController *vc = [[WYReleaseBusinessListViewController alloc]init];
    vc.buyerId =self.bizId;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)goEvaluateListAction:(id)sender
{
    [MobClick event:kUM_b_purchaser_evaluation];
    EvaluateListViewController *vc = [[EvaluateListViewController alloc]init];
    vc.buyerId =self.bizId;
    [self.navigationController pushViewController:vc animated:YES];
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
