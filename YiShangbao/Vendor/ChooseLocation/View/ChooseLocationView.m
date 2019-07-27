//
//  ChooseLocationView.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ChooseLocationView.h"
#import "AddressView.h"
#import "UIView+Frame.h"
#import "AddressTableViewCell.h"
#import "AddressItem.h"
#import "CitiesDataTool.h"


static NSString * const ZXDefaultTitle =@"请选择类目";
static NSString * const ZXDefaultSubTitle =@"请谨慎选择类目，选错类目可能导致产品搜索不到";

#define HYScreenW [UIScreen mainScreen].bounds.size.width

static  CGFloat  const  kHYTopViewHeight = 40; //顶部视图的高度
static  CGFloat  const  kHYTopTabbarHeight = 30; //地址标签栏的高度

@interface ChooseLocationView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,weak) AddressView * topTabbar;
@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,weak) UIView * underLine;
@property (nonatomic,strong) NSArray * dataSouce;
@property (nonatomic,strong) NSArray * cityDataSouce;
@property (nonatomic,strong) NSArray * districtDataSouce;

//管理3个tableView
@property (nonatomic,strong) NSMutableArray * tableViews;
//管理顶部提示已选择
@property (nonatomic,strong) NSMutableArray * topTabbarItems;
@property (nonatomic,weak) UIButton * selectedBtn;

@property (nonatomic, strong)NSMutableArray *mIndexSetArray;


@end

@implementation ChooseLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

//修改这个第三方
- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - setUp UI

- (void)setUp{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,  kHYTopViewHeight * 2)];
    [self addSubview:topView];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = ZXDefaultTitle;
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.centerY = topView.height * 0.3;
    titleLabel.centerX = topView.width * 0.5;
    
    UILabel *subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.textColor = [UIColor redColor];
    subTitleLabel.font = [UIFont systemFontOfSize:13.0];
    subTitleLabel.text = ZXDefaultSubTitle;
    [subTitleLabel sizeToFit];
    [topView addSubview:subTitleLabel];
    subTitleLabel.centerY = topView.height * 0.8;
    subTitleLabel.centerX = topView.width * 0.5;
    
    //分割线1
    UIView * separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.top = topView.height - separateLine.height;
    topView.backgroundColor = [UIColor whiteColor];

    //添加展示已选视图
    AddressView * topTabbar = [[AddressView alloc]initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    
    [self addTopBarItem];
    
    //分割线2
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.top = topTabbar.height - separateLine.height;
    [_topTabbar layoutIfNeeded];
    topTabbar.backgroundColor = [UIColor whiteColor];
    
    //提示底条
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;
    _underLine.backgroundColor = [UIColor redColor];
    
    //添加scrollView
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - kHYTopViewHeight - kHYTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(HYScreenW, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    
    //添加tableView
    [self addTableView];
    _contentView.delegate = self;
    
    NSMutableIndexSet *mIndexSet1 = [[NSMutableIndexSet alloc] init];
    NSMutableIndexSet *mIndexSet2 = [[NSMutableIndexSet alloc] init];
    NSMutableIndexSet *mIndexSet3 = [[NSMutableIndexSet alloc] init];
    NSArray *indexArray = @[mIndexSet1,mIndexSet2,mIndexSet3];
    
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    self.mIndexSetArray = mArray;
    
    [self.mIndexSetArray addObjectsFromArray:indexArray];
    
    [self requestSystCategoryList];
}

- (void)requestSystCategoryList
{
//    [self zhHUD_showHUDAddedTo:self.view labelText:@"正在加载"];
    [ProductMdoleAPI getProductSystemCatesWithCateId:nil levelId:@(2) success:^(id data) {
        
//        [self zhHUD_hideHUD];
        self.dataSouce = [data copy];
        [[self.tableViews objectAtIndex:0] reloadData];
        
    } failure:^(NSError *error) {
        
//        [self zhHUD_hideHUD];
        
    }];
}




- (void)addTableView{

    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * HYScreenW, 0, HYScreenW, _contentView.height)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [tabbleView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
}

- (void)addTopBarItem{
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    [topBarItem setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [topBarItem sizeToFit];
     topBarItem.centerY = _topTabbar.height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        return self.dataSouce.count;
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        return self.cityDataSouce.count;
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        return self.districtDataSouce.count;
    }
    return self.dataSouce.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AddressItem * item;
    //省级别
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        item = self.dataSouce[indexPath.row];
    //市级别
    }else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        item = self.cityDataSouce[indexPath.row];
    //县级别
    }else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        item = self.districtDataSouce[indexPath.row];
    }
    cell.item = item;
    return cell;
}

#pragma mark - TableViewDelegate
/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        
        //点击省的时候，获取城市数据
        //1.1 获取下一级别的数据源(市级别,如果是直辖市时,下级则为区级别)
        AddressItem * provinceItem = self.dataSouce[indexPath.row];

        
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_queue_create("com.gcd-group.www", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_enter(group);
        NSLog(@"%@",[NSThread currentThread]);
        [ChooseLocationView getProductSystemCatesWithCateId:provinceItem.cateId levelId:@(3) success:^(id data) {
            
            self.cityDataSouce = [data copy];
            
            if(self.cityDataSouce.count == 0)
            {
                for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                    [self removeLastItem];
                }
                [self setUpAddress:provinceItem.name];
                dispatch_group_leave(group);
            }
            else
            {
                //1.1 判断是否是第一次选择,不是,则重新选择省,切换省.
                //由于从请求回来之前已经选中；所以这个方法已经不能再作为判断了；
                NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
                //                static NSIndexPath *indexPath0 ;
                
                if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0)
                {
                    
                    for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++)
                    {
                        [self removeLastItem];
                    }
                    [self addTopBarItem];
                    [self addTableView];
                    [self scrollToNextItem:provinceItem.name];
                    
                    dispatch_group_leave(group);
                }
                else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0)
                {
                    
                    for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1 ; i++)
                    {
                        [self removeLastItem];
                    }
                    [self addTopBarItem];
                    [self addTableView];
                    [self scrollToNextItem:provinceItem.name];
                    dispatch_group_leave(group);
                }
                else
                {
                    //之前未选中省，第一次选择省
                    [self addTopBarItem];
                    [self addTableView];
                    AddressItem * item = self.dataSouce[indexPath.row];
                    [self scrollToNextItem:item.name ];
                    dispatch_group_leave(group);
                }
            }
            

            
        } failure:^(NSError *error) {
            
        }];
      
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        return indexPath;
      
        
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        
        AddressItem * cityItem = self.cityDataSouce[indexPath.row];
//        self.districtDataSouce = [[CitiesDataTool sharedManager] queryAllRecordWithShengID:cityItem.sheng cityID:cityItem.di];
        [ProductMdoleAPI getProductSystemCatesWithCateId:cityItem.cateId levelId:@(4) success:^(id data) {
            
           self.districtDataSouce = [data copy];
            //        [self zhHUD_hideHUD];
            //由于是异步请求处理，所以会造成已经选中的问题
//            NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
            static NSIndexPath *indexPath0 ;

            if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0)
            {
                
                for (int i = 0; i < self.tableViews.count - 1; i++) {
                    [self removeLastItem];
                }
                [self addTopBarItem];
                [self addTableView];
                [self scrollToNextItem:cityItem.name];
                indexPath0 = indexPath;
                return ;
//                return indexPath;
                
            }
            else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0)
            {

                [self scrollToNextItem:cityItem.name];
                indexPath0 = indexPath;

                return ;
//                return indexPath;
            }
            else
            {
                [self addTopBarItem];
                [self addTableView];
                AddressItem * item = self.cityDataSouce[indexPath.row];
                [self scrollToNextItem:item.name];
                indexPath0 = indexPath;

            }
            
        } failure:^(NSError *error) {
            
            //  [self zhHUD_hideHUD];
            
        }];
        return nil;

    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        AddressItem * item = self.districtDataSouce[indexPath.row];
        [self setUpAddress:item.name];
    }
    return indexPath;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    AddressItem * item;
    NSInteger tableIndex = [self.tableViews indexOfObject:tableView];
    
    if(tableIndex == 0)
    {
        NSMutableIndexSet *mIndexSet = [self.mIndexSetArray objectAtIndex:tableIndex];

        //点击省的时候，获取城市数据
        //1.1 获取下一级别的数据源(市级别,如果是直辖市时,下级则为区级别)
        AddressItem * addressItem = self.dataSouce[indexPath.row];
        
        [ProductMdoleAPI getProductSystemCatesWithCateId:addressItem.cateId levelId:@(3) success:^(id data) {
            
        
            self.cityDataSouce = [data copy];
            
            if(self.cityDataSouce.count == 0)
            {
                for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                    [self removeLastItem];
                }
                [self.mIndexSetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSMutableIndexSet *set = (NSMutableIndexSet *)obj;
                    [set removeAllIndexes];
                    
                }];
                [self setUpAddress:addressItem];
            }
            else
            {
                if (mIndexSet.count>0)
                {
                    NSInteger index = [mIndexSet firstIndex];
                    //如果是同一个
                    if (indexPath.row ==index)
                    {
                        [self scrollToNextItem:addressItem.name];
                    }
                    else
                    {
                        for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++)
                        {
                            [self removeLastItem];
                        }
                        [self.mIndexSetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            NSMutableIndexSet *set = (NSMutableIndexSet *)obj;
                            [set removeAllIndexes];
                            
                        }];
                        [self addTopBarItem];
                        [self addTableView];
                        [self scrollToNextItem:addressItem.name];
                    }
                }
                else
                {
                    //之前未选中省，第一次选择省
                    [self addTopBarItem];
                    [self addTableView];
                    [self scrollToNextItem:addressItem.name ];
                }
            }
            //更新选中的 项，移除以前的，添加最新选中的；
            if (mIndexSet.count>0)
            {
                [mIndexSet removeAllIndexes];
            }
            [mIndexSet addIndex:indexPath.row];
            NSLog(@"table1  =  %ld,mIndexSet=%ld",[[self.mIndexSetArray objectAtIndex:0] firstIndex],mIndexSet.firstIndex);
            
        } failure:^(NSError *error) {
            
            
        }];
    }
    
    else if (tableIndex == 1)
    {
        NSMutableIndexSet *mIndexSet2 = [self.mIndexSetArray objectAtIndex:tableIndex];
        AddressItem * addressItem = self.cityDataSouce[indexPath.row];
        
        [ProductMdoleAPI getProductSystemCatesWithCateId:addressItem.cateId levelId:@(4) success:^(id data) {
            
            self.districtDataSouce = [data copy];
            //        [self zhHUD_hideHUD];
            //由于是异步请求处理，所以会造成已经选中的问题
            if(self.districtDataSouce.count == 0)
            {
                for (int i = 0; i < self.tableViews.count && self.tableViews.count != 2; i++)
                {
                        [self removeLastItem];
                }
                NSLog(@"%ld",self.tableViews.count);
                [self.mIndexSetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (idx==1 || idx==2) {
                        
                        NSMutableIndexSet *set = (NSMutableIndexSet *)obj;
                        [set removeAllIndexes];
                    }
                }];

                [self setUpAddress:addressItem];
            }
            else
            {
                if (mIndexSet2.count>0)
                {
                    NSLog(@"mIndexSet2.count=%ld",mIndexSet2.count);
                    NSInteger index = [mIndexSet2 firstIndex];
                    if (indexPath.row ==index)
                    {
                        [self scrollToNextItem:addressItem.name];
                    }
                    else
                    {
                        NSLog(@"%ld",self.tableViews.count);
                        for (int i = 0; i < self.tableViews.count - 1&& self.tableViews.count != 2; i++)
                        {
                            [self removeLastItem];
                        }
                        [self.mIndexSetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            if (idx==1 || idx==2) {
                                
                                NSMutableIndexSet *set = (NSMutableIndexSet *)obj;
                                [set removeAllIndexes];
                            }
                        }];

                        [self addTopBarItem];
                        [self addTableView];
                        [self scrollToNextItem:addressItem.name];
                        
                    }
                }
                else
                {
                    [self addTopBarItem];
                    [self addTableView];
                    [self scrollToNextItem:addressItem.name];
                }

            }
            if (mIndexSet2.count>0)
            {
                [mIndexSet2 removeAllIndexes];
            }
            [mIndexSet2 addIndex:indexPath.row];
            
            NSLog(@"table2  =  %ld,mIndexSet=%ld",[[self.mIndexSetArray objectAtIndex:1] firstIndex],mIndexSet2.firstIndex);

            
        } failure:^(NSError *error) {
            
            //  [self zhHUD_hideHUD];
        }];
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        AddressItem * item = self.districtDataSouce[indexPath.row];
//        [self setUpAddress:item.name];
        [self setUpAddress:item];
    }
    
    
    AddressItem * item;
    if([self.tableViews indexOfObject:tableView] == 0)
    {
       item = self.dataSouce[indexPath.row];
    }
    else if([self.tableViews indexOfObject:tableView] == 1)
    {
       item = self.cityDataSouce[indexPath.row];
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
       item = self.districtDataSouce[indexPath.row];
    }
    item.isSelected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressItem * item;
    if([self.tableViews indexOfObject:tableView] == 0){
        item = self.dataSouce[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        item = self.cityDataSouce[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        item = self.districtDataSouce[indexPath.row];
    }
    item.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}



#pragma mark - private 

//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn{
    
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * HYScreenW, 0);
        [self changeUnderLineFrame:btn];
    }];
}

//调整指示条位置
- (void)changeUnderLineFrame:(UIButton  *)btn{
    
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    _underLine.left = btn.left;
    _underLine.width = btn.width;
}

//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(AddressItem *)cateModel{

    self.chooseItem = cateModel;
    
    NSString *address = cateModel.name;
    
    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:address forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [self changeUnderLineFrame:btn];
    
//    self.address = address;
    
    NSMutableString * addressStr = [[NSMutableString alloc] init];
    for (UIButton * btn  in self.topTabbarItems) {
        if ([btn.currentTitle isEqualToString:@"县"] || [btn.currentTitle isEqualToString:@"市辖区"] ) {
            continue;
        }
        [addressStr appendString:btn.currentTitle];
        [addressStr appendString:@"/"];
    }
    if([addressStr rangeOfString:@"/" options:NSBackwardsSearch].location!=NSNotFound)
    {
        NSRange range = [addressStr rangeOfString:@"/" options:NSBackwardsSearch];
        [addressStr replaceCharactersInRange:range withString:@""];
    }
    self.address = addressStr;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        if (self.chooseFinish) {
            self.chooseFinish();
        }
    });
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem{

    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle{
    
    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.contentSize = (CGSize){self.tableViews.count * HYScreenW,0};
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + HYScreenW, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
    }];
}


#pragma mark - 开始就有地址时.

- (void)setAreaCode:(NSString *)areaCode{
    
    _areaCode = areaCode;
    //2.1 添加市级别,地区级别列表
    [self addTableView];
    [self addTableView];

    self.cityDataSouce = [[CitiesDataTool sharedManager] queryAllRecordWithShengID:[self.areaCode substringWithRange:(NSRange){0,2}]];
    self.districtDataSouce = [[CitiesDataTool sharedManager] queryAllRecordWithShengID:[self.areaCode substringWithRange:(NSRange){0,2}] cityID:[self.areaCode substringWithRange:(NSRange){2,2}]];//
  
    //2.3 添加底部对应按钮
    [self addTopBarItem];
    [self addTopBarItem];
    
    NSString * code = [self.areaCode stringByReplacingCharactersInRange:(NSRange){2,4} withString:@"0000"];
    NSString * provinceName = [[CitiesDataTool sharedManager] queryAllRecordWithAreaCode:code];
    UIButton * firstBtn = self.topTabbarItems.firstObject;
    [firstBtn setTitle:provinceName forState:UIControlStateNormal];
    
    NSString * cityName = [[CitiesDataTool sharedManager] queryAllRecordWithAreaCode:[self.areaCode stringByReplacingCharactersInRange:(NSRange){4,2} withString:@"00"]];
    UIButton * midBtn = self.topTabbarItems[1];
    [midBtn setTitle:cityName forState:UIControlStateNormal];
    
     NSString * districtName = [[CitiesDataTool sharedManager] queryAllRecordWithAreaCode:self.areaCode];
    UIButton * lastBtn = self.topTabbarItems.lastObject;
    [lastBtn setTitle:districtName forState:UIControlStateNormal];
    [self.topTabbarItems makeObjectsPerformSelector:@selector(sizeToFit)];
    [_topTabbar layoutIfNeeded];
    
    
    [self changeUnderLineFrame:lastBtn];
    
    //2.4 设置偏移量
    self.contentView.contentSize = (CGSize){self.tableViews.count * HYScreenW,0};
    CGPoint offset = self.contentView.contentOffset;
    self.contentView.contentOffset = CGPointMake((self.tableViews.count - 1) * HYScreenW, offset.y);

    [self setSelectedProvince:provinceName andCity:cityName andDistrict:districtName];
}

//初始化选中状态
- (void)setSelectedProvince:(NSString *)provinceName andCity:(NSString *)cityName andDistrict:(NSString *)districtName {
    
    for (AddressItem * item in self.dataSouce) {
        if ([item.name isEqualToString:provinceName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.dataSouce indexOfObject:item] inSection:0];
            UITableView * tableView  = self.tableViews.firstObject;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i < self.cityDataSouce.count; i++) {
        AddressItem * item = self.cityDataSouce[i];
        
        if ([item.name isEqualToString:cityName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViews[1];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i <self.districtDataSouce.count; i++) {
        AddressItem * item = self.districtDataSouce[i];
        if ([item.name isEqualToString:districtName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViews[2];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
}

#pragma mark - getter 方法

//分割线
- (UIView *)separateLine{
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    return separateLine;
}

- (NSMutableArray *)tableViews{
    
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems{
    if (_topTabbarItems == nil) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}


//+ (void)getProductSystemCatesWithCateId:(NSNumber *)cateId levelId:(NSNumber *)level success:(CompleteBlock)success failure:(ErrorBlock)failure
//{
//    NSDictionary * parameters = @{
//                                  @"id":cateId,
//                                  @"level":level
//                                  };
//    
//    [self getRequest:kProduct_sysCates parameters:parameters success:^(id data) {
//        
//        NSError *__autoreleasing *error = nil;
//        NSArray *array = [MTLJSONAdapter modelsOfClass:[AddressItem class] fromJSONArray:data error:error];
//        if (error){
//            if (failure) failure(*error);
//        }else
//        {
//            success(array);
//        }
//    } failure:^(NSError *error) {
//        if (failure)
//        {
//            failure(error);
//        }
//    }];
//    
//}
//
//+(void) getRequest:(NSString *)path parameters:(NSDictionary *)parameter success:(CompleteBlock)success failure:(ErrorBlock)failure
//{
//   
//    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/m?",kAPP_BaseURL];
//    NSDictionary *par = [[BaseHttpAPI alloc] addRequestPostData:[parameter mutableCopy] apiName:kProduct_sysCates];
//    [par enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        
//        NSString *str = [NSString stringWithFormat:@"%@=%@&",key,obj];
//        [urlString appendString:str];
//        
//    }];
//    NSString *utf8URL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL * url = [NSURL URLWithString:utf8URL];
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    
//    //发送请求
//    NSURLSession * session = [NSURLSession sharedSession];
//    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        id object =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        NSLog(@"%@",object);
//        [[BaseHttpAPI alloc]requestSuccessDealWithResponseObeject:object success:success failure:failure];
//        
//    }];
//    [sessionTask resume];
//
//
//}
////省级别数据源
//- (NSArray *)dataSouce{
//
//    if (_dataSouce == nil) {
//
//        _dataSouce = [[CitiesDataTool sharedManager] queryAllProvince];
//    }
//    return _dataSouce;
//}
@end
