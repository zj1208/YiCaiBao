//
//  WYShareLinkmanViewController.m
//  YiShangbao
//
//  Created by light on 2018/4/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYShareLinkmanViewController.h"
#import "ShareLinkmanTableViewCell.h"
#import "ShareEmptyTableViewCell.h"
#import "ShareLinkmanHeaderView.h"
#import "WYPublicModel.h"

#import "LinkmanAlertViewController.h"
#import "IQKeyboardManager.h"

@interface WYShareLinkmanViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) WYShareLinkmanListModel *model;
@property (nonatomic, strong) NSMutableArray *selectedList;

@property (nonatomic, strong) LinkmanAlertViewController *alertVC;

//分享内容
@property (nonatomic) id imageStr;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;

@end

@implementation WYShareLinkmanViewController

#pragma mark ------LifeCircle------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择联系人";
    [self setUI];
    [self requestData];
    self.selectedList = [NSMutableArray array];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)shareWithImage:(id)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url{
    self.imageStr = imageStr;
    self.shareTitle = title;
    self.content = content;
    self.url = url;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------Request------

-(void)requestData{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] userModelExtendAPI] getShareLinkmanListSuccess:^(id data) {
        weakSelf.model = data;
        [weakSelf.tableView reloadData];
        if (weakSelf.model.imList.count > 0 || weakSelf.model.fansList.count > 0 || weakSelf.model.visitorsList.count > 0) {
            weakSelf.submitButton.hidden = NO;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}

#pragma  mark ------ButtonAction------
- (void)submit{
    if (self.selectedList.count == 0) {
        [MBProgressHUD zx_showError:@"您还没有选择联系人噢～" toView:nil];
        return;
    }
    WS(weakSelf)
    [self.alertVC shareToUsers:self.selectedList image:self.imageStr Title:self.shareTitle Content:self.content withUrl:self.url];
    self.alertVC.sendSuccessBlock = ^{
        [weakSelf.alertVC close];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.alertVC showIn:self];
}

#pragma mark ------UITableviewDatasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller){
        return 3;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.model.imList.count > 0){
        return self.model.imList.count;
    }else if (section == 1 && self.model.fansList.count > 0){
        return self.model.fansList.count;
    }else if (section == 2 && self.model.visitorsList.count > 0){
        return self.model.visitorsList.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 39.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ShareLinkmanHeaderView *view = (ShareLinkmanHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ShareLinkmanHeaderViewID];
    if (section == 0){
        view.titleLabel.text = [NSString stringWithFormat:@"最近%ld天内联系过的人",self.model.imDay.integerValue];
    }else if (section == 1){
        view.titleLabel.text = [NSString stringWithFormat:@"最近%ld天内关注我商铺的人",self.model.fansDay.integerValue];
    }else if (section == 2){
        view.titleLabel.text = [NSString stringWithFormat:@"最近%ld天内访问过我商铺的人",self.model.visitorsDay.integerValue];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && self.model.imList.count > 0){
        ShareLinkmanTableViewCell *cell = (ShareLinkmanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ShareLinkmanTableViewCellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell updateData:self.model.imList[indexPath.row]];
        return cell;
    }else if (indexPath.section == 1 && self.model.fansList.count > 0){
        ShareLinkmanTableViewCell *cell = (ShareLinkmanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ShareLinkmanTableViewCellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell updateData:self.model.fansList[indexPath.row]];
        return cell;
    }else if (indexPath.section == 2 && self.model.visitorsList.count > 0){
        ShareLinkmanTableViewCell *cell = (ShareLinkmanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ShareLinkmanTableViewCellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell updateData:self.model.visitorsList[indexPath.row]];
        return cell;
    }else {
        ShareEmptyTableViewCell *cell = (ShareEmptyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ShareEmptyTableViewCellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.section == 0 ){
            cell.emptyTipLabel.text = @"您最近没有联系过任何人噢~";
        }else if (indexPath.section == 1){
            cell.emptyTipLabel.text = @"最近都没有人关注您的商铺呢~";
        }else{
            cell.emptyTipLabel.text = @"最近都没有人访问过您的商铺呢~";
        }
        return cell;
    }
}

#pragma mark ------UITableViewDelegate------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && self.model.imList.count > 0){
        return 50.0;
    }else if (indexPath.section == 1 && self.model.fansList.count > 0){
        return 50.0;
    }else if (indexPath.section == 2 && self.model.visitorsList.count > 0){
        return 50.0;
    }
    return 200.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ShareLinkmanTableViewCell class]]){
        ShareLinkmanTableViewCell *linkmanCell = (ShareLinkmanTableViewCell *)cell;
        WYShareLinkmanModel *model;
        if (indexPath.section == 0){
            model = self.model.imList[indexPath.row];
        }else if (indexPath.section == 1){
            model = self.model.fansList[indexPath.row];
        }else if (indexPath.section == 2){
            model = self.model.visitorsList[indexPath.row];
        }
        
        if (self.selectedList.count >= 9 && !model.isSelected){
            [MBProgressHUD zx_showError:@"只能选择9个噢～" toView:nil];
            return;
        }
        model.isSelected = !model.isSelected;
        [linkmanCell updateData:model];
        //选择后加到数组中
        if (model.isSelected) {
            [self.selectedList addObject:model];
        }else{
            NSArray * array = [NSArray arrayWithArray:self.selectedList];
            for (WYShareLinkmanModel *selectedModel in array) {
                if ([selectedModel.bizUid isEqualToString:model.bizUid]) {
                    [self.selectedList removeObject:selectedModel];
                }
            }
        }
        [self.submitButton setTitle:[NSString stringWithFormat:@"完成(%lu)",(unsigned long)self.selectedList.count] forState:UIControlStateNormal];
    }
}

#pragma mark ------Private------
- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 170.0;
    
    [_tableView registerClass:[ShareLinkmanHeaderView class] forHeaderFooterViewReuseIdentifier:ShareLinkmanHeaderViewID];
    [_tableView registerNib:[UINib nibWithNibName:@"ShareLinkmanTableViewCell" bundle:nil] forCellReuseIdentifier:ShareLinkmanTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"ShareEmptyTableViewCell" bundle:nil] forCellReuseIdentifier:ShareEmptyTableViewCellID];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [button setTitle:@"完成(0)" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0xFF5434] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.submitButton = button;
    self.submitButton.hidden = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark ------GetterAndSetter
- (LinkmanAlertViewController *)alertVC{
    if (!_alertVC) {
        _alertVC = [[LinkmanAlertViewController alloc]initWithNibName:@"LinkmanAlertViewController" bundle:nil];
    }
    return _alertVC;
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
