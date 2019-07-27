//
//  SearchDetailScreenController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/9/14.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SearchDetailScreenController.h"

#import "UICollectionViewLeftAlignedLayout.h"
#import "SearchCollectionViewCell.h"

#import "SearchModel.h"

@interface SearchDetailScreenController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZXEmptyViewControllerDelegate>

@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)UICollectionViewLeftAlignedLayout *flowLayout;

@property(nonatomic,strong)NSArray*locationsArrayModel; //所在地，市场区域
@property(nonatomic,strong)NSArray*catesArrayModel;     //类目
@property(nonatomic,strong)NSArray*productSourcesArrayModel; //货源类型(现货，定做）

@property(nonatomic,strong)UIView* whiteView;

//用户当前所有选中的indexpaths
@property(nonatomic,strong)NSMutableArray*arrayCurrySelectedIndexPath;
//用户当前此次操作之前选中的indexpaths
@property(nonatomic,strong)NSMutableArray*arrayIndexPathsLast;

@property(nonatomic,strong)ZXEmptyViewController* emptyViewController; //氛围图

@property(nonatomic,strong)SearchScreenModel * searchScreenModel;
@end

@implementation SearchDetailScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setData];
    
    [self buildUI];
    
    [self requestSearchGetFilterConditionsURL];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_emptyViewController) {
        [_emptyViewController hideEmptyViewInController:self];
        [self requestSearchGetFilterConditionsURL];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    CGRect frame = _whiteView.frame;
    frame.origin.x = LCDW;
    _whiteView.frame = frame;
    
    self.view.userInteractionEnabled = NO;//平移中不允许操作
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _whiteView.frame;
        frame.origin.x = 95.f/375.f*LCDW;
        _whiteView.frame = frame;

        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
    
    
}
#pragma mark - 请求筛选类目数据
//@param type 筛选条件类型 0-产品 1-商铺
//@param searchKeyword 搜索关键词，类目搜索的情况设置为类目名称
//@param keywordType 关键词类型 0-搜索 1-类目 2-产品（猜你想找)
//@param catId 类目id（只有在类目搜索的情况下才需要设置，其他情况为空）
//@param authStatus 认证状态 0-未认证 1-已认证，未设置的情况默认为1
-(void)requestSearchGetFilterConditionsURL
{
    [[[AppAPIHelper shareInstance] getSearchAPI] getSearchGetFilterConditionsURLWithType:self.type searchKeyword:self.searchKeyword keywordType:self.keywordType catId:self.catId authStatus:self.authStatus Success:^(id data) {
        
        [_emptyViewController hideEmptyViewInController:self];
        _emptyViewController = nil;
        
        SearchScreenModel * sModel = (SearchScreenModel *)data;
        self.searchScreenModel = sModel;

        self.locationsArrayModel = [NSArray arrayWithArray:self.searchScreenModel.locations];
        self.catesArrayModel = [NSArray arrayWithArray:self.searchScreenModel.cates];
        self.productSourcesArrayModel = [NSArray arrayWithArray:self.searchScreenModel.productSources];
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        [_whiteView addSubview: self.emptyViewController.view];//调整父视图、移除时随着动画一起
    }];
}
#pragma mark 懒加载氛围图
-(ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        ZXEmptyViewController *emptyViewController = [[ZXEmptyViewController alloc] init];
        emptyViewController.delegate = self;
        emptyViewController.view.frame = _whiteView.bounds;
        emptyViewController.view.zx_height-=51.f;
        _emptyViewController = emptyViewController;
    }return _emptyViewController;
}
-(void)zxEmptyViewUpdateAction
{
    [self requestSearchGetFilterConditionsURL];
}
-(void)setData
{
    self.locationsArrayModel = [NSArray array];
    self.catesArrayModel = [NSArray array];
    self.productSourcesArrayModel = [NSArray array];
    
    
    self.arrayIndexPathsLast = [NSMutableArray array];
    self.arrayCurrySelectedIndexPath = [NSMutableArray array];
}
-(void)buildUI
{
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    
    _whiteView = [[UIView alloc] init ];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(95.f/375.f*LCDW);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    
    _flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.minimumLineSpacing = 20;
    _flowLayout.minimumInteritemSpacing = 15;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20,_whiteView.frame.size.width, _whiteView.frame.size.height-50.f-20.f) collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_whiteView addSubview:_collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.whiteView);
        make.right.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.view).offset(HEIGHT_STATEBAR);
        make.bottom.mas_equalTo(self.whiteView).offset(-50-HEIGHT_TABBAR_SAFE);
        
    }];
    
    //注册
    [_collectionView registerNib:[UINib nibWithNibName:@"SearchCollectionViewCell"bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"TitleCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    UIButton* quxiaoBtn = [[UIButton alloc] init];
    [quxiaoBtn addTarget:self action:@selector(quxiaoClcik:) forControlEvents:UIControlEventTouchUpInside];
    [quxiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
    quxiaoBtn.backgroundColor = [UIColor whiteColor];
    [quxiaoBtn setTitleColor:[WYUISTYLE colorWithHexString:@"999999"] forState:UIControlStateNormal];
    quxiaoBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    quxiaoBtn.layer.masksToBounds = YES;
    quxiaoBtn.layer.cornerRadius = 15.f;
    quxiaoBtn.layer.borderWidth = 0.5;
    quxiaoBtn.layer.borderColor = [WYUISTYLE colorWithHexString:@"999999"].CGColor;
    [_whiteView addSubview:quxiaoBtn];
    
    UIButton* wanchenBtn = [[UIButton alloc] init];
    [wanchenBtn addTarget:self action:@selector(wanchengClcik:) forControlEvents:UIControlEventTouchUpInside];
    [wanchenBtn setTitle:@"完成" forState:UIControlStateNormal];
    wanchenBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    wanchenBtn.layer.masksToBounds = YES;
    wanchenBtn.layer.cornerRadius = 15.f;
    [wanchenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_whiteView addSubview:wanchenBtn];
    [quxiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.whiteView).offset(10.f);
        make.height.mas_equalTo(30.f);
        make.bottom.mas_equalTo(self.whiteView).offset(-10.f-HEIGHT_TABBAR_SAFE);
        
    }];
    [wanchenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(quxiaoBtn.mas_right).offset(10.f);
        make.width.mas_equalTo(quxiaoBtn.mas_width);
        make.height.mas_equalTo(30.f);
        make.right.mas_equalTo(self.whiteView).offset(-10);
        make.bottom.mas_equalTo(self.whiteView).offset(-10.f-HEIGHT_TABBAR_SAFE);
    }];
    [self.view layoutIfNeeded];
    UIImage* baimg = [WYUISTYLE imageWithStartColorHexString:@"FFBA49" EndColorHexString:@"FF8D31" WithSize:wanchenBtn.bounds.size];
    [wanchenBtn setBackgroundImage:baimg forState:UIControlStateNormal];
    
    UIView* line = [[UIView alloc] init];
    line.backgroundColor = [WYUISTYLE colorWithHexString:@"E5E5E5"];
    [_whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.whiteView);
        make.right.mas_equalTo(self.whiteView);
        make.height.mas_equalTo(0.5f);
        make.bottom.mas_equalTo(quxiaoBtn.mas_top).offset(-10.f);
    }];
    
}
#pragma mark --
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section == 0){
        return self.catesArrayModel.count;
    }
    else if (section == 1){
        return self.locationsArrayModel.count;
    }
    else if (section == 2){
        return self.productSourcesArrayModel.count;
    }
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0){
        if (self.catesArrayModel.count>0) {
            SearchCatesModel* model = self.catesArrayModel[indexPath.row];
            return [self jl_SizeWidthWithStr:model.name];
        }
        return CGSizeZero;
    }
    else if (indexPath.section == 1){
        if (self.locationsArrayModel.count>0) {
            SearchLocationsModel* model = self.locationsArrayModel[indexPath.row];
            return [self jl_SizeWidthWithStr:model.name];
        }
        return CGSizeZero;
    }
    else if (indexPath.section == 2){
        if (self.productSourcesArrayModel.count>0) {
            SearchProductSourcesModel* model = self.productSourcesArrayModel[indexPath.row];
            return [self jl_SizeWidthWithStr:model.name];
        }
        return CGSizeZero;
    }
    return CGSizeZero;
}
//计算所需宽度
-(CGSize)jl_SizeWidthWithStr:(NSString*)str
{
    CGFloat MaxW = self.collectionView.frame.size.width-27.f-25.f;
    CGFloat MinH = LCDScale_5Equal6_To6plus(25.f);
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setMinimumLineHeight:MinH];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f],NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    CGFloat Width = ceilf(rect.size.width+25.f);
    CGFloat Height = ceilf(rect.size.height);
    return CGSizeMake(Width,Height);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.catesArrayModel.count == 0 && section == 0) {
        return CGSizeZero;
    }
    if (self.locationsArrayModel.count == 0 && section == 1) {
        return CGSizeZero;
    }
    if (self.productSourcesArrayModel.count == 0 && section == 2) {
        return CGSizeZero;
    }
    return CGSizeMake(self.collectionView.frame.size.width, 30+10+8);
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
        return  UIEdgeInsetsMake(0, 10, 20, 17);
    }
    return  UIEdgeInsetsMake(0, 10, 0, 17);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView* imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10,16.5,3,15)];
    imageV.image = [UIImage imageNamed:@"searchshaixuanLine"];
    [view addSubview:imageV];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(21, 10, _collectionView.frame.size.width-20, 30)];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textColor = [WYUISTYLE colorWithHexString:@"2F2F2F"];
    [view addSubview:label];
    
    if (self.catesArrayModel.count>0 && indexPath.section == 0) {
        label.text = @"类目选择";
    }
    if (self.locationsArrayModel.count>0 && indexPath.section == 1) {
        label.text = @"所在地";
    }
    if (self.productSourcesArrayModel.count>0 && indexPath.section == 2) {
        label.text = @"货源类型";
    }
    
    return view;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TitleCell" forIndexPath:indexPath];
    cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.section == 1)
    {
        
        SearchLocationsModel* model = self.locationsArrayModel[indexPath.row];
        cell.titleLabel.text = model.name;
        [cell.titleLabel jl_setAttributedText:nil withMinimumLineHeight:15.6];
    }
    else if (indexPath.section == 0)
    {
        
        SearchCatesModel* model = self.catesArrayModel[indexPath.row];
        cell.titleLabel.text = model.name;
        [cell.titleLabel jl_setAttributedText:nil withMinimumLineHeight:15.6];
        if ([self jl_SizeWidthWithStr:model.name].height>LCDScale_5Equal6_To6plus(25.f)) {
            cell.titleLabel.textAlignment = NSTextAlignmentLeft;
            [cell.titleLabel jl_setAttributedText:nil withMinimumLineHeight:18];
        }
    }
    else if (indexPath.section == 2)
    {
        SearchProductSourcesModel* model = self.productSourcesArrayModel[indexPath.row];
        cell.titleLabel.text = model.name;
        [cell.titleLabel jl_setAttributedText:nil withMinimumLineHeight:15.6];
    }
    
    cell.curryState = SearchCollectionViewCellTypeDafault;
    //当前选中数据
    if ([self.arrayCurrySelectedIndexPath containsObject:indexPath]) {
        cell.curryState = SearchCollectionViewCellTypeSelected;
    }
    
    cell.contentView.layer.cornerRadius = 12.5;
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell* cell = (SearchCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
   
    if (cell.curryState == SearchCollectionViewCellTypeSelected)
    {
        [self.arrayCurrySelectedIndexPath removeObject:indexPath];//
    }
    else
    {
        //货源类型单选，如果点击的是第二组货源类型，先删除第二组已选中
        if (indexPath.section == 2) {
            NSArray*arrayCurrySelectedIndexPath_copy = [NSArray arrayWithArray:self.arrayCurrySelectedIndexPath];
            for (NSIndexPath* indexPathppp in arrayCurrySelectedIndexPath_copy) {
                if (indexPathppp.section == 2) {
                    [self.arrayCurrySelectedIndexPath removeObject:indexPathppp];
                }
            }
        }
        
        [self.arrayCurrySelectedIndexPath addObject:indexPath];
    }
    [self.collectionView reloadData];//自定义刷新设置为选中状态
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_SearchDetailScreenControllerDidSelectItem:)]) {
        [self.delegate jl_SearchDetailScreenControllerDidSelectItem:self];
    }
}
#pragma mark - =============
#pragma mark - 取消
-(void)quxiaoClcik:(UIButton*)sender
{
    [self cancelDismiss];
}
#pragma mark - 完成
-(void)wanchengClcik:(UIButton*)sender
{
    if (!_searchScreenModel)
    {//数据未初始化或初始化为空
        return;
    }
    
    //将当前所有选中设置为用户上次选中
    self.arrayIndexPathsLast = [NSMutableArray arrayWithArray:self.arrayCurrySelectedIndexPath];
    
    //","拼接类目id、所在地id
    NSMutableArray* arrayL = [NSMutableArray array];
    NSMutableArray* arrayC = [NSMutableArray array];
    //货源类型:默认全部
    _productSourceType = WYSearchProductTypeQuanBu;
    for (NSIndexPath* indexPath in self.arrayCurrySelectedIndexPath) {
        if (indexPath.section == 0)
        {
            SearchCatesModel* model = self.catesArrayModel[indexPath.row];
            [arrayC addObject:model.iid];
        }
        else if (indexPath.section == 1) {
            SearchLocationsModel* model = self.locationsArrayModel[indexPath.row];
            [arrayL addObject:model.iid];
        }
        else if (indexPath.section == 2){
            SearchProductSourcesModel* model = self.productSourcesArrayModel[indexPath.row];
            _productSourceType = model.iid.integerValue;   //货源类型
        }
    }
    
    _currySubmarketIdFilter = [arrayL componentsJoinedByString:@","];
    _curryCatIdFilter = [arrayC componentsJoinedByString:@","];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_SearchDetailScreenControllerTouchCompleteButton:)]) {
        [self.delegate jl_SearchDetailScreenControllerTouchCompleteButton:self];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_SearchDetailScreenControllerWillRemove:)]) {
        [self.delegate jl_SearchDetailScreenControllerWillRemove:self];
    }
    
    self.view.userInteractionEnabled = NO;//平移中不允许操作
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _whiteView.frame;
        frame.origin.x = LCDW;
        _whiteView.frame = frame;
        
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}
#pragma mark - 点击背景
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //指定某块区域点击移除
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    BOOL bo = CGRectContainsPoint(CGRectMake(0,0, 95.f/375.f*LCDW, LCDH), point);
    if (bo) {
        [self cancelDismiss];
    }
}
-(void)cancelDismiss
{
    //将用户选中条件置为上次选中的
    self.arrayCurrySelectedIndexPath = [NSMutableArray arrayWithArray:self.arrayIndexPathsLast];
    [self.collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_SearchDetailScreenControllerWillRemove:)]) {
        [self.delegate jl_SearchDetailScreenControllerWillRemove:self];
    }
    
    self.view.userInteractionEnabled = NO;//平移中不允许操作
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _whiteView.frame;
        frame.origin.x = LCDW;
        _whiteView.frame = frame;
        
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}
-(BOOL)isHaveData{
    BOOL bo = self.arrayCurrySelectedIndexPath.count >0;
    return bo;
}
@end
