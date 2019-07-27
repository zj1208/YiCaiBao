//
//  LookMyCustomerController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/26.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "LookMyCustomerController.h"
#import "MyCustomerAddHeadCell.h"
#import "MyCustomerLookCell.h"

#import "NTESSessionViewController.h"
#import "WYNIMAccoutManager.h"

#import "MyCustomerAddEditController.h"

@interface LookMyCustomerController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *deleCustomerBtn;


@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *placeholderArray;
@property(nonatomic,strong)CustomerInfoModel *customerInfoModel;

@end

static NSString *MyCustomerAddHeadCell_reuse = @"MyCustomerAddHeadCell";
static NSString *MyCustomerLookCell_reuse = @"MyCustomerLookCell";
@implementation LookMyCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorF3F3F3];
    
    self.title = NSLocalizedString(@"客户信息", nil);
    
    [self setData];
    
    [self buildUI];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestCustomerOnlineInfo];
}
-(void)setData
{
    self.titleArray = @[NSLocalizedString(@"备注名",nil),NSLocalizedString(@"电话",nil),NSLocalizedString(@"地址",nil),NSLocalizedString(@"描述",nil)];
    //我的客户-查看客户信息-采购商信息 删除客户后返回时跳过查看客户信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelfNow:) name:Noti_remove_LookMyCustomerController object:nil];
}
-(void)removeSelfNow:(id)noti
{
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
    [arrayM removeObject:self];
    [self.navigationController setViewControllers:arrayM animated:NO];
}
-(void)buildUI
{
    _deleCustomerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 28)];
    [_deleCustomerBtn setTitle:NSLocalizedString(@"删除客户",nil) forState:UIControlStateNormal];
    _deleCustomerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_deleCustomerBtn setTitleColor:[WYUISTYLE colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_deleCustomerBtn addTarget:self action:@selector(clickDeleCustomerBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_deleCustomerBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LCDW, LCDH-HEIGHT_NAVBAR-HEIGHT_TABBAR) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorColor = [UIColor colorWithHexString:@"ECECEC"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50 ;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [WYUISTYLE colorF3F3F3];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCustomerAddHeadCell" bundle:nil] forCellReuseIdentifier:MyCustomerAddHeadCell_reuse];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCustomerLookCell" bundle:nil] forCellReuseIdentifier:MyCustomerLookCell_reuse];
    
    UIButton *bottonBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, LCDH-45-HEIGHT_TABBAR_SAFE-50, LCDW-30, 45)];
    [bottonBtn setBackgroundImage:[WYUISTYLE imageWithStartColorHexString:@"#FD7953" EndColorHexString:@"#FE5147"  WithSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [bottonBtn setTitle:NSLocalizedString(@"在线沟通",nil) forState:UIControlStateNormal];
    bottonBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    bottonBtn.layer.masksToBounds = YES;
    bottonBtn.layer.cornerRadius = 22.5;
    [bottonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottonBtn addTarget:self action:@selector(clickIMBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottonBtn];
}

#pragma mark - 客户信息接口初始化
-(void)requestCustomerOnlineInfo
{
    [[[AppAPIHelper shareInstance] getUserModelExtendAPI] getCustomerOnlineInfoWithBuyerBizId:_buyerBizId type:customerOnlineInfo_look success:^(id data) {
       
        self.customerInfoModel = (CustomerInfoModel *)data;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 4;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.contentView.backgroundColor= self.tableView.backgroundColor;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MyCustomerAddHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomerAddHeadCell_reuse forIndexPath:indexPath];
        NSURL *url = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:self.customerInfoModel.icon];
        [cell.iconImageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
        cell.nameLabel.text = _customerInfoModel.nickName?_customerInfoModel.nickName:@"";
        cell.companyLabel.text = _customerInfoModel.companyName?_customerInfoModel.companyName:@"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 1)
    {
       
        MyCustomerLookCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomerLookCell_reuse forIndexPath:indexPath];
        cell.myTitleLabel.text = self.titleArray[indexPath.row];

        cell.descLabel.text = @"";
        cell.myTitleLabelBottm_descLabelTopLayout.constant = 0;
        if (indexPath.row==0)
        {
            if ([NSString zhIsBlankString:self.customerInfoModel.remark]) {
                cell.rightLabel.text = NSLocalizedString(@"未设置",nil) ;
                cell.rightLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
            }else{
                cell.rightLabel.text = self.customerInfoModel.remark;
                cell.rightLabel.textColor = [UIColor colorWithHexString:@"#333333 "];
            }
        }
        else if (indexPath.row==1)
        {
            if ([NSString zhIsBlankString:self.customerInfoModel.mobile]) {
                cell.rightLabel.text = NSLocalizedString(@"未设置",nil) ;
                cell.rightLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
            }else{
                cell.rightLabel.text = self.customerInfoModel.mobile;
                cell.rightLabel.textColor = [UIColor colorWithHexString:@"#333333 "];
            }
        }
        else if (indexPath.row==2)
        {
            if ([NSString zhIsBlankString:self.customerInfoModel.address]) {
                cell.rightLabel.text = NSLocalizedString(@"未设置",nil) ;
                cell.rightLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
            }else{
                cell.rightLabel.text = self.customerInfoModel.address;
                cell.rightLabel.textColor = [UIColor colorWithHexString:@"#333333 "];
            }
        }
        else if (indexPath.row == 3) {
            if ([NSString zhIsBlankString:self.customerInfoModel.describe]) {
                cell.rightLabel.text = NSLocalizedString(@"未设置",nil) ;
                cell.rightLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
            }else{
                cell.rightLabel.text = @"";
                cell.myTitleLabelBottm_descLabelTopLayout.constant = 8;
                [cell.descLabel jl_setAttributedText:self.customerInfoModel.describe withMinimumLineHeight:20.f];
            }
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        MyCustomerLookCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomerLookCell_reuse forIndexPath:indexPath];
        
        cell.myTitleLabel.text = NSLocalizedString(@"采购信息", nil);
        cell.descLabel.text = @"";
        cell.myTitleLabelBottm_descLabelTopLayout.constant = 0;
        cell.rightLabel.text = NSLocalizedString(@"搜索、评价、发求购等信息" , nil);
        cell.rightLabel.textColor = [UIColor colorWithHexString:@"999999"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 1) {
        MyCustomerAddEditController *vc = (MyCustomerAddEditController *)[self xm_getControllerWithStoryboardName:sb_ShopCustomer controllerWithIdentifier:@"MyCustomerAddEditControllerID"];
        vc.buyerBizId = self.buyerBizId;
        vc.isEditCustomer = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (indexPath.section == 2) {
        [MobClick event: kUM_b_customerinfo_Purchasersinfo];

        [self xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_BuyerInfoController withData:@{@"bizId":_buyerBizId, @"boolChat":@(YES),@"sourceType":@(AddOnlineCustomerSourceType_None)}];
    }
   
}
#pragma mark - 删除客户
- (void)clickDeleCustomerBtn:(id)sender
{
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:NSLocalizedString(@"是否确定删除该客户？",nil) message:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) cancleHandler:nil doButtonTitle:NSLocalizedString(@"确认删除",nil) doHandler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteCustomer];
    }];
}
- (void)deleteCustomer
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getUserModelExtendAPI]postDeleteOnlineCustomerWithBuyerBizId:_buyerBizId success:^(id data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_update_BuyerInfoController object:nil];
        
        [MBProgressHUD zx_hideHUDForView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD zx_showSuccess:NSLocalizedString(@"已成功删除客户",nil) toView:nil];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}
#pragma mark - 立即沟通
-(void)clickIMBtn:(UIButton *)sender
{
    if ([[WYNIMAccoutManager shareInstance]cheackAccoutEnable:self])
    {
        WS(weakSelf);
        [[[AppAPIHelper shareInstance]getNimAccountAPI]getChatUserIMInfoWithIDType:NIMIDType_User thisId:_buyerBizId success:^(id data) {
            
            NSString *accid = [data objectForKey:@"accid"];
            NSString *hisUrl = [data objectForKey:@"url"];
            NIMSession *session = [NIMSession session:accid type:NIMSessionTypeP2P];
            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
            vc.hisUrl = hisUrl;
            NSString *shopUrl = [data objectForKey:@"shopUrl"];
            vc.shopUrl = shopUrl;
            vc.hideUnreadCountView = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
        
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
