//
//  SaleGoodsChartController.m
//  YiShangbao
//
//  Created by simon on 2018/1/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SaleGoodsChartController.h"
#import "SaleGoodgraphChartCell.h"
#import "SaleGoodsCell.h"
#import "ZXEmptyViewController.h"
#import "NoChartDataCommonCell.h"
#import "ZXDatePickerView.h"
#import "YXTDatePicker.h"

@interface SaleGoodsChartController ()<UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate,HooDatePickerDelegate>


@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) BillDataSaleGoodsModel *billDataSaleGoodsModel;

@property (nonatomic, strong) YXTDatePicker *datePicker;
//@property (nonatomic, strong) ZXDatePickerView *datePicker;

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;

@end

@implementation SaleGoodsChartController

static NSString *const cellReuse_prouductCell = @"ProductCell";
static NSString *const cellReuse_chartCell = @"ChartCell";
static NSString *const cellReuse_noChartData = @"NoChartCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title =NSLocalizedString(@"商品销量排行榜", nil);

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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoChartDataCommonCell class]) bundle:nil] forCellReuseIdentifier:cellReuse_noChartData];
    
//    ZXDatePickerView *picker = [[ZXDatePickerView alloc] init];
//    picker.toolBarTintColor = UIColorFromRGB_HexValue(0x45A4E8);
//    picker.toolBarTitleBarItemTitle = @"选择日期";
//    picker.returnDateFormat = @"yyyy年MM月";
//    self.datePicker = picker;

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
    [[[AppAPIHelper shareInstance]getMakeBillAPI]getBillDataWithGetSaleGoodsYear:self.year month:self.month success:^(id data) {
        
        weakSelf.billDataSaleGoodsModel = nil;
        weakSelf.billDataSaleGoodsModel = [[BillDataSaleGoodsModel alloc] init];
        if (data)
        {
            weakSelf.billDataSaleGoodsModel = data;
        }
        [weakSelf.emptyViewController hideEmptyViewInController:weakSelf hasLocalData:weakSelf.billDataSaleGoodsModel?YES:NO];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.billDataSaleGoodsModel?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.billDataSaleGoodsModel)
    {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0)
    {
        return 1;
    }
    return self.billDataSaleGoodsModel.saleGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (self.billDataSaleGoodsModel.saleGoods.count ==0)
        {
            NoChartDataCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_noChartData forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        SaleGoodgraphChartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_chartCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:self.billDataSaleGoodsModel.saleGoodgraph];
        return cell;
    }
    SaleGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_prouductCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:[self.billDataSaleGoodsModel.saleGoods objectAtIndex:indexPath.row] withIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return self.billDataSaleGoodsModel.saleGoodgraph.count>0?215:301;
    }
    return 67.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return 10.f;
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
- (IBAction)choseDateButtonAction:(id)sender
{
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    format.dateFormat = @"yyyy年MM月";
//    NSDate *date = [format dateFromString:@"2018年2月"];
//    [self.datePicker setDate:date animated:YES];
//    [self.datePicker showInView:self.view cancleHander:^(void){
//
//
//    } doneHander:^(NSDate * _Nonnull date, NSString * _Nonnull dateString) {
//
//        _year = [dateString substringToIndex:4];
//        _month = [dateString substringWithRange:NSMakeRange(5, 2)];
//        _dateLab.text = dateString;
//    }];
    [self.datePicker show];
}
@end
