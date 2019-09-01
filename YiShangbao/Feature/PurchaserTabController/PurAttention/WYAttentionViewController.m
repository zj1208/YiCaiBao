//
//  WYAttentionViewController.m
//  YiShangbao
//
//  Created by light on 2018/5/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYAttentionViewController.h"
#import "WYAttentionListViewController.h"
#import "CCSegmentedControl.h"

@interface WYAttentionViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIButton *collectionStoreButton;


@property (nonatomic, strong) CCSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *listVCArray;

@property (nonatomic, strong) NSArray *typeArray;

@end

@implementation WYAttentionViewController

#pragma mark ------LifeCircle------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self setupListVCs];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:Noti_update_WYAttentionViewController object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn) name:kNotificationUserLoginIn object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 状态栏设置
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark ------Button------
//我关注的供应商
- (IBAction)collectionStoreButtonAction:(id)sender {
    [MobClick event:kUM_c_list_supplier];
    if ([self zx_performIsLoginActionWithPopAlertView:NO]){
//        NSString *url = [NSString stringWithFormat:@"%@/ycbx/page/ycbPersonalConcernedShop.html",[WYUserDefaultManager getkAPP_H5URL]];
//        [[WYUtility dataUtil] routerWithName:url withSoureController:self];
        LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
        NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbPersonalConcernedShop;
        [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbPersonalConcernedShop withSoureController:self];
    }
}


#pragma mark ------UIScrollDelegateDelegate------
//tab选择
- (void)segmentedControlValueChanged:(CCSegmentedControl *)segment {
    NSInteger currentIndex = segment.selectedSegmentIndex;
    if (currentIndex >= self.typeArray.count) {
        currentIndex = self.typeArray.count - 1;
    }
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * currentIndex, 0);
    if (currentIndex < self.listVCArray.count) {
        WYAttentionListViewController *listVC = [self.listVCArray objectAtIndex:currentIndex];
        [listVC reloadData];
    }
    if (currentIndex == 0) {
        [MobClick event:kUM_c_list_tab1];
    } else if (currentIndex == 1){
        [MobClick event:kUM_c_list_tab2];
    } else if (currentIndex == 2){
        [MobClick event:kUM_c_list_tab3];
    } else if (currentIndex == 3){
        [MobClick event:kUM_c_list_tab4];
    }
}

#pragma mark ------UIScrollDelegate------
//滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentIndex = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    self.segmentedControl.selectedSegmentIndex = currentIndex;
    [self.segmentedControl setSelectedSegmentIndex:currentIndex animated:YES];
    if (currentIndex < self.listVCArray.count) {
        WYAttentionListViewController *listVC = [self.listVCArray objectAtIndex:currentIndex];
        [listVC reloadData];
    }
}

#pragma mark ------PrivateUI------
- (void)setupListVCs{
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Attention" bundle:[NSBundle mainBundle]];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, SCREEN_HEIGHT - 64 - 37);
    self.listVCArray = [NSMutableArray new];
    self.typeArray = @[@(WYAttentionTypeAll), @(WYAttentionTypeNew), @(WYAttentionTypeHot), @(WYAttentionTypeStock)];
    
    for (int i=0; i<self.typeArray.count; i++) {
//        WYAttentionListViewController *listVC = [[WYAttentionListViewController alloc] init];
        WYAttentionListViewController *listVC = [sb instantiateViewControllerWithIdentifier:@"WYAttentionListViewControllerID"];
        listVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addChildViewController:listVC];
        [self.scrollView addSubview:listVC.view];
        [self.listVCArray addObject:listVC];
        [listVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView);
            if (i > 0) {
                WYAttentionListViewController *preVC = [self.listVCArray objectAtIndex:i-1];
                make.leading.mas_equalTo(preVC.view.mas_trailing);
            }else {
                make.leading.equalTo(self.scrollView);
            }
            if (i == self.typeArray.count - 1) {
                make.trailing.equalTo(self.scrollView);
            }
            make.size.equalTo(self.scrollView);
        }];
        
        listVC.attentionType = [self.typeArray[i] integerValue];
        listVC.isNeedReload = YES;
        [listVC reloadData];
        
    }
}

- (void)setUI{
    /**
     * CCSegmentedControl 选择器使用
     */
    CCSegmentedControl *cc = [[CCSegmentedControl alloc]init];
//    cc.borderType = CCSegmentedControlBorderTypeTop + CCSegmentedControlBorderTypeLeft + CCSegmentedControlBorderTypeRight + CCSegmentedControlBorderTypeBottom;
//    cc.borderColor = [UIColor orangeColor];
    //    cc.borderWidth = 2.0;
    cc.backgroundColor = [UIColor clearColor];
    cc.selectionIndicatorColor = [UIColor whiteColor];
//    cc.selectionIndicatorBoxColor = [UIColor whiteColor];
    cc.sectionTitles = @[@"关注",@"上新",@"热销",@"库存"];
    //    cc.selectionStyle = CCSegmentedControlSelectionStyleFullWidthStripe;
    cc.selectionStyle = CCSegmentedControlSelectionStyleTextWidthStripe;
    cc.segmentWidthStyle = CCSegmentedControlSegmentWidthStyleFixed;
    cc.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, -5, 0, -5);
    cc.selectionIndicatorLocation = CCSegmentedControlSelectionIndicatorLocationDown;
    cc.selectionIndicatorHeight = 3.0;
    //    cc.verticalDividerEnabled = YES;
    
    
    cc.titleTextAttributes = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               };
    
    cc.selectedTitleTextAttributes = @{
                                       NSFontAttributeName :
//                                           [UIFont fontWithName:@"PingFangSC-Medium"size:17.0f],
                                       [UIFont systemFontOfSize:17.0f],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       };
    [self.navigationView addSubview:cc];
    
    [cc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navigationView).offset(-4);
        make.left.equalTo(self.navigationView).offset(0);
        make.right.equalTo(self.navigationView).offset(-63);
        make.height.equalTo(@36);
    }];
    
    [cc addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentedControl = cc;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 94);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFFBA49].CGColor,(id)[UIColor colorWithHex:0xFF8D32].CGColor, nil];
    [self.navigationView.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)switchTabIndex:(NSInteger)index {
    self.segmentedControl.selectedSegmentIndex = index;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * index, 0);
}

#pragma mark - 登陆
- (void)loginIn {
    for (WYAttentionListViewController *listVC in self.listVCArray) {
        listVC.isNeedReload = YES;
        [listVC reloadData];
    }
}

- (void)reloadData {
    for (WYAttentionListViewController *listVC in self.listVCArray) {
        listVC.isNeedReload = YES;
    }
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
