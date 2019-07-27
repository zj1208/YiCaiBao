//
//  VisitorViewController.m
//  YiShangbao
//
//  Created by simon on 17/2/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "VisitorViewController.h"
#import "ZXTitleView.h"
#import "VisitorTableViewCell.h"
#import "ZXEmptyViewController.h"
#import "BuyerInfoController.h"

#import "JLCycleScrollerView.h"
#import "InfiniteAdvTableCell.h"
#import "MessageModel.h"
#import "ZXInfiniteScrollView.h"
#import "ZXPhotoBrowser.h"

static NSString *const reuse_infiniteScrollView = @"infiniteScrollView";


@interface VisitorViewController ()<ZXEmptyViewControllerDelegate,JLCycleScrollerViewDatasource,JLCycleScrollerViewDelegate,ZXPhotoBrowserDataSource>

@property (nonatomic,strong)NSMutableArray *dataMArray;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong)NSNumber *totalCount;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) NSMutableArray *infiniteDataMArray;

@end



@implementation VisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    // Uncomment the following line to preserve selection between presentations.
    [self setData];
}


- (void)setUI
{
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate =self;
    self.emptyViewController = emptyVC;
    
    UINib *nib =[UINib nibWithNibName:NSStringFromClass([InfiniteAdvTableCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuse_infiniteScrollView];
}


- (void)setData{
    
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData:) name:Noti_update_VisitorViewController object:nil];
    
    self.infiniteDataMArray = [NSMutableArray array];
    
}

- (void)updateData:(id)noti
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc
{
    NSLog(@"jl_dealloc success");

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)requestAdv
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1016 success:^(id data) {
        
        AdvModel *model = (AdvModel *)data;
        [_infiniteDataMArray removeAllObjects];
        [model.advArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            advArrModel *advItemModel = (advArrModel *)obj;
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:advItemModel.pic];
            ZXADBannerModel *advModel = [[ZXADBannerModel alloc] initWithDesc:nil picString:picUrl.absoluteString url:advItemModel.url advId:advItemModel.iid];
            advModel.areaId = advItemModel.areaId;
            [_infiniteDataMArray addObject:advModel];
            [weakSelf.tableView reloadData];
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)headerRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestAdv];

        [weakSelf requestHeaderData];
    }];
}

- (void)requestHeaderData
{
    WS(weakSelf);
    [ProductMdoleAPI getShopVisitorsListWithShopId:weakSelf.shopId pageNo:1 pageSize:@(20) success:^(NSNumber *todayAdd, id data, PageModel *pageModel) {
        
        weakSelf.totalCount = pageModel.totalCount;
        
        [weakSelf.dataMArray removeAllObjects];
        [weakSelf.dataMArray addObjectsFromArray:data];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count error:nil emptyImage:[UIImage imageNamed:@"访客"] emptyTitle:@"什么人都没有啊！\n上传产品能够吸引更多采购商" updateBtnHide:YES];
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

- (void)zxEmptyViewUpdateAction
{
    [self.tableView.mj_header beginRefreshing];
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
    [ProductMdoleAPI getShopVisitorsListWithShopId:weakSelf.shopId pageNo:weakSelf.pageNo+1 pageSize:@(20) success:^(NSNumber *todayAdd, id data, PageModel *pageModel) {
        
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
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section ==0)
    {
        return self.infiniteDataMArray.count>0?1:0;
    }
    return self.dataMArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==0)
    {
        InfiniteAdvTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_infiniteScrollView forIndexPath:indexPath];
        if (self.infiniteDataMArray.count>0)
        {
            cell.infiniteView.sourceArray = self.infiniteDataMArray;
            cell.infiniteView.datasource = self;
            cell.infiniteView.delegate = self;
        }
        return cell;
    }
    VisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.headBtn addTarget:self action:@selector(lookBigImageAction:) forControlEvents:UIControlEventTouchUpInside];

    // Configure the cell...
    if (self.dataMArray.count>0)
    {
        [cell setData:[self.dataMArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return LCDScale_iPhone6_Width(85);
    }
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0)
    {
        return 0.1;
    }
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (self.dataMArray.count>0 && section ==1)
    {
        ZXTitleView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] firstObject];
        NSString *string = [NSString stringWithFormat:@"共%@位采购商访问商铺",_totalCount];
        view.titleLab.text =string;
        view.titleLab.font = [UIFont systemFontOfSize:12];
        [view.leftImageView removeFromSuperview];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
    }
    return [[UIView alloc] init];
}



#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return  [self.tableView isRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1)
    {
        [self performSegueWithIdentifier:segue_BuyerInfoController sender:self];
        [MobClick event:kUM_b_b_visitorsview];
    }
}

- (void)lookBigImageAction:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.tableView zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:sender];
    ShopFansModel *model =[self.dataMArray objectAtIndex:indexPath.row];
    CGRect clipFrame =[sender convertRect:sender.bounds toView:self.view.window];
    //  过滤掉与navigationBar的重叠区域
    if (CGRectIntersectsRect(clipFrame, self.navigationController.navigationBar.frame))
    {
        CGRect intersect = CGRectIntersection(clipFrame, self.navigationController.navigationBar.frame);
        CGRect finallyRect = CGRectMake(clipFrame.origin.x, clipFrame.origin.y+intersect.size.height, clipFrame.size.width, clipFrame.size.height-intersect.size.height);
        clipFrame = finallyRect;
    }
    ZXPhotoBrowser *browser = [ZXPhotoBrowser photoBrowserWithCurrentImageIndex:0 imageCount:0 dataSource:self];
    [browser transitionWithTransitionImage:sender.currentImage beforeImageFrameInWindow:clipFrame];
    browser.userInfo = model.iconURL;
    [browser show];
}

- (NSURL *)zx_photoBrowser:(ZXPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return browser.userInfo;
}
# pragma  mark - 轮播点击，广告
//轮播图代理
-(id)jl_cycleScrollerView:(JLCycleScrollerView *)view defaultCell:(JLCycScrollDefaultCell *)cell cellForItemAtIndex:(NSInteger)index sourceArray:(nonnull NSArray *)sourceArray
{
    ZXADBannerModel* model = sourceArray[index];
    return model.pic;
}


-(void)jl_cycleScrollerView:(JLCycleScrollerView *)view didSelectItemAtIndex:(NSInteger)index sourceArray:(nonnull NSArray *)sourceArray
{
    ZXADBannerModel* model = sourceArray[index];
    [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.advId]];
    [MobClick event:kUM_b_home_banner];
    [[WYUtility dataUtil]routerWithName:model.url withSoureController:self];
}

#pragma mark － 后台广告点击统计
-(void)requestClickAdvWithAreaId:(NSNumber*)areaId advId:(NSString*)advId
{
    [[[AppAPIHelper shareInstance] getMessageAPI] postAddTrackInfoWithAreaId:areaId advId:advId success:^(id data) {
        
    } failure:^(NSError *error) {
        
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *viewController= segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ShopVisitorsModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    NSString *bizId = model.userId;
    if ([segue.identifier isEqualToString:segue_BuyerInfoController])
    {
        [viewController setValue:bizId forKey:@"bizId"];
        [viewController setValue:@(WYBOOLChat_YES) forKey:@"boolChat"];
        [viewController setValue:@(AddOnlineCustomerSourceType_Visitor) forKey:@"sourceType"];

    }
}



@end
