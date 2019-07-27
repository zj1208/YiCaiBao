//
//  WYTradeEvaluateViewController.m
//  YiShangbao
//
//  Created by light on 2018/3/19.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYTradeEvaluateViewController.h"

#import "WYEvaluateTradeTableViewCell.h"
#import "WYEvaluateBuyerTableViewCell.h"
#import "WYEvaluateHeaderView.h"

@interface WYTradeEvaluateViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) MyEvaluateModel *model;
@property (nonatomic, strong) NSString *tags;

@property (nonatomic, weak) WYEvaluateTradeTableViewCell *evaluateTradeCell;
@property (nonatomic, weak) WYEvaluateBuyerTableViewCell *evaluateBuyerCell;

@end

@implementation WYTradeEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评价生意";
    
    [self setUI];
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonAction:(id)sender {
    
    self.tags = [self.evaluateTradeCell.selectedArray componentsJoinedByString:@","];
    [self requestSubmit];
}

#pragma mark- Request

-(void)requestData{
    WS(weakSelf)
    if (!self.postId) {
        return;
    }
    [[[AppAPIHelper shareInstance] getTradeMainAPI] getTradeInitEvaluateInfoWithIdentityType:@4 tradeId:self.postId success:^(id data) {
        weakSelf.model = data;
        weakSelf.tags = @"";
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)requestSubmit{
    if (!self.postId) {
        return;
    }
    if (!self.tags.length) {
        [MBProgressHUD zx_showSuccess:@"请选择标签" toView:self.view];
        return;
    }
    NSString *evaluateBuyer = [NSString stringWithFormat:@"%@,%@,%@",self.model.buyer.buyerId,self.evaluateBuyerCell.score,self.evaluateBuyerCell.evaluateString?self.evaluateBuyerCell.evaluateString:@""];
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getTradeMainAPI] postTradeCommentWithPostId:self.postId content:self.evaluateTradeCell.evaluateString starNum:self.evaluateTradeCell.score tag:self.tags identityType:@4 evaluate:evaluateBuyer success:^(id data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Trade_evaluating object:nil userInfo:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD zx_showSuccess:@"评价成功" toView:nil];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40.0;
    }
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0;
    }
    return 0.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        WYEvaluateHeaderView *view = (WYEvaluateHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:WYEvaluateHeaderViewID];
        return view;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        WYEvaluateTradeTableViewCell *cell = (WYEvaluateTradeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:WYEvaluateTradeTableViewCellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell updateData:self.model];
        cell.heightChangeBlock = ^(CGFloat height) {
            [tableView reloadData];
        };
        self.evaluateTradeCell = cell;
        return cell;
    }else{
        WYEvaluateBuyerTableViewCell *cell = (WYEvaluateBuyerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:WYEvaluateBuyerTableViewCellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell updateData:self.model];
        self.evaluateBuyerCell = cell;
        return cell;
    }
}

#pragma mark- UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0){
//        WYEvaluateTradeTableViewCell *cell = (WYEvaluateTradeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:WYEvaluateTradeTableViewCellID];
//        cell.heightChangeBlock = ^(CGFloat height) {
//            [tableView setNeedsUpdateConstraints];
//            [tableView needsUpdateConstraints];
////            return height;
//        };
//        return 170.0;
//    }
//    return 170.0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- Private
- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 170.0;
    
    [_tableView registerClass:[WYEvaluateHeaderView class] forHeaderFooterViewReuseIdentifier:WYEvaluateHeaderViewID];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30 , 45);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
    [self.submitButton.layer insertSublayer:gradientLayer atIndex:0];
    self.submitButton.layer.cornerRadius = 22;
    self.submitButton.layer.masksToBounds = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
