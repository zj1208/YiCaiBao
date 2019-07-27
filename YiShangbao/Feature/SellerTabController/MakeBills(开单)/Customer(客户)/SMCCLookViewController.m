//
//  SMCCLookViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/5/16.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SMCCLookViewController.h"
#import "SMCCLookTextCell.h"
#import "SMCCLookHeadwCell.h"

#import "SMCustomerModel.h"
#import "CusNowAddController.h"
#import "WYBillSearchResultViewController.h"

@interface SMCCLookViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) SMCustomerAddModel *smModel;

@end

static NSString *const cell_SMCCLookTextCell = @"cell_SMCCLookTextCell";
static NSString *const cell_SMCCLookHeadwCell = @"cell_SMCCLookHeadwCell";

@implementation SMCCLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = NSLocalizedString(@"客户信息", nil);

    self.titleArray = @[@"联系人",@"微信",@"邮箱",@"传真",@"地址",@"备注",@"相关订单"];

    
    [self buildUI];
    
}
- (void)dealloc
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}
-(void)requestData
{
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getkBillGetContact:_contactId success:^(id data) {
        self.smModel = data;
        
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
}
- (void)buildUI
{
    UIButton *AddBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [AddBtn setTitle:@"编辑" forState:UIControlStateNormal];
    AddBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [AddBtn setTitleColor:[WYUISTYLE colorWithHexString:@"#FF5434"] forState:UIControlStateNormal];
    [AddBtn addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:AddBtn];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_flowLayout]; //使用UICollectionView为了可能的动态高度TextView
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];

    [_collectionView registerNib:[UINib nibWithNibName:@"SMCCLookHeadwCell" bundle:nil] forCellWithReuseIdentifier:cell_SMCCLookHeadwCell];
    [_collectionView registerNib:[UINib nibWithNibName:@"SMCCLookTextCell" bundle:nil] forCellWithReuseIdentifier:cell_SMCCLookTextCell];
    
}
-(void)clickEdit:(UIButton*)sender
{
    [MobClick event:kUM_kdb_customer_edit];
    CusNowAddController *VC= [[CusNowAddController alloc] init];
    VC.type = CusNowAdd_edit;
    VC.contactId = self.contactId;
    [self.navigationController pushViewController:VC animated:YES];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 8;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        if (![NSString zhIsBlankString:self.smModel.contact]) {
            return 1;
        }
    }
    else if (section == 2)
    {
        if (![NSString zhIsBlankString:self.smModel.wechat]) {
            return 1;
        }
    }
    else if (section == 3)
    {
        if (![NSString zhIsBlankString:self.smModel.email]) {
            return 1;
        }
    }
    else if (section == 4)
    {
        if (![NSString zhIsBlankString:self.smModel.fax]) {
            return 1;
        }
    }
    else if (section == 5)
    {
        if (![NSString zhIsBlankString:self.smModel.address]) {
            return 1;
        }
    }
    else if (section == 6)
    {
        if (![NSString zhIsBlankString:self.smModel.remark]) {
            return 1;
        }
    }
    else if (section == 7)
    {
        return 1;
    }
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(LCDW, 130.f);
    }
    CGFloat height = CGFLOAT_MIN;
    if (indexPath.section == 1)
    {
        height = [self sizeHeightWithStr:self.smModel.contact];
    }
    else if (indexPath.section == 2)
    {
        height = [self sizeHeightWithStr:self.smModel.wechat];
    }
    else if (indexPath.section == 3)
    {
        height = [self sizeHeightWithStr:self.smModel.email];
    }
    else if (indexPath.section == 4)
    {
        height = [self sizeHeightWithStr:self.smModel.fax];
    }
    else if (indexPath.section == 5)
    {
        height = [self sizeHeightWithStr:self.smModel.address];
    }
    else if (indexPath.section == 6)
    {
        height = [self sizeHeightWithStr:self.smModel.remark];
    }else{
        height = [self sizeHeightWithStr:@""];
    }
    return CGSizeMake(LCDW, height);
}
-(CGFloat)sizeHeightWithStr:(NSString *)str
{
    NSMutableParagraphStyle *paraStyl = [[NSMutableParagraphStyle alloc] init];
    paraStyl.minimumLineHeight = 21.f;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(LCDW-75-15, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSParagraphStyleAttributeName:paraStyl} context:nil];
    return rect.size.height +12.f*2.0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    if (section==7) {
        return UIEdgeInsetsMake(10, 0, 40, 0);
    }
    return UIEdgeInsetsZero;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SMCCLookHeadwCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_SMCCLookHeadwCell forIndexPath:indexPath];
        cell.compantLabel.text = self.smModel.companyName;
        if ([NSString zhIsBlankString:self.smModel.mobile]) {
            cell.mobileLabel.text = @"暂无号码";
            cell.mobileLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        }else{
            cell.mobileLabel.text = self.smModel.mobile;
            cell.mobileLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }
        return cell;
    }
    else
    {
        SMCCLookTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_SMCCLookTextCell forIndexPath:indexPath];
        cell.titleLabel.text = self.titleArray[indexPath.section-1];
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        cell.rightIcon.hidden = indexPath.section == 7?NO:YES;
        
        if (indexPath.section == 1)
        {
            cell.contentLabel.text = self.smModel.contact;
        }
        else if (indexPath.section == 2)
        {
            cell.contentLabel.text = self.smModel.wechat;
        }
        else if (indexPath.section == 3)
        {
            cell.contentLabel.text = self.smModel.email;
        }
        else if (indexPath.section == 4)
        {
            cell.contentLabel.text = self.smModel.fax;
        }
        else if (indexPath.section == 5)
        {
            cell.contentLabel.text = self.smModel.address;
        }
        else if (indexPath.section == 6)
        {
            cell.contentLabel.text = self.smModel.remark;
            
        }else{
            cell.contentLabel.text = @"";
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }
        
        [cell.contentLabel jl_setAttributedText:nil withMinimumLineHeight:21.f];
        return cell;
    }
   
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 7) {
       
        UIStoryboard *SB = [UIStoryboard storyboardWithName:sb_MakeBills bundle:nil];
        WYBillSearchResultViewController *VC = [SB instantiateViewControllerWithIdentifier:SBID_WYBillSearchResultViewController];
        VC.searchWord = _smModel.companyName;
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
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
