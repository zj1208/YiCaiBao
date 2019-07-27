//
//  SearchViewController.m
//  YiShangbao
//
//  Created by 海狮 on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDetailViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "SearchCollectionViewCell.h"
#import "SearchAPI.h"
@interface SearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)UICollectionViewLeftAlignedLayout *flowLayout;

@property(nonatomic,strong)NSArray*arrayHistory;
@property(nonatomic,strong)NSArray*arrayYouWantTofind;
@property(nonatomic,strong)NSString*arrayYouWantTofindTitle;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.arrayHistory = [NSArray array];
    self.arrayYouWantTofind = [NSArray array];
    
    [self buildUI];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    if ([UserInfoUDManager isLogin]){
        self.loginView.hidden = YES;
        [self requestHistoryData];
        [self requestYouWantToFindData];
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
    [[[AppAPIHelper shareInstance] getSearchAPI] postDelHistorySearchKeywordsSuccess:^(id data) {
      
        [self requestHistoryData];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 请求历史记录
-(void)requestHistoryData
{
    [[[AppAPIHelper shareInstance] getSearchAPI] getHistorySearchKeywordsSuccess:^(id data) {
        
        self.arrayHistory = [NSArray arrayWithArray:[data objectForKey:@"searchKeywords"]];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark - 请求猜你想找
-(void)requestYouWantToFindData
{
    [[[AppAPIHelper shareInstance] getSearchAPI] getGuessYouWantToFindSuccess:^(id data) {
        
        self.arrayYouWantTofindTitle = [NSString stringWithFormat:@"%@",[data objectForKey:@"title"]];

        self.arrayYouWantTofind = [NSArray arrayWithArray:[data objectForKey:@"wantToFindKeywords"]];
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
    _collectionView.alwaysBounceVertical = YES;//当数据不足，也能滑动
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;//收缩键盘
    [self.view addSubview:_collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    //注册
    [_collectionView registerNib:[UINib nibWithNibName:@"SearchCollectionViewCell"bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"TitleCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
   
    //ihponeX
    [self.stateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_STATEBAR);
    }];
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (section == 0){
        return self.arrayHistory.count;
    }else if (section == 1){
        return self.arrayYouWantTofind.count;
    }
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    if (indexPath.section == 0){
        
        return [self jl_SizeWidthWithStr:self.arrayHistory[indexPath.row]];
    }else if (indexPath.section == 1){
        
        return [self jl_SizeWidthWithStr:self.arrayYouWantTofind[indexPath.row]];
    }
    return CGSizeZero;
}
//计算所需宽度（数据多的页面最好把高度缓存到model中,滑动复用时不需要每次计算）
-(CGSize)jl_SizeWidthWithStr:(NSString*)str
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, LCDScale_5Equal6_To6plus(25.f)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    CGFloat Width = rect.size.width;
    if (rect.size.width > LCDW-self.flowLayout.sectionInset.left-self.flowLayout.sectionInset.right-25.f) {
        Width = LCDW-self.flowLayout.sectionInset.left-self.flowLayout.sectionInset.right;
    }else{
        Width = ceilf(Width+25.f);
    }
    return CGSizeMake(Width,LCDScale_5Equal6_To6plus(25.f));
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    if (self.arrayHistory.count == 0 && section == 0) {
        return CGSizeZero;
    }
    if (self.arrayYouWantTofind.count == 0 && section == 1) {
        return CGSizeZero;
    }
    return CGSizeMake(LCDW-40, 30+15+8);

}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, LCDW-40-40, 30)];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textColor = [WYUISTYLE colorWithHexString:@"B1B1B1"];
    [view addSubview:label];
    
    if (indexPath.section == 0) {
        label.text = @"历史搜索";
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(LCDW-50, 15, 40, 30)];
//        btn.backgroundColor = [UIColor redColor];
        [btn setImage:[UIImage imageNamed:@"searchDele"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickAllDele:)forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    if (self.arrayYouWantTofindTitle &&indexPath.section == 1) {
        label.text = self.arrayYouWantTofindTitle;
    }
    
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TitleCell" forIndexPath:indexPath];
    cell.traling.constant = 0;
    cell.leading.constant = 0;
    if (indexPath.section == 0) {
        cell.titleLabel.text = self.arrayHistory[indexPath.row];

    }else if (indexPath.section == 1){
        cell.titleLabel.text = self.arrayYouWantTofind[indexPath.row];

    }
    cell.contentView.layer.cornerRadius = cell.frame.size.height/2;
    return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sousuoTextfild resignFirstResponder];

    SearchCollectionViewCell* cell = (SearchCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString* searchKeyword = [NSString stringWithFormat:@"%@",cell.titleLabel.text];
    if (indexPath.section == 0) {
        [self PushSearchDeatilWithSearchKeyword:searchKeyword keywordType:0];
    }else if (indexPath.section == 1){
        [self PushSearchDeatilWithSearchKeyword:searchKeyword keywordType:2];

    }
    
}

#pragma mark - 跳转搜索详情
/**
 @param searchKeyword //搜索关键词，类目搜索的情况设置为类目名称
 @param keywordType //关键词类型 0-搜索 1-类目 2-产品(猜你想找)
 */
-(void)PushSearchDeatilWithSearchKeyword:(NSString*)searchKeyword keywordType:(NSInteger)keywordType
{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(jl_willDismissSearchViewController:keywordType:searchKeyword:)]) {
        [self.delegate jl_willDismissSearchViewController:self keywordType:keywordType searchKeyword:searchKeyword];
    }
    [self dismissViewControllerAnimated:NO completion:^{
        
        if (self.delegate&& [self.delegate respondsToSelector:@selector(jl_didDismissSearchViewController:)]) {
            [self.delegate jl_didDismissSearchViewController:self];
        }
    }];
    
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
        NSString* str = textField.text;//海獭说越狱可能出问题，那就再验证一次
        if (str.length >=20) {
            str = [str substringToIndex:20];
        }
        [self PushSearchDeatilWithSearchKeyword:str keywordType:0];
    }
    return YES;
}
#pragma mark － string用户输入的单个字符，range 字符插入的位置
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>= 20)
    {
        textField.text = [textField.text substringToIndex:20];
        return NO;
    }
    return YES;
}

/*------------*/
#pragma mark - Actions
#pragma mark - 点击取消按钮
- (IBAction)quxiaoBtnClick:(UIButton *)sender {
    [self.sousuoTextfild resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (self.delegate&& [self.delegate respondsToSelector:@selector(jl_didDismissSearchViewController:)]) {
            [self.delegate jl_didDismissSearchViewController:self];
        }
    }];
}
- (IBAction)loginBtnClick:(UIButton *)sender {
    [self xm_performIsLoginActionWithPopAlertView:NO];
    
}
-(void)dealloc
{
    NSLog(@"dealloc SearchViewController");
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
