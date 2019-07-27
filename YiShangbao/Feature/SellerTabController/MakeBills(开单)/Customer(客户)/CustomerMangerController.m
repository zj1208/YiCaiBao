//
//  CustomerMangerController.m
//  YiShangbao
//
//  Created by simon on 2018/1/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "CustomerMangerController.h"
#import "SMCustomerCell.h"
#import "CusAddBookController.h"
#import "SMAddSelView.h"
#import "CusNowAddController.h"
#import "SMCCLookViewController.h"

#import "MakeBillsTabController.h"
@interface CustomerMangerController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray *customerArrayData;
@property(nonatomic,strong)NSMutableArray *indexTitleArrayM;
@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@property(nonatomic,weak)SMAddSelView *addSelView;
@property(nonatomic)BOOL dataIsEnough;
@end
static NSString *cellReuse_SMCustomerCell = @"SMCustomerCell";
@implementation CustomerMangerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title = self.isSelectCustomer?@"请选择客户":@"客户";
    self.navigationItem.title = title;
    self.customerArrayData = [NSMutableArray array];
    
    [self buildUI];
    
}
- (void)dealloc
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    [self requestQueryContactsData:self.textFild.text];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_addSelView&&_addSelView.superview) { //when router push
        [_addSelView removeFromSuperview];
    }
}
-(void)requestQueryContactsData:(NSString *)keyword
{
    [MobClick event:kUM_kdb_customer_search];

    NSString *contacts  = [keyword isEqualToString:@""]?nil:keyword;
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getkBillQueryContacts:contacts pageNum:0 pageSize:0 Success:^(id data, PageModel *pageModel) {
        self.customerArrayData = [NSMutableArray arrayWithArray:data];
        [self initIndexTitleArrayM];
        [self.tableView reloadData];

        if (contacts) {
            self.emptyViewController.view.frame = CGRectMake(0, 45+HEIGHT_NAVBAR, LCDW, LCDH-45-HEIGHT_NAVBAR);
            [self.emptyViewController addEmptyViewInController:self hasLocalData:self.customerArrayData.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"开单氛围图"] emptyTitle:@"暂无相关客户信息" updateBtnHide:YES];
        }else{
            [self.emptyViewController addEmptyViewInController:self hasLocalData:self.customerArrayData.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"开单氛围图"] emptyTitle:@"您还没有客户，快去添加客户吧~" updateBtnHide:YES];
        }
    } failure:^(NSError *error) {
        [self.emptyViewController addEmptyViewInController:self hasLocalData:self.customerArrayData.count error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
-(void)initIndexTitleArrayM
{
    self.indexTitleArrayM = [NSMutableArray array];
    for (int i=0; i<_customerArrayData.count; ++i) {
        SMCustomerModel *model = _customerArrayData[i];
        [_indexTitleArrayM addObject:model.group];
    }
}
-(ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        ZXEmptyViewController *emptyViewController = [[ZXEmptyViewController alloc] init];
        emptyViewController.contentOffest = CGSizeMake(0, 34);
        emptyViewController.view.frame = self.view.bounds;
        _emptyViewController = emptyViewController;
        _emptyViewController.delegate = self;
    }return _emptyViewController;
}
- (void)zxEmptyViewUpdateAction
{
    [self requestQueryContactsData:self.textFild.text];
}
-(void)buildUI
{
    UIButton *AddBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [AddBtn setTitle:@"添加" forState:UIControlStateNormal];
    AddBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [AddBtn setTitleColor:[WYUISTYLE colorWithHexString:@"#FF5434"] forState:UIControlStateNormal];
    [AddBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:AddBtn];
  
    UIImageView *IMV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78/2.3, 64/2.3)];
    IMV.image = [UIImage imageNamed:@"ic_search"];
    self.textFild.leftView = IMV;
    self.textFild.leftViewMode = UITextFieldViewModeAlways;
    self.textFild.layer.masksToBounds = YES;
    self.textFild.layer.cornerRadius = 16;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];//0.1去除最后一个cell分割线
    self.tableView.rowHeight = 65.f;
    self.tableView.sectionIndexColor = [WYUISTYLE colorWithHexString:@"#FF5434"]; //修改右边索引字体的颜色
    [self.tableView registerNib:[UINib nibWithNibName:@"SMCustomerCell" bundle:nil] forCellReuseIdentifier:cellReuse_SMCustomerCell];
}
#pragma make - 新增客户
-(void)clickAddBtn:(UIButton*)sender
{
    sender.enabled = NO;
    MakeBillsTabController *TabC = (MakeBillsTabController *)self.tabBarController;
    if (_isSelectCustomer) {
        [TabC checkOpenBillTimeIsExpireView:OBShowType_none checkService:OBServiceType_customer succes:^(CheckBlockType isOk) {
            sender.enabled = YES;
            if (isOk == CheckBlockType_oK)
            {
                [self showSMAddSelView];
            }
            else if (isOk == CheckBlockType_disable)
            {
                [MBProgressHUD zx_showError:@"服务已到期，请购买后使用" toView:self.view];
            }
        }];
    }else{
        [TabC checkOpenBillTimeIsExpireView:OBShowType_renewal checkService:OBServiceType_customer succes:^(CheckBlockType isOk) {
            sender.enabled = YES;
            if (isOk == CheckBlockType_oK)
            {
                [self showSMAddSelView];
            }
        }];
    }
}
-(void)showSMAddSelView
{
    if (self.tabBarController.selectedIndex!=2 && self.navigationController.topViewController != self) {
        return;
    }
    SMAddSelView *view = [[SMAddSelView alloc] initWithXib];
    view.frame = self.tabBarController.view.bounds;
    self.addSelView = view;
    [self.addSelView showSuperview:self.tabBarController.view animated:YES];
    
    self.addSelView.clickBlock = ^(NSInteger index) {
        if (index == 0) {
            [MobClick event:kUM_kdb_customer_create_add];
            CusNowAddController *VC = [[CusNowAddController alloc] init];
            VC.type = CusNowAdd_add;
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            [MobClick event:kUM_kdb_customer_create_contacts];
            CusAddBookController *VC = [[CusAddBookController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self requestQueryContactsData:nil];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFild resignFirstResponder];
    [self requestQueryContactsData:self.textFild.text];
    return YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.customerArrayData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SMCustomerModel *model = _customerArrayData[section];
    return model.list.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SMCustomerModel *model = _customerArrayData[section];
    return model.group;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor= [WYUISTYLE colorWithHexString:@"EEEEEE"];
    header.textLabel.font = [UIFont systemFontOfSize:15];
    [header.textLabel setTextColor:[WYUISTYLE colorWithHexString:@"2f2f2f2"]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_SMCustomerCell forIndexPath:indexPath];
    cell.companyLeading.constant = self.isSelectCustomer?45.f:15.f;
    cell.iconBtn.hidden = !self.isSelectCustomer;
    SMCustomerModel *model = _customerArrayData[indexPath.section];
    SMCustomerSubModel *subModel = model.list[indexPath.row];
    [cell setData:subModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSInteger index = 0;
    for (SMCustomerModel *model in _customerArrayData) {
        index +=model.list.count;
    }
    if (tableView.indexPathsForVisibleRows.count>=index) {//数据不足不展示,visibleCells在iOS8读取为nil
        return nil;
    }
    return _indexTitleArrayM;
}
#pragma mark 索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [MBProgressHUD zx_showSuccess:title toView:self.view];
    return index;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelectCustomer) {
        if (self.didClcikBlock) {
            SMCustomerModel *model = _customerArrayData[indexPath.section];
            SMCustomerSubModel *subModel = model.list[indexPath.row];
            self.didClcikBlock(subModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{

        SMCCLookViewController *VC = [[SMCCLookViewController alloc] init];
        SMCustomerModel *model = _customerArrayData[indexPath.section];
        SMCustomerSubModel *subModel = model.list[indexPath.row];
        VC.contactId = [NSString stringWithFormat:@"%@",subModel.iid];

        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];

        
//        CusNowAddController *VC = [[CusNowAddController alloc] init];
//        VC.hidesBottomBarWhenPushed = YES;
//        VC.type = CusNowAdd_look;
//        SMCustomerModel *model = _customerArrayData[indexPath.section];
//        SMCustomerSubModel *subModel = model.list[indexPath.row];
//        VC.contactId = [NSString stringWithFormat:@"%@",subModel.iid];
//        [self.navigationController pushViewController:VC animated:YES];
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
    if ([self.navigationController.childViewControllers.firstObject isEqual:self]) {
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
