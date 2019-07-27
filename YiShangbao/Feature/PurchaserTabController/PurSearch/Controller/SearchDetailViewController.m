//
//  SearchDetailViewController.m
//  YiShangbao
//
//  Created by 海狮 on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SearchDetailViewController.h"

#import "SearchDetailLunBoCollectionViewCell.h"

#import "FenLeiViewController.h"
#import "SearchViewController.h"
#import "SearchProductDetailController.h"
#import "SearchShopDetailController.h"

@interface SearchDetailViewController ()<JLCycleScrollerViewDelegate,SearchViewControllerDelegate,ScrollViewMoveUpDownProtocol>

@property (nonatomic, strong) SearchProductDetailController *productViewC;
@property (nonatomic, strong) SearchShopDetailController *shopViewC;

@property (nonatomic, strong) SearchViewController *searchViewC;
@property (nonatomic, strong) NSArray *arrayLunBo;

@property (nonatomic, assign) BOOL isNowMoveAnimated;
@property (nonatomic, assign) BOOL customNavigationBarNomal; //记录导航栏是正常状态还是向上平移了

@end

@implementation SearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorWithHexString:@"FAFAFA"];
    
    self.customNavigationBarNomal = YES;
    
    //SB初始化UI后调整
    [self buildUI];
    
    //轮播图
    [self requestLunBo];
    
    //添加子控制器
    [self addProductShopControllers];
}
-(void)addProductShopControllers
{
    //产品
    UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:sb_Purchaser bundle:[NSBundle mainBundle]];//SearchProductDetailController SearchShopDetailController
    SearchProductDetailController* productVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchProductDetailController];
    productVC.searchKeyword = self.searchKeyword;
    productVC.keywordType = self.keywordType;
    productVC.catId = self.catId;
    
    [self addChildViewController:productVC];
    [self.view addSubview:productVC.view];

    [productVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ParentView.mas_bottom);
        make.bottom.mas_equalTo(self.diburongqiView.mas_top);
    }];
    self.productViewC = productVC;
    self.productViewC.delegate = self;

    //商铺
    SearchShopDetailController* shopVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchShopDetailController];
    shopVC.searchKeyword = self.searchKeyword;
    shopVC.keywordType = self.keywordType;
    shopVC.catId = self.catId;
    
    [self addChildViewController:shopVC];
    self.shopViewC = shopVC;
    self.shopViewC.delegate = self;
    
}
#pragma mark - 修改storyboard初始化样式,适配等
-(void)buildUI
{
    //------UI适配调整-----
    //底部容器适配（5/6保存一致高度,plus）
    [self.diburongqiView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(45.f));
    }];
    //底部容器ihponeX适配
    [self.diburongqiView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-HEIGHT_TABBAR_SAFE);
    }];
    
    //字体适配: 主营此商品的商铺有 1234565 家，点击查看Label
    self.numOfShopsLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(15)];
    //对结果不满意？试试
    self.miaoshuLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(14)];
    
    //自定义“状态栏”ihponeX适配
    [self.stateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_STATEBAR);
    }];
    //headerView默认UI先隐藏-----
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.f);
    }];
    
    //发布求购／分类查找
    UIImage* image_fabuqiugouBtn = [WYUISTYLE imageWithStartColorHexString:@"FFD456" EndColorHexString:@"FFB54F" WithSize:self.fabuqiugouBtn.bounds.size];
    UIImage* image_fenleichazhaoBtn = [WYUISTYLE imageWithStartColorHexString:@"FF9031" EndColorHexString:@"F9664A" WithSize:self.fenleichazhaoBtn.bounds.size];
    [self.fabuqiugouBtn setBackgroundImage:image_fabuqiugouBtn forState:UIControlStateNormal];
    [self.fenleichazhaoBtn setBackgroundImage:image_fenleichazhaoBtn forState:UIControlStateNormal];
    
    //隐藏“分类查找”按钮（若从上级分类查找页面进来）
    if (self.hiddenFenLeiBtn) {
        self.fenleiBtn_trailingLayoutCon.constant = -LCDScale_iPhone6_Width(100.f);
        self.fenleichazhaoBtn.hidden = YES;
    }
    
    self.JLlunbotuView.layer.masksToBounds = YES;
    self.JLlunbotuView.layer.cornerRadius = 5;
    self.JLlunbotuView.pageControl.pageIndicatorSize = CGSizeMake(LCDScale_iPhone6_Width(14), 2);
    self.JLlunbotuView.pageControl.currentPageIndicatorSize = CGSizeMake(LCDScale_iPhone6_Width(14), 2);
    self.JLlunbotuView.pageControl.pageIndicatorRadius = 1.f;
    self.JLlunbotuView.pageControl.currentPageIndicatorRadius = 1.f;
    self.JLlunbotuView.pageControl.currentPageIndicatorTintColor = [WYUISTYLE colorWithHexString:@"F58F23"];
    self.JLlunbotuView.pageControl.pageIndicatorTintColor = [WYUISTYLE colorWithHexString:@"C2C2C2"];
    self.JLlunbotuView.pageControl.allowUpdatePageIndicator = YES;
    [self.JLlunbotuView setCustomCell:[[SearchDetailLunBoCollectionViewCell alloc] init] isXibBuild:YES];
    self.JLlunbotuView.delegate = self;
    
    //设置搜索title
    [self.NaviSearchBtn setTitle:self.searchKeyword forState:UIControlStateNormal];
    
}
#pragma mark - ScrollViewMoveUpDownProtocol
-(void)jl_scrollViewDidScrollWithMoveUp:(BOOL)moveUp
{
    if (moveUp)
    {
        [self moveCustomNavigationBarUp];
    }
    else
    {
        [self moveCustomNavigationBarDown];
    }
}
#pragma mark 更新约束导航栏平移上去
-(void)moveCustomNavigationBarUp
{
    if (self.isNowMoveAnimated) {
        return;
    }
    [self.view layoutIfNeeded];
    CGFloat chanpin_shangpu_Y = CGRectGetMinY(self.chanpin_shangpuView.frame);
    [self.ParentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(-chanpin_shangpu_Y);
    }];
    [self.chanpin_shangpuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40.f+HEIGHT_STATEBAR);
    }];
    //底部view
    [self.diburongqiView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(LCDScale_5Equal6_To6plus(45.f));
    }];

    self.isNowMoveAnimated = YES;
    [UIView animateWithDuration:0.35 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.isNowMoveAnimated = NO;
        self.customNavigationBarNomal = NO;
    }];
    
}
#pragma mark 更新约束导航栏平移下来
-(void)moveCustomNavigationBarDown
{
    if (self.isNowMoveAnimated) {
        return;
    }
    [self.ParentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
    }];
    [self.chanpin_shangpuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40.f);
    }];
    [self.diburongqiView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-HEIGHT_TABBAR_SAFE);
    }];
    
    self.isNowMoveAnimated = YES;
    [UIView animateWithDuration:0.35 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.isNowMoveAnimated = NO;
        self.customNavigationBarNomal = YES;
    }];
}
#pragma mark - 请求轮播图数据
-(void)requestLunBo
{
    [[[AppAPIHelper shareInstance] getSearchAPI] getSearchProductAdditionalURWithSearchKeyword:self.searchKeyword keywordType:@(self.keywordType) catId:self.catId Success:^(id data) {
        
        SearchLunBoMainModel *model = (SearchLunBoMainModel *)data;
        _arrayLunBo = model.shops;
        NSString* str =  model.shopCnt;
        if (_arrayLunBo.count >0)
        {
            self.JLlunbotuView.hidden = NO;
            self.zhuyinBackView.hidden = YES;
            
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(136.f);
            }];
            
            if (@available(iOS 9.0, *)) {
                [UIView animateWithDuration:0.2 animations:^{ //不加动画刷新闪屏效果不好
                    [self.view updateConstraints];
                } completion:^(BOOL finished) {
                    self.JLlunbotuView.sourceArray = _arrayLunBo;
                }];
            } else{//有子控制器时加动画在iOS8上展示异常
                self.JLlunbotuView.sourceArray = _arrayLunBo;
            }
        }
        else if(![NSString zhIsBlankString:str])
        {
            self.JLlunbotuView.hidden = YES;
            self.zhuyinBackView.hidden = NO;

            self.numOfShopsLabel.text = str;
            
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(54.f);
            }];
        }
        else
        {
            self.JLlunbotuView.hidden = YES;
            self.zhuyinBackView.hidden = YES;
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.f);
            }];
        }
        
    } failure:^(NSError *error) {
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.f);
        }];
    }];
}
#pragma mark - 广告轮播点击代理
-(void)jl_cycleScrollerView:(JLCycleScrollerView *)view didSelectItemAtIndex:(NSInteger)index sourceArray:(nonnull NSArray *)sourceArray
{
    SearchLunBoModel* model = (SearchLunBoModel*)sourceArray[index];
    [self pushShopHtmlWithId:model.iid baseUrl:model.link];
}
#pragma mark - 跳转商铺详情
-(void)pushShopHtmlWithId:(NSString*)iid baseUrl:(NSString *)baseUrl
{
    NSString *url = [baseUrl stringByReplacingOccurrencesOfString:@"{shopId}" withString:iid];
    [self pushToWebViewController:url];
}
#pragma mark 跳转h5界面
-(void)pushToWebViewController:(NSString*)webUrl
{
    [WYUTILITY routerWithName:webUrl withSoureController:self];
}
#pragma mark - 点击Actions
#pragma mark - 产品
- (IBAction)productBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.shangPuBtn.selected = NO;
        self.procuctLine.hidden = NO;
        self.shangPuLine.hidden = YES;
        
        //处理过渡效果
        [self.view layoutIfNeeded];
        self.productViewC.view.frame = self.shopViewC.view.frame;
        self.productViewC.chanpinshaixuanBackView.hidden = YES;

        [self.shopViewC removeWYSelectedTableViewIfNeed];
        [self transitionFromViewController:self.shopViewC toViewController:self.productViewC duration:0 options:0 animations:nil completion:^(BOOL finished) {
            self.productViewC.chanpinshaixuanBackView.hidden = NO;
            [self.productViewC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view);
                make.right.mas_equalTo(self.view);
                make.top.mas_equalTo(self.ParentView.mas_bottom);
                make.bottom.mas_equalTo(self.diburongqiView.mas_top);
            }];
        }];
    }
}
#pragma mark - 商铺
- (IBAction)shangpuBtnClick:(UIButton *)sender {
    
    if (!sender.selected) {
        sender.selected = YES;
        self.procuctBtn.selected = NO;
        self.procuctLine.hidden = YES;
        self.shangPuLine.hidden = NO;
        
        //处理过渡效果
        [self.view layoutIfNeeded];
        self.shopViewC.view.frame = self.productViewC.view.frame;
        self.shopViewC.shangpushaixuanBackView.hidden = YES;

        [self.productViewC removeWYSelectedTableViewIfNeed];
        [self transitionFromViewController:self.productViewC toViewController:self.shopViewC duration:0 options:0 animations:nil completion:^(BOOL finished) {
            self.shopViewC.shangpushaixuanBackView.hidden = NO;
            [self.shopViewC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view);
                make.right.mas_equalTo(self.view);
                make.top.mas_equalTo(self.ParentView.mas_bottom);
                make.bottom.mas_equalTo(self.diburongqiView.mas_top);
            }];
            
            //headerView处理
            if (_arrayLunBo.count==0) {
                [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0.f);
                }];
                if (!_customNavigationBarNomal)
                { //如果平移上去后，更新headerView高度0后，ParentView距离top约束距离多headerView高度，需再次调整
                    [self.view layoutIfNeeded];
                    CGFloat chanpin_shangpu_Y = CGRectGetMinY(self.chanpin_shangpuView.frame);
                    [self.ParentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.view).offset(-chanpin_shangpu_Y);
                    }];
                }
            }
            
        }];
    }
}
#pragma mark - 主营此商品的商铺有 1234565 家，点击查看
- (IBAction)LookShopsClick:(UIButton *)sender {
    [self shangpuBtnClick:self.shangPuBtn];
}
#pragma mark - 发布求购
- (IBAction)fabuqiugouClick:(UIButton *)sender
{
    LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
    NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbPurchaseForm;
    [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbPurchaseForm withSoureController:self];
}
#pragma mark - 分类查找
- (IBAction)fenleichazhaoClick:(id)sender {
    
    FenLeiViewController* fenLei = [[FenLeiViewController alloc] init];
    fenLei.pushstyle = FenLeiDellocLast;
    [self.navigationController pushViewController:fenLei animated:YES];
}
#pragma mark - 自定义导航栏Action
//点击返回
- (IBAction)naviBackClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
//点击搜索按钮
- (IBAction)naviSearchClick:(UIButton *)sender {
    if (!self.searchViewC) {
        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:sb_Purchaser bundle:[NSBundle mainBundle]];
        self.searchViewC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchViewController];
        self.searchViewC.delegate = self;
    }
    self.searchViewC.searchKeyword = self.searchKeyword;
    [self presentViewController:self.searchViewC animated:NO completion:nil];
}
#pragma mark - 搜索控制器代理方法
-(void)jl_willDismissSearchViewController:(SearchViewController*)vc keywordType:(NSInteger)keywordType searchKeyword:(NSString*)searchKeyword
{
    //创建一个新的搜索详情页
    UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:sb_Purchaser bundle:[NSBundle mainBundle]];
    SearchDetailViewController* searchDVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchDetailViewController];
    searchDVC.searchKeyword = searchKeyword;
    searchDVC.keywordType = keywordType;
    searchDVC.catId = nil;
    searchDVC.hidesBottomBarWhenPushed = YES;
    searchDVC.hiddenFenLeiBtn = self.hiddenFenLeiBtn;
    
    //替换成一个新的控制器
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
    [arrayM replaceObjectAtIndex:arrayM.count-1 withObject:searchDVC];
    [self.navigationController setViewControllers:arrayM];
}
#pragma mark - viewDidAppear------
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.presentedViewController) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }

}
-(void)dealloc
{
    NSLog(@"jl__SearchDetailViewController dealloc");
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
