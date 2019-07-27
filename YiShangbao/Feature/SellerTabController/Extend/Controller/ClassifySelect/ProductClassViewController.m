//
//  ProductClassViewController.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
#define SCR_W [UIScreen mainScreen].bounds.size.width
#import "ProductClassViewController.h"
#import "ProductClassFirstSectionCollectionViewCell.h"
#import "ProductClassSecondSectionCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "ZXEmptyViewController.h"


@interface ProductClassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ZXEmptyViewControllerDelegate>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UICollectionViewLeftAlignedLayout* flowLayout;
@property(nonatomic,strong)NSMutableArray* arrayDataModel;

@property(nonatomic,strong)NSMutableArray* arraySysCateIds;//选择的类目id,根据类目相同id匹配
@property(nonatomic,strong)NSMutableArray* arraySysCateNames;//选择的类目名称

@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@end

@implementation ProductClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"所属类目";
    
    [self setData];
    
    [self buidlUI];
    
    [self requestData];
    
}
-(void)setData
{
    self.arrayDataModel = [NSMutableArray array];
    self.arraySysCateIds = [NSMutableArray array];
    self.arraySysCateNames = [NSMutableArray array];

    if (![NSString zhIsBlankString:self.sysCateIds]) {
        NSArray *arrayId = [self.sysCateIds componentsSeparatedByString:@","];
        [self.arraySysCateIds addObjectsFromArray:arrayId];
    }
    
    if (![NSString zhIsBlankString:self.sysCateNames]) {
        NSArray *arrayName = [self.sysCateNames componentsSeparatedByString:@","];
        [self.arraySysCateNames addObjectsFromArray:arrayName];
    }
    
}
-(void)requestData
{
    [[[AppAPIHelper shareInstance] shopAPI] getSysCatesWithId:nil level:self.level success:^(id data) {

        self.arrayDataModel = [NSMutableArray arrayWithArray:data];
        [self.collectionView reloadData];
        
        [_emptyViewController addEmptyViewInController:self hasLocalData:_arrayDataModel.count error:nil emptyImage:[UIImage imageNamed:@"空经侦"] emptyTitle:@"暂无数据" updateBtnHide:YES];
        
    } failure:^(NSError *error) {
        [_emptyViewController addEmptyViewInController:self hasLocalData:_arrayDataModel.count error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];

}
- (void)zxEmptyViewUpdateAction
{
    [self requestData];
}
-(void)buidlUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    
    self.flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumInteritemSpacing = 15;
    self.flowLayout.minimumLineSpacing = 20;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductClassFirstSectionCollectionViewCell"bundle:nil] forCellWithReuseIdentifier:@"FIRSTPCLASS"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductClassSecondSectionCollectionViewCell"bundle:nil] forCellWithReuseIdentifier:@"SECONDPCLASS"];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    emptyVC.view.frame = CGRectMake(0, 64, LCDW, LCDH);
    self.emptyViewController = emptyVC;


}
-(void)saveData
{
    NSString *strID = [self.arraySysCateIds componentsJoinedByString:@","];
    NSString *strName = [self.arraySysCateNames componentsJoinedByString:@","];
    NSLog(@"=%@=%@=",strID,strName);
    if (strID && strName ) {
        self.classSelectedBlock(strID,strName);
    }
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - collectionViewDelegate
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return  UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        return  UIEdgeInsetsMake(20, 15, 20, 15);
    }
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.arrayDataModel.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        ProductClassFirstSectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FIRSTPCLASS" forIndexPath:indexPath];
        NSArray* array = [NSArray arrayWithObjects:@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九", nil];
        if (self.maxSelectPuoducts >=0 && self.maxSelectPuoducts <=9) {
            cell.selLabel.text = [NSString stringWithFormat:@"至多选择%@个类目",array[self.maxSelectPuoducts]];
        }else{
            cell.selLabel.text = [NSString stringWithFormat:@"可选择多个类目"];
        }
        return cell;
    }else{
        ProductClassSecondSectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SECONDPCLASS" forIndexPath:indexPath];
        
        SysCateModel* sysm = self.arrayDataModel[indexPath.row];
        cell.textLabelWY.text = [NSString stringWithFormat:@"%@",sysm.n];
        NSString *sysmID = [NSString stringWithFormat:@"%@",sysm.v];
       
        cell.curryState = WYClassCellTypeDafault;
        for (NSString* sysID  in self.arraySysCateIds) {
            if ([sysID isEqualToString:sysmID]) {
                cell.curryState = WYClassCellTypeSelected;
            }
        }
        return cell;
        
    }
}
#pragma mark - 返回item大小
- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(SCR_W, 35.f);
    }
    SysCateModel* sysm = self.arrayDataModel[indexPath.row];

    NSString *classname = [NSString stringWithFormat:@"%@",sysm.n];
    
    CGRect rect = [classname boundingRectWithSize:CGSizeMake(MAXFLOAT, 25.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    CGFloat weight = rect.size.width;
    if (rect.size.width > SCR_W-self.flowLayout.sectionInset.left-self.flowLayout.sectionInset.right-25.f) {
        weight = SCR_W-self.flowLayout.sectionInset.left-self.flowLayout.sectionInset.right;
    }else{
        weight += 25.f+1.f;
    }
    
    return CGSizeMake(weight, 25.f);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    
    if (self.maxSelectPuoducts == 0)
    {
        [MBProgressHUD zx_showError:[NSString stringWithFormat:@"至多选择0个类目"] toView:self.view];
        return;
    }
    else if (self.maxSelectPuoducts == 1)
    { //单选
        
        SysCateModel* sysm = self.arrayDataModel[indexPath.row];
        NSString *sysmID = [NSString stringWithFormat:@"%@",sysm.v];
        NSString *sysmName = [NSString stringWithFormat:@"%@",sysm.n];
        self.arraySysCateIds = [NSMutableArray arrayWithObject:sysmID];
        self.arraySysCateNames= [NSMutableArray arrayWithObject:sysmName];
        [self.collectionView reloadData];
        
    }
    else if (self.maxSelectPuoducts > 1)
    { //多选

        //遍历当前点击cell是否已选择
        BOOL isSelected = NO; NSInteger inx =0;
        SysCateModel* sysm = self.arrayDataModel[indexPath.row];
        NSString *sysmID = [NSString stringWithFormat:@"%@",sysm.v];
        NSString *sysmName = [NSString stringWithFormat:@"%@",sysm.n];

        for (int i =0; i<self.arraySysCateIds.count; ++i) {
            if ([sysmID isEqualToString:self.arraySysCateIds[i]] ) {
                isSelected = YES; inx = i;
            }
        }
        if (isSelected) {
            [self.arraySysCateIds removeObjectAtIndex:inx];
            [self.arraySysCateNames removeObjectAtIndex:inx];
            [self.collectionView reloadData];
        }else{
            if (self.arraySysCateIds.count >= self.maxSelectPuoducts) {
                [MBProgressHUD zx_showError:[NSString stringWithFormat:@"至多选择%ld个类目",self.maxSelectPuoducts] toView:self.view];
            }else{
                [self.arraySysCateIds addObject:sysmID];
                [self.arraySysCateNames addObject:sysmName];
                [self.collectionView reloadData];
            }
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
