//
//  PurRefundReasonViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurRefundReasonViewController.h"

#import "RefundReasonTableViewCell.h"

@interface PurRefundReasonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UIView* alpbackView;

@property(nonatomic,strong)NSArray* arrayTitle;
@property(nonatomic,assign)NSInteger currySelCell;


@property(nonatomic,assign)BOOL isCanNotTouch;//控制动画完成后再点击移除
@property(nonatomic,assign)BOOL animated;//是否需要动画展示／移除
@end
static NSString* const RefundReasonTableViewCell_Resign = @"RefundReasonTableViewCell_Resign";

@implementation PurRefundReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currySelCell = -1;
    self.arrayTitle  = @[@"拍错／拍多／不想要了",@"卖家缺货",@"卖家未按约定时间发货",@"其他"];
    
    [self buildUI];
    
}

-(void)buildUI
{
    _alpbackView= [[UIView alloc] initWithFrame:self.view.bounds];
    _alpbackView.backgroundColor = [UIColor blackColor];
    _alpbackView.alpha = 0.35;
    [self.view addSubview:_alpbackView];
    [self.alpbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.sectionHeaderHeight = 50;
    self.tableView.sectionFooterHeight = 45.f+10;
    if (IOS_VERSION>=9.0) {
        self.tableView.tableFooterView = [UIView new];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 3;
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RefundReasonTableViewCell" bundle:nil] forCellReuseIdentifier:RefundReasonTableViewCell_Resign];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(10);
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(0));
    }];
    
    
}
#pragma mark - tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTitle.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.tableView.bounds.size.height-95.f-10-HEIGHT_TABBAR_SAFE)/4;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LCDW, 50)];
    v.backgroundColor = [UIColor whiteColor];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(LCDW/2-90, 15, 180, 25)];
    label.text = @"退款原因";
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = [WYUISTYLE colorWithHexString:@"#2F2F2F"];
    label.textAlignment = NSTextAlignmentCenter;
    [v addSubview:label];
    
    return v;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LCDW, 45+10)];
    v.backgroundColor = [UIColor whiteColor];
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, LCDW, 45)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[WYUISTYLE colorWithHexString:@"757575"] forState:UIControlStateNormal];
    [v addSubview:btn];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, LCDW-30, 1)];
    line.backgroundColor =  [WYUISTYLE colorWithHexString:@"f3f3f3"];
    [v addSubview:line];
    return v;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundReasonTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:RefundReasonTableViewCell_Resign];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.descLabel.text = _arrayTitle[indexPath.row];
    if (_currySelCell == indexPath.row) {
        cell.imgbtn.selected = YES; //切换图片
    }else{
        cell.imgbtn.selected = NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currySelCell = indexPath.row;
    [self.tableView reloadData];

    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_PurRefundReasonViewController:viewWillRemoveWithSelString:didSelectedInteger:)]) {
        [self.delegate jl_PurRefundReasonViewController:self viewWillRemoveWithSelString:self.arrayTitle[indexPath.row] didSelectedInteger:indexPath.row];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成后
        [self removeSelf];
    });
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)removeSelf
{
    if (self.animated) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(LCDScale_5Equal6_To6plus(0));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
            
            _alpbackView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }else{
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}
-(void)showToViewController:(UIViewController *)viewController WithAnimated:(BOOL)animated
{
    
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
    self.view.bounds = viewController.view.bounds;
    [self.view layoutIfNeeded];
    
    self.animated = animated;
    if (self.animated) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(LCDScale_5Equal6_To6plus(285.f+10)+HEIGHT_TABBAR_SAFE);
        }];
        
        _alpbackView.alpha = 0;
        _isCanNotTouch = YES;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
            
            _alpbackView.alpha = 0.35;
        } completion:^(BOOL finished) {
            _isCanNotTouch = NO;
            
        }];
    }else{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(LCDScale_5Equal6_To6plus(285.f+10)+HEIGHT_TABBAR_SAFE);
        }];
        
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (_isCanNotTouch) {
        return;
    }
    
    if (self.view.superview) {
        if (self.animated) {
            
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(LCDScale_5Equal6_To6plus(0));
            }];
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
                
                _alpbackView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
            }];
        }else{
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
