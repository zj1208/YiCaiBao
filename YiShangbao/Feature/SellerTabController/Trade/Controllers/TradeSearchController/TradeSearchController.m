//
//  TradeSearchController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/8/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "TradeSearchController.h"

#import "UICollectionViewLeftAlignedLayout.h"
#import "TradeSearchCollCell.h"

#import "SearchAPI.h"

#import "TradeSearchDetailController.h"

#import "WYTabBarViewController.h"

@interface TradeSearchController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)UICollectionViewLeftAlignedLayout *flowLayout;

@property(nonatomic,strong)NSArray*arrayHistory;


@end

@implementation TradeSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arrayHistory = [NSArray array];
    
    [self buildUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([UserInfoUDManager isLogin])
    {
        self.loginView.hidden = YES;
        [self requestHistoryData];

    }else{
        [self.view bringSubviewToFront:self.loginView];
        self.loginView.hidden = NO;
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.sousuoTextfild becomeFirstResponder];
}
#pragma mark - 请求删除所有数据
-(void)requestRemoveAllHistoryData
{
    [[[AppAPIHelper shareInstance] getSearchAPI] postDelTradeHistorySearchKeywordsWithBizTyp:3 success:^(id data) {
        
        [self requestHistoryData];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 请求历史记录
-(void)requestHistoryData
{
    [[[AppAPIHelper shareInstance] getSearchAPI] getHistorySearchKeywordsWithBizType:3 success:^(id data) {
        
        self.arrayHistory = [NSArray arrayWithArray:[data objectForKey:@"searchKeywords"]];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)setSearchKeyword:(NSString *)searchKeyword
{
    _searchKeyword = searchKeyword;
    if (self.sousuoTextfild) {
        self.sousuoTextfild.text = _searchKeyword;
    }
}
-(void)buildUI
{
    if (![NSString zhIsBlankString: self.searchKeyword]) {
        self.sousuoTextfild.text = self.searchKeyword;
    }
    _flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.minimumLineSpacing = 20;
    _flowLayout.minimumInteritemSpacing = 15;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];

    [_collectionView registerNib:[UINib nibWithNibName:@"TradeSearchCollCell"bundle:nil] forCellWithReuseIdentifier:@"TitleCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    //ihponeX
    [self.stateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_STATEBAR);
    }];    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section == 0){
        return self.arrayHistory.count;
    }
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        
        return [self jl_SizeWidthWithStr:self.arrayHistory[indexPath.row]];
    }
    return CGSizeZero;
}
//计算所需宽度（数据多的页面最好把高度缓存到model中,滑动复用时不需要每次计算）
-(CGSize)jl_SizeWidthWithStr:(NSString*)str
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, LCDScale_5Equal6_To6plus(25.f)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    CGFloat Width = rect.size.width;
    if (rect.size.width > LCDW-self.flowLayout.sectionInset.left-self.flowLayout.sectionInset.right-25.f)
    {
        Width = LCDW-self.flowLayout.sectionInset.left-self.flowLayout.sectionInset.right;
    }else{
        Width = ceilf(Width+25.f);
    }
    return CGSizeMake(Width, LCDScale_5Equal6_To6plus(25.f));
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (self.arrayHistory.count > 0 && section == 0) {
        return CGSizeMake(LCDW-40, 30+15+8);
    }
    return CGSizeZero;
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//就不自定义head了
    
    UIImageView *redV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 22.5, 5, 15)];
    redV.image = [WYUIStyle imageFD7953_FE5147:CGSizeMake(1, 1)];
    redV.layer.cornerRadius = 2.5;
    redV.layer.masksToBounds = YES;
    [view addSubview:redV];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, LCDW-40-40, 30)];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [WYUISTYLE colorWithHexString:@"2f2f2f"];
    [view addSubview:label];
    
    if (indexPath.section == 0) {
        label.text = @"搜索历史";
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(LCDW-50, 15, 40, 30)];
        [btn setImage:[UIImage imageNamed:@"searchDele"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickAllDele:)forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TradeSearchCollCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TitleCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.titleLabel.text = self.arrayHistory[indexPath.row];
        
    }
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sousuoTextfild resignFirstResponder];
    NSString *title = self.arrayHistory[indexPath.row];
    [self showDelegate:title];
}
#pragma mark - dele
-(void)showDelegate:(NSString *)searchKeyword
{
    if (searchKeyword) {
        
        TradeSearchDetailController *VC = [[TradeSearchDetailController alloc] init];
        VC.searchKeyword = searchKeyword;
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window]; //当前window
        UITabBarController* tabB = (UITabBarController*)window.rootViewController;
        UINavigationController* naviVC = tabB.selectedViewController;

        if ([naviVC.topViewController isKindOfClass:[TradeSearchDetailController class] ]) {
            [naviVC popViewControllerAnimated:NO];

            [naviVC pushViewController:VC animated:NO];
        }else{
            [naviVC pushViewController:VC animated:NO];
        }
        
        
        [self dismissViewControllerAnimated:NO completion:^{
            VC.searchVC = self; //dismis后不销毁,引用给SearchDetailVC使用
            self.searchKeyword = searchKeyword;//点击历史搜索
            
        }];
    }
    else//取消
    {
        
        [self dismissViewControllerAnimated:NO completion:^{

        }];
    }
   
//    if (self.delegate&& [self.delegate respondsToSelector:@selector(jl_willDismissTradeSearchController:searchKeyword:)]) {
//        [self.delegate jl_willDismissTradeSearchController:self searchKeyword:searchKeyword];
//    }
//    [self dismissViewControllerAnimated:NO completion:^{
//
//        if (self.delegate&& [self.delegate respondsToSelector:@selector(jl_didDismissTradeSearchController:)]) {
//            [self.delegate jl_didDismissTradeSearchController:self];
//        }
//    }];
}
#pragma mark - 点击删除所有数据
-(void)clickAllDele:(UIButton*)sender
{
    UIAlertController* alertActionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定清空历史搜索吗？" preferredStyle:  UIAlertControllerStyleAlert];
    
    UIAlertAction*alertOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
    }];
    UIAlertAction*alertTwo = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        [self requestRemoveAllHistoryData];
    }];
    [alertActionSheet addAction:alertOne];
    [alertActionSheet addAction:alertTwo];
    [self presentViewController:alertActionSheet animated:YES completion:nil];
}
#pragma mark 点击return(搜索)按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.sousuoTextfild resignFirstResponder];
    
    if (![NSString zhIsBlankString:self.sousuoTextfild.text]) {
        [self showDelegate:self.sousuoTextfild.text];
    }
    return YES;
}
#pragma mark － string用户输入的单个字符，range 字符插入的位置
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   BOOL bo = [UITextField xm_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:20 remainTextNum:^(NSInteger remainLength) {
        
    }];
    return bo;
}
/*------------*/
#pragma mark - Actions
#pragma mark - 点击取消按钮
- (IBAction)quxiaoBtnClick:(UIButton *)sender {
    [self.sousuoTextfild resignFirstResponder];
    
    [self showDelegate:nil];
}
- (IBAction)loginBtnClick:(UIButton *)sender {
    [self xm_performIsLoginActionWithPopAlertView:NO];
}
-(void)dealloc
{
    NSLog(@"dealloc TradeSearchController Success");
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
