//
//  CusNowAddController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "CusNowAddController.h"

#import "SMCustomerNowAddCell.h"
#import "SMCNowAddRemarkCell.h"
#import "SMCustomerModel.h"
#import "WYBillSearchResultViewController.h"
#import <IQKeyboardManager.h>

@interface CusNowAddController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *saveBtn;

@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) NSMutableArray *placeholderArray;

@property (strong, nonatomic) SMCustomerAddModel *smModel;
@property (strong, nonatomic)UITextField *firstTextfild;
@end
static NSString *const cellReuse_SMCustomerNowAddCell = @"SMCustomerNowAddCell";
static NSString *const cellReuse_SMCNowAddRemarkCell = @"SMCNowAddRemarkCell";

@implementation CusNowAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorF3F3F3];

    NSArray *titleArray = @[@"新增客户",@"客户信息",@"编辑客户"];
    self.navigationItem.title = titleArray[self.type];
    NSArray *title = @[@[@"*公司名称"],@[@"联系人",@"联系电话",@"微信"],@[@"邮箱",@"传真",@"地址"],@[@"备注"]];
    NSArray *place = @[@[@"请输入公司名称"],@[@"请输入联系人姓名",@"请输入电话号码",@"请输入微信号"],@[@"请输入邮箱地址",@"请输入传真号",@"请输入地址"],@[@"请输入备注"]];
    self.titleArray = [NSMutableArray arrayWithArray:title];
    self.placeholderArray = [NSMutableArray arrayWithArray:place];
    if (self.type == CusNowAdd_look) {
        [self.titleArray addObject:@[@"相关订单"]];
        [self.placeholderArray addObject:@[@""]];
    }
    
    [self buildUI];
}

- (void)dealloc
{
    
}
-(void)requestData
{
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getkBillGetContact:_contactId success:^(id data) {
        self.smModel = data;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
}
-(void)buildUI
{
    if (self.type == CusNowAdd_look) {
        UIButton *AddBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [AddBtn setTitle:@"编辑" forState:UIControlStateNormal];
        AddBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [AddBtn setTitleColor:[WYUISTYLE colorWithHexString:@"#FF5434"] forState:UIControlStateNormal];
        [AddBtn addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:AddBtn];
    }

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SMCustomerNowAddCell" bundle:nil] forCellReuseIdentifier:cellReuse_SMCustomerNowAddCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"SMCNowAddRemarkCell" bundle:nil] forCellReuseIdentifier:cellReuse_SMCNowAddRemarkCell];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        if (self.type == CusNowAdd_look) {
            make.bottom.mas_equalTo(self.view);
        }else{
            make.bottom.mas_equalTo(self.view).offset(-60);
        }
    }];
    
    //底部按钮
    if (self.type == CusNowAdd_add || self.type == CusNowAdd_edit) {
        UIView *bottonBackView = [[UIView alloc] init];
        bottonBackView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
        [self.view addSubview:bottonBackView];
        [bottonBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.height.mas_equalTo(60.f+HEIGHT_TABBAR_SAFE);
            make.bottom.mas_equalTo(self.view);
        }];
        self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,LCDH-45-15, LCDW-30, 45)];
        _saveBtn.layer.masksToBounds = YES;
        _saveBtn.layer.cornerRadius = 22.5;
        _saveBtn.adjustsImageWhenHighlighted = NO;
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn setBackgroundImage:[WYUISTYLE imageWithStartColorHexString:@"#FD7953" EndColorHexString:@"#FE5147"  WithSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(clickSave:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saveBtn];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(15.f);
            make.right.mas_equalTo(self.view).offset(-15.f);
            make.height.mas_equalTo(45.f);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-7.5);
            } else {
                make.bottom.equalTo(self.view).offset(-7.5);
            }
        }];
    }
}
-(void)clickEdit:(UIButton*)sender
{
    [MobClick event:kUM_kdb_customer_edit];
    CusNowAddController *Vc= [[CusNowAddController alloc] init];
    Vc.type = CusNowAdd_edit;
    Vc.contactId = self.contactId;
    [self.navigationController pushViewController:Vc animated:YES];
    
}
-(void)clickSave:(UIButton*)sender
{
    [MobClick event:kUM_kdb_customer_save];
    if ([_smModel.companyName isEqualToString:@""] || !_smModel.companyName) {
        [MBProgressHUD zx_showError:@"请输入公司名称" toView:self.view];
        return;
    }
    if (![NSString zhIsIntScan:_smModel.mobile] && ![_smModel.mobile isEqualToString:@""]  &&_smModel.mobile) {
        [MBProgressHUD zx_showError:@"请输入正确的电话号码" toView:self.view];
        return;
    }
    if (![self isEmail:_smModel.email] && ![_smModel.email isEqualToString:@""] &&_smModel.email) {
        [MBProgressHUD zx_showError:@"请输入正确的邮箱" toView:self.view];
        return;
    }
    NSDictionary * parm = [MTLJSONAdapter JSONDictionaryFromModel:_smModel error:nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:parm];
    [parameters setObject:[parm objectForKey:@"address"] forKey:@"addr"];
    [parameters removeObjectForKey:@"address"];  //提交时地址字段key=addr
    _saveBtn.enabled = NO;
    [[[AppAPIHelper shareInstance] getMakeBillAPI] postkBillNewCustomerInfo:parameters success:^(id data) {
        _saveBtn.enabled = YES;
        [self.navigationController popViewControllerAnimated:NO];
        [MBProgressHUD zx_showSuccess:@"保存成功" toView:nil];
    } failure:^(NSError *error) {
        _saveBtn.enabled = YES;
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
    
}
-(BOOL)isEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isOk = [emailTest evaluateWithObject:email];
    return isOk;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr =  self.titleArray[section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return CGFLOAT_MIN;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==4) {
        return 20.0;
    }
    return 10.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.contentView.backgroundColor= self.view.backgroundColor;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        return 116.f;
    }
    return LCDScale_5Equal6_To6plus(45);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        SMCNowAddRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_SMCNowAddRemarkCell forIndexPath:indexPath];
        if (self.type == CusNowAdd_look) {
            cell.textView.placeholder = @"";
            cell.textView.userInteractionEnabled = NO;
        }else{
            NSArray *arrayP =  self.placeholderArray[indexPath.section];
            cell.textView.placeholder = arrayP[indexPath.row];
            cell.textView.userInteractionEnabled = YES;
        }
        cell.textView.text = [self getText:indexPath];
        cell.textView.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        SMCustomerNowAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse_SMCustomerNowAddCell forIndexPath:indexPath];
        NSArray *arrayT =  self.titleArray[indexPath.section];
        cell.myTitleLabel.text = arrayT[indexPath.row];
        if ([cell.myTitleLabel.text hasPrefix:@"*"]) { //*颜色处理
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:cell.myTitleLabel.text];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[WYUISTYLE colorWithHexString:@"FF5434"] range:NSMakeRange(0, 1)];
            cell.myTitleLabel.attributedText = attributedString;
        }
        if (self.type == CusNowAdd_look) {
            cell.textFildView.placeholder = @"";
            cell.textFildView.enabled = NO;
        }else{
            NSArray *arrayP =  self.placeholderArray[indexPath.section];
            cell.textFildView.placeholder = arrayP[indexPath.row];
            cell.textFildView.enabled = YES;
            if (indexPath.section==0&&indexPath.row==0) {
                self.firstTextfild = cell.textFildView;
            }
        }
        cell.textFildView.text = [self getText:indexPath];
        cell.textFildView.delegate = self;
        if (indexPath.section == 4) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == CusNowAdd_look && indexPath.section == 4) {
        UIStoryboard *SB = [UIStoryboard storyboardWithName:sb_MakeBills bundle:nil];
        WYBillSearchResultViewController *VC = [SB instantiateViewControllerWithIdentifier:SBID_WYBillSearchResultViewController];
        VC.searchWord = _smModel.companyName;
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
-(NSString*)getText:(NSIndexPath*)indexPath
{
    if (_smModel) {
        if (indexPath.section==0) {
            return _smModel.companyName?_smModel.companyName:@"";
        }
        else if (indexPath.section==1) {
            if (indexPath.row==0) {
                return _smModel.contact?_smModel.contact:@"";
            }
            else if (indexPath.row==1) {
                return _smModel.mobile?_smModel.mobile:@"";
            }
            else if (indexPath.row==2) {
                return _smModel.wechat?_smModel.wechat:@"";
            }
        }
        else if (indexPath.section==2) {
            if (indexPath.row==0) {
                return _smModel.email?_smModel.email:@"";
            }
            else if (indexPath.row==1) {
                return _smModel.fax?_smModel.fax:@"";
            }
            else if (indexPath.row==2) {
                return _smModel.address?_smModel.address:@"";
            }
        }
        else if (indexPath.section==3) {
            return _smModel.remark?_smModel.remark:@"";
        }
    }
    return @"";
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    SMCustomerNowAddCell *cell = (SMCustomerNowAddCell*)textField.superview.superview;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NSInteger lent = -1;
    if (indexPath.section==0) {
        lent = 20;
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            lent = 20;
        }
        else if (indexPath.row==1) {
            lent = 12;
        }
        else if (indexPath.row==2) {
            lent = 20;
        }
    }
    else if (indexPath.section==2) {
        if (indexPath.row==0) {
            lent = -1;
        }
        else if (indexPath.row==1) {
            lent = 12;
        }
        else if (indexPath.row==2) {
            lent = 50;
        }
        else if (indexPath.row==3) {
            lent = 50;
        }
    }
    if (lent == -1) {
        return YES;
    }
    return [UITextField xm_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:lent remainTextNum:^(NSInteger remainLength) {
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath* indexPath = [self getCurryIndexPath:textField];
    NSString *text = textField.text;
    [self setSmModelData:indexPath text:text];
}
-(NSIndexPath *)getCurryIndexPath:(UIView *)view
{
    UIView *cell = view.superview;
    while (cell && ![cell isKindOfClass:[UITableViewCell class]]) {
        cell = cell.superview;
        if ([cell isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *tabCell = (UITableViewCell *)cell;
            NSIndexPath* indexPath = [self.tableView indexPathForCell:tabCell];
            return indexPath;
        }
    }
    return [NSIndexPath init];
}
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    NSIndexPath* indexPath = [self getCurryIndexPath:textView];
    NSString *text = textView.text;
    [self setSmModelData:indexPath text:text];
}
-(void)setSmModelData:(NSIndexPath*)indexPath text:(NSString*)text
{
    if (!_smModel) {
        self.smModel = [[SMCustomerAddModel alloc] init];
    }
    text = [text isEqualToString:@""]?nil:text;
    if (indexPath.section==0) {
        self.smModel.companyName = text;
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            self.smModel.contact = text;
        }
        else if (indexPath.row==1) {
            self.smModel.mobile = text;
        }
        else if (indexPath.row==2) {
            self.smModel.wechat = text;
        }
    }
    else if (indexPath.section==2) {
        if (indexPath.row==0) {
            self.smModel.email = text;
        }
        else if (indexPath.row==1) {
            self.smModel.fax = text;
        }
        else if (indexPath.row==2) {
            self.smModel.address = text;
        }
    }
    else if (indexPath.section==3) {
        self.smModel.remark = text;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.type == CusNowAdd_look || self.type == CusNowAdd_edit) {
        [self requestData];
    }
    
    [[IQKeyboardManager sharedManager] setEnable:NO] ;
    [self registerForKeyboardNotifications];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    [[IQKeyboardManager sharedManager] setEnable:YES] ;
    [self removeObserverForKeyboardNotifications];
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeObserverForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-rect.size.height);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-60);
    }];
    [self.view layoutIfNeeded];
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
