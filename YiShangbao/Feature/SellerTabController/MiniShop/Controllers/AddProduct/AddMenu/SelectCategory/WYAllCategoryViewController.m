//
//  WYAllCategoryViewController.m
//  YiShangbao
//
//  Created by light on 2017/10/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYAllCategoryViewController.h"
#import "AddressItem.h"
#import "WYButtonsScrollView.h"

NSString *const AllCategoryTableViewCellID = @"AllCategoryTableViewCellID";

@interface WYAllCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,WYButtonsScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WYButtonsScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selsectArray;
@property (nonatomic) NSInteger index;

@end

@implementation WYAllCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"请选择类目";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
    
    self.dataArray = [NSMutableArray array];
    self.selsectArray = [NSMutableArray array];
    self.index = 0;
    
    [self creatUI];
    [self categoryRequest];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -WYButtonsScrollViewDelegate
- (void)selectedButtonIndex:(NSInteger)index{
    if (index < self.dataArray.count) {
        self.index = index;
        [self.tableView reloadData];
    }
}

#pragma mark -Rrequest
- (void)categoryRequest{
    WS(weakSelf)
    NSNumber *cateId = nil;
    if (self.selsectArray.count > 0) {
        AddressItem *item = self.selsectArray[self.index - 1];
        cateId = item.cateId;
    }
    
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    [ProductMdoleAPI getProductSystemCatesWithCateId:cateId levelId:@(self.index + 2) success:^(id data) {
        NSArray *array = data;
        if (array.count == 0) {
            [self returnCategoryString];
        }
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        [weakSelf.dataArray addObject:data];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        weakSelf.index --;
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count > 0) {
        NSArray *array = self.dataArray[self.index];
        return array.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AllCategoryTableViewCellID forIndexPath:indexPath];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllCategoryTableViewCellID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    NSArray *array = self.dataArray[self.index];
    AddressItem *item = array[indexPath.row];
    cell.textLabel.text = item.name;
    AddressItem *selectedItem;
    //判断选中
    if (self.selsectArray.count > self.index) {
        selectedItem = self.selsectArray[self.index];
    }
    if ([selectedItem.name isEqualToString:item.name]) {
        cell.textLabel.textColor = [UIColor colorWithHex:0xFF5434];
    }else{
        cell.textLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = self.dataArray[self.index];
//重新选择上一个目录时，删除
    for (unsigned long i = self.selsectArray.count; i > 0; i--) {
        if (i - 1 >= self.index) {
            [self.selsectArray removeObject:self.selsectArray[i - 1]];
        }
    }
    for (unsigned long  i = self.dataArray.count; i > 0; i--) {
        if (i - 1 > self.index) {
            [self.dataArray removeObject:self.dataArray[i - 1]];
        }
    }
    
    [self.selsectArray addObject:array[indexPath.row]];
    self.index ++;
    [self categoryRequest];
    [self selectButton];
}

#pragma mark -Private
- (void)creatUI{
    self.scrollView = [[WYButtonsScrollView alloc]init];
    self.scrollView.delegateObj = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor colorWithHex:0xE1E2E3];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AllCategoryTableViewCellID];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(0.5f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)selectButton{
    NSMutableArray *array = [NSMutableArray array];
    for (AddressItem *item in self.selsectArray) {
        [array addObject:item.name];
    }
    [array addObject:@"请选择"];
    [self.scrollView buttonsWithArray:array];
    [self.scrollView selectButtonIndex:array.count - 1];
}

- (void)returnCategoryString{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedCategory:categoryId:)]) {
        NSMutableArray *timeArray = [NSMutableArray array];
        for (AddressItem *item in self.selsectArray) {
            [timeArray addObject:item.name];
        }
        NSString *string = [timeArray componentsJoinedByString:@"/"];
        AddressItem *item = self.selsectArray[self.selsectArray.count - 1];
        [self.delegate selectedCategory:string categoryId:item.cateId];
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

@end
