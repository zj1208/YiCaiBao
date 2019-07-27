//
//  CountryCodeViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CountryCodeViewController.h"
#import "ZYPinYinSearch.h"

@interface CountryCodeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *sortCountry;
}

@property (nonatomic,strong) UITableView *mainTable;
@property (assign, nonatomic) BOOL isSearch;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *searchData;

@property(nonatomic, strong)NSMutableArray *dataAllCountry;
@end

@implementation CountryCodeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择国家";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self creatUI];
    [self initData];
}


#pragma mark - private function
-(void)creatUI{
    self.mainTable.sectionIndexBackgroundColor = [UIColor clearColor];
    self.searchData = [NSMutableArray new];
    //设置搜索框
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入国家名称或首字母查询";
    self.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40 -64)];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.tableFooterView = [UIView new];
    
    self.mainTable.alwaysBounceVertical = YES;//当数据不足，也能滑动
    self.mainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;//收缩键盘
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.mainTable];
}


-(void)initData{
    //初始化
    _dataAllCountry = [NSMutableArray new];
    sortCountry = [NSMutableArray new];
    [[[AppAPIHelper shareInstance] getUserModelAPI] getCountryCodesWithSuccess:^(id data) {
        _dataAllCountry = data;
        for (char alpha = 'A'; alpha <= 'Z'; ++alpha) {
            NSMutableArray *temp = [NSMutableArray new];
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            for (NSMutableDictionary *dic in _dataAllCountry) {
                if ([[dic objectForKey:@"alpha"] isEqualToString:[NSString stringWithFormat:@"%c", alpha]]) {
                    [temp addObject:dic];
                }
            }
            if (temp.count) {
                [tempDic setObject:[NSString stringWithFormat:@"%c", alpha] forKey:@"title"];
                [tempDic setObject:temp forKey:@"country"];
                [sortCountry addObject:tempDic];
            }
        }
        
        [self.mainTable reloadData];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

-(void)returnVC{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.searchData removeAllObjects];
    NSArray *ary  = [ZYPinYinSearch searchWithOriginalArray:_dataAllCountry andSearchText:searchText andSearchByPropertyName:@"name"];
    NSLog(@"搜索词汇%@\n数组:%@",searchText,ary);

    if (searchText.length == 0) {
        [self.searchData addObjectsFromArray:_dataAllCountry];
        _isSearch = NO;
    }else {
        [self.searchData addObjectsFromArray:ary];
        _isSearch = YES;
    }
    [self.mainTable reloadData];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    _searchBar.showsCancelButton = YES;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    _isSearch = NO;
    [_mainTable reloadData];
}




#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!_isSearch) {
        return sortCountry.count + 1;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_isSearch) {
        if (section == 0) {
            return 1;
        }else{
            NSDictionary *dic = sortCountry[section - 1];
            NSArray *country = [dic objectForKey:@"country"];
            return country.count;
        }
    }else {
        return self.searchData.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isSearch) {
        if (indexPath.section == 0) {
            return 44;
        }else{
            return 44;
        }
    }else{
        return 44;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    if (!_isSearch) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            UITableViewCell *newCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"new"];
            newCell.textLabel.text = @"中国";
            newCell.detailTextLabel.text = @"+86";
            return newCell;
        }else{
            NSDictionary *dic = sortCountry[indexPath.section - 1];
            cell.textLabel.text = dic[@"country"][indexPath.row][@"name"];
            cell.detailTextLabel.text = dic[@"country"][indexPath.row][@"code"];
        }
    }else{
        cell.textLabel.text = self.searchData[indexPath.row][@"name"];
        cell.detailTextLabel.text = self.searchData[indexPath.row][@"code"];

    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cityName =nil;
    if (!_isSearch) {
        if (indexPath.section !=0) {
            NSDictionary *dic = sortCountry[indexPath.section - 1];
            cityName = dic[@"country"][indexPath.row][@"code"];
        }else{
            cityName = @"+86";
        }
    }else{
        cityName = self.searchData[indexPath.row][@"code"];
    }
    self.selectCity(cityName);
    
    [self returnVC];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (!_isSearch) {
        if (section == 0) {
            return @"常用国家";
        }else{
            return sortCountry[section - 1][@"title"];
        }
    }else {
        return nil;
    }
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (!_isSearch) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dic in sortCountry) {
            [arr addObject:dic[@"title"]];
        }
        return arr;
    }else {
        return nil;
    }
}
#pragma mark 索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    //点击索引，列表跳转到对应索引的行
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index+1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self showMessage:title toView:self.view];
    return index+1;
}

#pragma mark 显示一些信息
- (void)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:0.7];
}


@end
