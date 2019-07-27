//
//  ManageBrandController.m
//  YiShangbao
//
//  Created by simon on 17/2/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ManageBrandController.h"

#import "TMDiskManager.h"
#import "ManageBrandsCell.h"
#import "ZXTitleView.h"

@interface ManageBrandController ()<ZXLabelsInputTagsViewDelegate>

@property (nonatomic, strong)TMDiskManager *diskManager;
@property (nonatomic, strong) NSMutableArray *dataMArray;


@end

@implementation ManageBrandController

static NSString *const reuse_editTagsCell = @"editTagsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    
    [self setData];
    
}

- (void)dealloc
{
    
}

- (void)setData
{
    NSMutableArray *addArray = [NSMutableArray array];
    self.dataMArray = addArray;
    
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskShopManageInfoKey];
    self.diskManager = manager;
    ShopManagerInfoModel *model = (ShopManagerInfoModel *)[self.diskManager getData];

    if (![NSString zhIsBlankString:model.mainBrand])
    {
        NSArray *labelsArray = [model.mainBrand componentsSeparatedByString:@","];
        if (labelsArray.count>0)
        {
            [self.dataMArray addObjectsFromArray:labelsArray];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ManageBrandsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_editTagsCell forIndexPath:indexPath];
    cell.inputTagsView.delegate = self;
    [cell setData:self.dataMArray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static ManageBrandsCell *cell =  nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        cell = [tableView dequeueReusableCellWithIdentifier:reuse_editTagsCell];
    });
    return [cell getCellHeightWithContentIndexPath:indexPath data:self.dataMArray];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section ==0)
    {
        ZXTitleView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] lastObject];
        view.titleLab.text =@"最多输入5个品牌";
        view.titleLab.font = [UIFont systemFontOfSize:12];
        view.titleLab.textColor = [UIColor redColor];
        [view.leftImageView removeFromSuperview];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
    }
    return [[UIView alloc] init];
}



- (void)zx_labelsInputTagsView:(ZXLabelsInputTagsView *)tagsView commitEditingStyle:(ZXLabelsInputCellEditingStyle)editingStyle forRowAtIndexPath:(nullable NSIndexPath *)indexPath addTagTitle:(nullable NSString *)title
{
    if (editingStyle ==ZXLabelsInputCellEditingStyleDelete)
    {
        [self.dataMArray removeObjectAtIndex:indexPath.item];
        [self.tableView reloadData];
    }
    else if (editingStyle ==ZXLabelsInputCellEditingStyleInserted)
    {
        [self.dataMArray insertObject:title atIndex:0];
        [self.tableView reloadData];
    }
}

- (BOOL)zx_shuoldAddTagTitleWithLabelsInputTagsView:(ZXLabelsInputTagsView *)tagsView tagTitle:(NSString *)title
{
    if ([self.dataMArray containsObject:title])
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"经营品牌不能重复，请更换", nil) toView:self.view];
        return NO;
    }
    return YES;
}

- (IBAction)saveBarItemAction:(UIBarButtonItem *)sender {
    
    if (self.dataMArray.count>0)
    {
        NSString *labels = [self.dataMArray componentsJoinedByString:@","];
        [self.diskManager setPropertyImplementationValue:labels forKey:@"mainBrand"];
    }
    else
    {
        [self.diskManager setPropertyImplementationValue:nil forKey:@"mainBrand"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
