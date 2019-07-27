//
//  SaleAmountChartController.m
//  YiShangbao
//
//  Created by simon on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SaleAmountChartController.h"
#import "ZXEmptyViewController.h"
#import "SaleAmountCell.h"
#import "SaleAmountgraphChartCell.h"
#import "NoChartDataCommonCell.h"
#import "YXTDatePicker.h"

@interface SaleAmountChartController ()<UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate,HooDatePickerDelegate>


@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) BillDataSaleAmountModel *billDataSaleAmountModel;

@property (nonatomic, strong) YXTDatePicker *datePicker;

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;

@end

@implementation SaleAmountChartController

static NSString *const cellReuse_saleAmountCell = @"SaleAmountCell";
static NSString *const cellReuse_chartCell = @"ChartCell";
static NSString *const cellReuse_noChartData = @"NoDataCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"销售额统计";
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
    
    

    YXTDatePicker *picker = [[YXTDatePicker alloc] initDatePickerMode:HooDatePickerModeYearAndMonth andAddToSuperView:self.view];
    picker.delegate = self;
    self.datePicker = picker;
}


- (void)setData
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy年MM月";
    NSString *dateString = [format stringFromDate:[NSDate date]];
    self.dateLab.text = dateString;
    self.year = [dateString substringToIndex:4];
    self.month = [dateString substringWithRange:NSMakeRange(5, 2)];
    
    [self headerRefresh];
    [self.tableView.mj_header beginRefreshing];
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
    [[[AppAPIHelper shareInstance]getMakeBillAPI]getBillDataWithGetSaleAmountWithYear:_year month:_month success:^(id data) {
        
        weakSelf.billDataSaleAmountModel = nil;
        weakSelf.billDataSaleAmountModel = [[BillDataSaleAmountModel alloc] init];
        if (data)
        {
            weakSelf.billDataSaleAmountModel = data;
        }
        [weakSelf.emptyViewController hideEmptyViewInController:weakSelf hasLocalData:weakSelf.billDataSaleAmountModel];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.billDataSaleAmountModel error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.billDataSaleAmountModel)
    {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.billDataSaleAmountModel.saleAmount.count>0 &&section==1)
    {
        return self.billDataSaleAmountModel.saleAmount.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SaleAmountgraphChartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_chartCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:self.billDataSaleAmountModel];
        return cell;
    }
    if (self.billDataSaleAmountModel.saleAmount.count ==0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoDataCell" forIndexPath:indexPath];
//        cell.backgroundColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    SaleAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_saleAmountCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array = self.billDataSaleAmountModel.saleAmount;
    NSArray *array1 = [array reverseObjectEnumerator].allObjects;
    [cell setData:[array1 objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return 250.f;
    }
    if (self.billDataSaleAmountModel.saleAmount.count ==0)
    {
        return LCDScale_5Equal6_To6plus(60.f);
    }
    return LCDScale_iPhone6_Width(49);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return LCDScale_iPhone6_Width(10);
    }
    return LCDScale_iPhone6_Width(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return LCDScale_iPhone6_Width(10);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)datePicker:(YXTDatePicker *)dataPicker didSelectedDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy年MM月";
    NSString *dateString = [format stringFromDate:date];
    _year = [dateString substringToIndex:4];
    _month = [dateString substringWithRange:NSMakeRange(5, 2)];
    _dateLab.text = dateString;
    [_tableView.mj_header beginRefreshing];
    
}
- (IBAction)choseDateButtonAction:(id)sender {
    
    [self.datePicker show];

}
@end

