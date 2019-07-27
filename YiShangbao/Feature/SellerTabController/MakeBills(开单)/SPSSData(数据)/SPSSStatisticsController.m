//
//  SPSSStatisticsController.m
//  YiShangbao
//
//  Created by simon on 2018/1/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SPSSStatisticsController.h"
#import "SaleGoodgraphMainCell.h"
#import "SaleClientgraphMainCell.h"
#import "SaleAmountgraphMainCell.h"
#import "ZXEmptyViewController.h"
#import "NoChartDataCommonCell2.h"
#import "ZXTitleView.h"

//18223481929
// 13616899607

@interface SPSSStatisticsController ()<UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate>


@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) BillDataAllDataModel *billDataAllDataModel;

@end

@implementation SPSSStatisticsController

static NSString *const cellReuse_saleAmountgrapthCell = @"SaleAmountCell";
static NSString *const cellReuse_pieChartCell = @"PieChartCell";
static NSString *const cellReuse_pieSaleClientgraphChartCell = @"PieTurnoveChartCell";

static NSString *const cellReuse_noChartData = @"NoChartCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"数据", nil);

    [self setUI];
    [self setData];
}

- (void)setUI
{
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor = UIColorFromRGB_HexValue(0xE5E5E5);
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoChartDataCommonCell2 class]) bundle:nil] forCellReuseIdentifier:cellReuse_noChartData];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)setData
{
    [self headerRefresh];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zxEmptyViewUpdateAction) name:Noti_update_SPSSStatisticsController object:nil];
}

- (void)zxEmptyViewUpdateAction
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
    [[[AppAPIHelper shareInstance] getMakeBillAPI]getBillDataWithAllDataWithSuccess:^(id data) {
        
        weakSelf.billDataAllDataModel = nil;
        weakSelf.billDataAllDataModel = [[BillDataAllDataModel alloc] init];
        if (data)
        {
            weakSelf.billDataAllDataModel = data;
        }
        [weakSelf.emptyViewController hideEmptyViewInController:weakSelf hasLocalData:_billDataAllDataModel];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.billDataAllDataModel error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.billDataAllDataModel)
    {
        return 0;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1)
    {
        SaleAmountgraphMainCell *cell =[tableView dequeueReusableCellWithIdentifier:cellReuse_saleAmountgrapthCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:self.billDataAllDataModel];
        return cell;
    }
    if (indexPath.section ==2)
    {
        if (self.billDataAllDataModel.saleGoodgraph.count ==0)
        {
            NoChartDataCommonCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_noChartData forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        SaleGoodgraphMainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_pieChartCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.billDataAllDataModel.saleGoodgraph.count>0)
        {
            [cell setData:self.billDataAllDataModel.saleGoodgraph];
        }
        return cell;
    }
    else if (indexPath.section ==3)
    {
        if (self.billDataAllDataModel.saleClientgraph.count ==0)
        {
            NoChartDataCommonCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_noChartData forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        SaleClientgraphMainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_pieSaleClientgraphChartCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:self.billDataAllDataModel.saleClientgraph];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return 0.1;
    }
    else if (indexPath.section ==1)
    {
         return LCDScale_5Equal6_To6plus(210.f);
    }
    else if (indexPath.section ==2 || indexPath.section ==3)
    {
        return LCDScale_5Equal6_To6plus(178.f);
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return LCDScale_5Equal6_To6plus(35.f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return LCDScale_5Equal6_To6plus(10.f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section >0)
    {
        ZXActionAdditionalTitleView *titleView = [ZXActionAdditionalTitleView viewFromNib];
        titleView.accessoryImageView.hidden = YES;
        titleView.titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(16)];
        titleView.accessoryType = ZXActionViewAccessoryTypeNone;
        titleView.detailTitleLab.text = @"查看更多";
        titleView.detailTitleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(14)];
        titleView.detailTitleLab.textColor = UIColorFromRGB_HexValue(0xFF5434);
        [titleView.tapGestureRecognizer addTarget:self action:@selector(goMoreAction:)];
        titleView.tag = 200+section;
        if (section ==1)
        {
            titleView.titleLab.text =@"销售额统计";
        }
        else if (section ==2)
        {
            titleView.titleLab.text =@"商品销量排行榜";
        }
        else if (section ==3)
        {
            titleView.titleLab.text =@"客户成交额排行榜";
        }
        return titleView;
    }
    return [[UIView alloc] init];
}

- (void)goMoreAction:(UIGestureRecognizer *)sender
{
    switch (sender.view.tag-200)
    {
        case 1:
            [self performSegueWithIdentifier:segue_SaleAmountChartController sender:nil];
            [MobClick event:kUM_kdb_data_salemore];
            break;
        case 2:
            [self performSegueWithIdentifier:segue_SaleGoodsChartController sender:nil];
            [MobClick event:kUM_kdb_data_productmore];
            break;
        case 3:
            [self performSegueWithIdentifier:segue_SaleClientsViewController sender:nil];
            [MobClick event:kUM_kdb_data_customermore];
            break;
        default:
            break;
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

- (IBAction)dissmissControllerAction:(id)sender {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];

//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
