//
//  FansViewController.m
//  YiShangbao
//
//  Created by simon on 17/2/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "FansViewController.h"
#import "CommonTradePersonalCell.h"
#import "ZXTitleView.h"
#import "ProductMdoleAPI.h"
#import "ZXEmptyViewController.h"
#import "BuyerInfoController.h"

#import "JLCycleScrollerView.h"
#import "InfiniteAdvTableCell.h"
#import "MessageModel.h"
#import "ZXInfiniteScrollView.h"
#import "ZXPhotoBrowser.h"

static NSString *const reuse_infiniteScrollView = @"infiniteScrollView";



@interface FansViewController ()<ZXEmptyViewControllerDelegate,JLCycleScrollerViewDatasource,JLCycleScrollerViewDelegate,ZXPhotoBrowserDataSource>

@property (nonatomic,strong)NSMutableArray *dataMArray;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong)NSNumber *todayAddCount;
@property (nonatomic, strong)NSNumber *totalCount;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) NSMutableArray *infiniteDataMArray;

@end


@implementation FansViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    [self setUI];
    [self setData];
    
}

- (void)setUI
{
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
 
    [self.tableView registerNib:[UINib nibWithNibName:Xib_CommonTradePersonalCell bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
    
    UINib *nib =[UINib nibWithNibName:NSStringFromClass([InfiniteAdvTableCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuse_infiniteScrollView];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    NSLog(@"%f",self.topLayoutGuide.length);

}
- (void)updateData:(id)noti
{
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)dealloc
{
    NSLog(@"jl_dealloc success");

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setData{
    
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
    [self.tableView.mj_header beginRefreshing];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData:) name:Noti_update_FansController object:nil];;
    
    self.infiniteDataMArray = [NSMutableArray array];

}

- (void)requestAdv
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1015 success:^(id data) {
        
        AdvModel *model = (AdvModel *)data;
        [weakSelf.infiniteDataMArray removeAllObjects];
        [model.advArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            advArrModel *advItemModel = (advArrModel *)obj;
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:advItemModel.pic];
            ZXADBannerModel *advModel = [[ZXADBannerModel alloc] initWithDesc:nil picString:picUrl.absoluteString url:advItemModel.url advId:advItemModel.iid];
            advModel.areaId = advItemModel.areaId;
            [weakSelf.infiniteDataMArray addObject:advModel];
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
    [ProductMdoleAPI getShopFansListWithShopId:weakSelf.shopId pageNo:1 pageSize:@(20) success:^(NSNumber *todayAdd, id data, PageModel *pageModel) {
        
        weakSelf.todayAddCount = todayAdd;
        weakSelf.totalCount = pageModel.totalCount;
        
        [weakSelf.dataMArray removeAllObjects];
        [weakSelf.dataMArray addObjectsFromArray:data];
        
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count error:nil emptyImage:[UIImage imageNamed:@"粉丝"] emptyTitle:@"粉丝多了以后好处可多了！\n 你可以拿给别人炫耀有这么多粉丝啊，\n去分享你的名片让别人关注即可成为你的粉丝" updateBtnHide:YES];
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
    [ProductMdoleAPI getShopFansListWithShopId:weakSelf.shopId pageNo:weakSelf.pageNo+1 pageSize:@(20) success:^(NSNumber *todayAdd, id data, PageModel *pageModel) {
        
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return self.dataMArray.count==0? 0:1;
//}
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
    CommonTradePersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        NSString *string = [NSString stringWithFormat:@"今日新增%@位粉丝，共%@位粉丝关注商铺!",_todayAddCount,_totalCount];
        view.titleLab.text =string;
        view.titleLab.font = [UIFont systemFontOfSize:12];
        [view.leftImageView removeFromSuperview];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
    }
    return [[UIView alloc] init];
}



//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([view isKindOfClass:[UITableViewHeaderFooterView class]])
//    {
//        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
//        headerView.textLabel.textAlignment = NSTextAlignmentCenter;
//    }
//}
#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return  [self.tableView isRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (indexPath.section ==1)
      {
          [MobClick event:kUM_b_fansview];
          
          [self performSegueWithIdentifier:segue_BuyerInfoController sender:nil];
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
    ShopFansModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    NSString *bizId = model.userId;

    if ([segue.identifier isEqualToString:segue_BuyerInfoController])
    {
        [viewController setValue:bizId forKey:@"bizId"];
        [viewController setValue:@(WYBOOLChat_YES) forKey:@"boolChat"];
        [viewController setValue:@(AddOnlineCustomerSourceType_Fans) forKey:@"sourceType"];
    }
}



@end
