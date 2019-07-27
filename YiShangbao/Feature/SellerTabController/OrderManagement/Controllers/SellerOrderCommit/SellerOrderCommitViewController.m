//
//  SellerOrderCommitViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SellerOrderCommitViewController.h"

#import "WYCommentProductTableViewCell.h"

#import "OrderManagementDetailModel.h"

@interface SellerOrderCommitViewController ()
<UITableViewDelegate,UITableViewDataSource,WYCommentProductTableViewCellDelegate,ZXEmptyViewControllerDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@property(nonatomic,strong)OMOrderSelCommentInitModel* omorderSelCommentInitModel;


@property(nonatomic,strong)NSString * buyerStar ;
@property(nonatomic,strong)NSString *buyDescription;
@end

static NSString* const WY_Sel_CommentProductTableViewCell_Resign = @"WY_Sel_CommentProductTableViewCell_Resign";

@implementation SellerOrderCommitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发表评价";
    
    [self requestSellerData];
    [self buildUI];
}
#pragma mark - 初始化评价-接口
-(void)requestSellerData
{
    [[[AppAPIHelper shareInstance] gethsOrderManagementApi] GetSelCommitInitWithOrderId:_orderId success:^(id data) {
        [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];

        self.omorderSelCommentInitModel = data;
        [self.tableView reloadData];

        if (self.omorderSelCommentInitModel) {
            _buyerStar = @"5";
            [self addRightBarButtonItem]; //添加发布按钮
        }
        
    } failure:^(NSError *error) {
        if (![self is_ORDER_EVAL_ERROR_Error:error]) {
            [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:YES];
            [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
        }
    }];
}
#pragma mark - 发表评价-接口
-(void)requestCommitData
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
     [[[AppAPIHelper shareInstance] gethsOrderManagementApi] PostSelCommitBuyerAddOrderCommentWithOrderId:_orderId description:_buyDescription buyerStar:_buyerStar success:^(id data) {
      
         [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
         [self.navigationController popViewControllerAnimated:NO];
         
         [MBProgressHUD zx_showSuccess:@"评论成功" toView:nil];

     } failure:^(NSError *error) {
         [MBProgressHUD zx_hideHUDForView:nil];
         if (![self is_ORDER_EVAL_ERROR_Error:error]) {
             [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
         }
     }];
}
-(BOOL)is_ORDER_EVAL_ERROR_Error:(NSError*)error
{
    NSString *code = [error.userInfo objectForKey:@"code"];
    if ([code isEqualToString:@"ORDER_EVAL_ERROR"])
    {
        UIAlertController* alertView= [UIAlertController alertControllerWithTitle:@"该订单信息已发生改变，无法进行当前操作，请在刷新订单后重新操作。" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
            [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView addAction:alertAction];
        [self presentViewController:alertView animated:YES completion:nil];
        return YES;
    }else{
        return NO;
    }
}
-(void)addRightBarButtonItem
{
    UIButton* commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 104*0.5, 44*0.5)];
    [commitBtn setBackgroundImage: [UIImage imageNamed:@"btu_fabu_seller"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(clcikcommit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commitBtn];
}
-(void)buildUI
{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [WYUISTYLE colorWithHexString:@"f3f3f3"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WYCommentProductTableViewCell" bundle:nil] forCellReuseIdentifier:WY_Sel_CommentProductTableViewCell_Resign];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"qwer"];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
    
}
#pragma mark - 氛围图
-(void)zxEmptyViewUpdateAction
{
    [self requestSellerData];
}
#pragma mark - 发表评论
-(void)clcikcommit:(UIButton*)sender
{
    [self.view endEditing:NO];
    [self requestCommitData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.omorderSelCommentInitModel) {
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 175;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYCommentProductTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:WY_Sel_CommentProductTableViewCell_Resign];
    
    
    NSURL* picURl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:_omorderSelCommentInitModel.buyerPic];
    [cell.IMV sd_setImageWithURL:picURl placeholderImage:AppPlaceholderImage];
   
    [cell setStartTitleList:_omorderSelCommentInitModel.list];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)jl_WYCommentProductTableViewCell:(WYCommentProductTableViewCell *)wycommentProductTableViewCell commitInfoChangeStart:(NSString *)start textfildText:(NSString *)text
{
    _buyerStar = [NSString stringWithFormat:@"%@",start];
    _buyDescription = [NSString stringWithFormat:@"%@",text];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    NSLog(@"jl_dealloc success");
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
