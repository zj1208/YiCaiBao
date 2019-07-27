
//
//  WYPurOrderCommitViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurOrderCommitViewController.h"

#import "WYCommentProductTableViewCell.h"
#import "WYCommentShopTableViewCell.h"

#import "OrderManagementDetailModel.h"

@interface WYPurOrderCommitViewController ()<UITableViewDelegate,UITableViewDataSource,WYCommentProductTableViewCellDelegate,WYCommentShopTableViewCellDelegate,ZXEmptyViewControllerDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@property(nonatomic,strong)NSArray* arrayProducts;
@property(nonatomic,strong)NSArray* arrayStartList;

@property(nonatomic,strong)NSMutableDictionary* orderCommitDict; //评论提交参数
@property(nonatomic,strong)NSMutableArray* arrayProds; //评论提交产品参数
@end

static NSString* const WYCommentProductTableViewCell_Resign = @"WYCommentProductTableViewCell_Resign";
static NSString* const WYCommentShopTableViewCell_Resign = @"WYCommentShopTableViewCell_Resign";

@implementation WYPurOrderCommitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.arrayProducts = [NSArray array];
    self.arrayStartList = [NSArray array];
    self.arrayProds = [NSMutableArray array];
    
    self.title = @"发表评价";
    
    [self requestData];
    [self buildUI];
}
#pragma mark - 初始化评价
-(void)requestData
{
    [[[AppAPIHelper shareInstance] gethsOrderManagementApi] PostPurCommitInitWithOrderId:_bizOrderId success:^(id data) {
        [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];

        OMOrderPurCommentInitModel *model = (OMOrderPurCommentInitModel *)data;
        self.arrayStartList  = [NSArray arrayWithArray:model.list];
        self.arrayProducts  = [NSArray arrayWithArray:model.prods];
        [self.tableView reloadData];
        
        if (self.arrayProducts.count>0) {
            [self addRightBarButtonItem]; //添加发布按钮
        }
        //初始化默认评分信息
        _arrayProds = [NSMutableArray array];
        for (int i=0; i<_arrayProducts.count; ++i) {
            OMOrderPurCommentInitProModel* model = self.arrayProducts[i];
            NSDictionary* dict = @{
                                   @"prodId":model.prodId,
                                   @"prodStar":@"5",
                                   @"description":@"",
                                   };
            [_arrayProds addObject:dict];
        }
        NSDictionary*  dict = @{
                                @"orderId":_bizOrderId,
                                @"prods":_arrayProds,
                                @"sellerService":@"5",
                                @"deliveryService":@"5",
                                
                                };
        
        self.orderCommitDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    } failure:^(NSError *error) {
        if (![self is_ORDER_EVAL_ERROR_Error:error]) {
            [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }
    }];
}
#pragma mark - 发表评价
-(void)CommitData
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    
    [[[AppAPIHelper shareInstance] gethsOrderManagementApi] PostPurCommitBuyerAddOrderCommentWithDict:_orderCommitDict success:^(id data) {
        
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
    [commitBtn setBackgroundImage: [UIImage imageNamed:@"btn_fabu"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(clcikcommit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commitBtn];
}
-(void)buildUI
{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [WYUISTYLE colorWithHexString:@"f3f3f3"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WYCommentProductTableViewCell" bundle:nil] forCellReuseIdentifier:WYCommentProductTableViewCell_Resign];
    [self.tableView registerNib:[UINib nibWithNibName:@"WYCommentShopTableViewCell" bundle:nil] forCellReuseIdentifier:WYCommentShopTableViewCell_Resign];
    
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
    [self requestData];
}

#pragma mark - 发表评论
-(void)clcikcommit:(UIButton*)sender
{
    [self.view endEditing:NO];
    [self CommitData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.arrayProducts.count;
    }else{
        if (self.arrayProducts.count>0) {
            return 1;
        }else{
            return 0;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 175;
    }else{
        return 113;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WYCommentProductTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:WYCommentProductTableViewCell_Resign];
        
        OMOrderPurCommentInitProModel* model = self.arrayProducts[indexPath.row];
        
        NSURL* picURl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.prodPic];
        [cell.IMV sd_setImageWithURL:picURl placeholderImage:AppPlaceholderImage];
        
        [cell setStartTitleList:self.arrayStartList];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        WYCommentShopTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:WYCommentShopTableViewCell_Resign];
        [cell setStartTitleList:self.arrayStartList];

        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}

-(void)jl_WYCommentProductTableViewCell:(WYCommentProductTableViewCell *)wycommentProductTableViewCell commitInfoChangeStart:(NSString *)start textfildText:(NSString *)text
{
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:wycommentProductTableViewCell];
    
    NSMutableDictionary* prodDict = [NSMutableDictionary dictionaryWithDictionary:self.arrayProds[indexPath.row]];
    [prodDict setObject:start forKey:@"prodStar"];
    [prodDict setObject:text forKey:@"description"];
    [_arrayProds replaceObjectAtIndex:indexPath.row withObject:prodDict];
    [_orderCommitDict  setObject:_arrayProds forKey:@"prods"];
    
    NSLog(@"%@",_orderCommitDict);
    
}
-(void)jl_WYCommentShopTableViewCell:(WYCommentShopTableViewCell *)cell serviceStart:(NSString *)serviceStart velocityStart:(NSString *)velocityStart
{
    [_orderCommitDict  setObject:serviceStart forKey:@"sellerService"];
    [_orderCommitDict  setObject:velocityStart forKey:@"deliveryService"];
    NSLog(@"%@",_orderCommitDict);
    
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
