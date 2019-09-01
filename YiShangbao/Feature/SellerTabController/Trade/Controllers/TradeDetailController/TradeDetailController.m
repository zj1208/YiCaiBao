//
//  TradeDetailController.m
//  YiShangbao
//
//  Created by simon on 17/1/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeDetailController.h"
#import "WYTradeDetailTableViewCell.h"
#import "TradeDetailPhotosCell.h"
#import "TradeDetailTranslationCell.h"

#import "TradeDetailMyCommitCell.h"
#import "TradeDetailRowCell.h"
#import "ZXTitleView.h"
//#import "TradeOrderedPersonalCell.h"
#import "TradeDetailOtherReplyCell.h"
#import "TradeDetailSecondCell.h"

#import "WYPerfectShopInfoViewController.h"
#import "MessageModel.h"
#import "BuyerInfoController.h"

#import "TradeOrderingController.h"
//大图浏览所需要的头文件
#import "XLPhotoBrowser.h"
#import "ZXCenterBottomToolView.h"
#import "NTESSessionViewController.h"
#import "WYNIMAccoutManager.h"

#import "TradeDetailForeignInfoController.h"
#import "WYAlertViewController.h"

static NSInteger const section_DetailInfo =0;
static NSInteger const section_DetailTranslation = 1;
static NSInteger const section_DetailPhotos = 2;

static NSInteger const section_SecondSection = 3; //采购数量、交货时间
static NSInteger const section_DetailRow = 4; //发布时间
static NSInteger const section_MyCommit = 5;  //从我的回复->接单时间
static NSInteger const section_OtherCommit =6;

static NSString *const reuse_SecondCell  = @"SecondCell";
@interface TradeDetailController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,ZXPhotosViewDelegate,ZXEmptyViewControllerDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource,TradeDetailTranslationCellDelegate>

@property (nonatomic, strong) TradeDetailModel *dataModel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger downTime;

//@property (nonatomic, strong) TradeOrderedPersonalCell *tradeOrderedPersonalCell;
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, copy) NSString *historyReply;

@property (nonatomic, assign) BOOL doSomeThing;
@end

@implementation TradeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    
    [self setData];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%f",self.topLayoutGuide.length);
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



- (void)dealloc
{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



#pragma mark - setUI

- (void)setUI
{
    self.navigationItem.title = NSLocalizedString(@"生意", nil);
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.backgroundColor = self.view.backgroundColor;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addRightShareBarButtonItem];
    [self setBottomUI];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WYTradeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TradeDetailPhotosCell" bundle:nil] forCellReuseIdentifier:@"TradeDetailPhotosCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TradeDetailTranslationCell" bundle:nil] forCellReuseIdentifier:@"TradeDetailTranslationCell"];
   

    
    self.tableView.estimatedRowHeight = 70.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    //未接单提示:ui
    self.tableView.tableFooterView.hidden = YES;
    self.tableView.tableFooterView.zx_height = 0.f;
    
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
}



- (void)addRightShareBarButtonItem
{
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [btn setImage:[[UIImage imageNamed:@"sharefriend"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shareFriends) forControlEvents:UIControlEventTouchUpInside];
    [btn setAdjustsImageWhenHighlighted:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];;
}

- (void)setBottomUI
{
    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.bottomContainerView.hidden = YES;
   
    [self.bottomCallBtn zx_setBorderWithRoundItem];
    [self.bottomOrderingView zx_setBorderWithRoundItem];
    
    UIImage *backgroundImage = [WYUIStyle imageFDAB53_FD7953:_bottomCallBtn.frame.size];
    [self.bottomCallBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    if (IS_IPHONE_5)
    {
        self.hozEdgeLayout.constant = 10.f;
        self.hozEdgeLeftLayout.constant = 10.f;
    }
    else
    {
        self.hozEdgeLeftLayout.constant = LCDScale_5Equal6_To6plus(15.f);
        self.hozEdgeLayout.constant = LCDScale_5Equal6_To6plus(15.f);
    }
//    [self.view layoutIfNeeded];
//    CGSize orderingViewSize = _bottomOrderingView.frame.size;
//    orderingViewSize.width = LCDW-_bottomCallBtn.frame.size.width-self.hozEdgeLeftLayout.constant-self.hozEdgeLayout.constant-10;
//
//    UIImage *backgroundImage2 = [WYUTILITY getCommonVersion2RedGradientImageWithSize:orderingViewSize];
//    self.bottomOrderingView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage2];

    UIImage *backgroundImage2 = [WYUTILITY getCommonVersion2RedGradientImageWithSize:CGSizeMake(1, 1)];
    self.bottomOrderingView.layer.contents = (id)backgroundImage2.CGImage;
    
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = 60.f;
    self.tableView.contentInset = inset;
}

#pragma mark - setData

- (void)setData
{
    [self headerRefresh];
    self.navigationController.delegate = self;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    NSMutableArray *photos = [NSMutableArray array];
    _photoArray = photos;
    
    NSArray *titArray = @[NSLocalizedString(@"采购数量:", nil),NSLocalizedString(@"交货时间:", nil),NSLocalizedString(@"发布时间:", nil)];
    _titleArray = titArray;
    
    // 已接单
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData:) name:Noti_Trade_haveReceivedTrade object:nil];
    
    // 重复接单 或  已经被别人接单了；
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData:) name:Noti_Trade_subjectCompleted object:self];

    // 初始化完后开始刷新数据
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isTargetControllerNeedRemove = [NSStringFromClass([viewController class]) isEqualToString:@"TradeOrderSuccessViewController"];
    BOOL isContainsMe = [navigationController.viewControllers containsObject:self];
    if (!isContainsMe||isTargetControllerNeedRemove)
    {
        if (isTargetControllerNeedRemove)
        {
            [self removeTradeDetailController_TradeOrderingController];
        }
        navigationController.delegate = nil;
        if (self.timer && [self.timer isValid])
        {
            [self.timer invalidate];
        }
    }
}

-(void)removeTradeDetailController_TradeOrderingController
{
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
    NSInteger count = self.navigationController.childViewControllers.count;
    if (count >=3) {
        UIViewController *vcD = self.navigationController.childViewControllers[count-3];
        if ([NSStringFromClass([vcD class]) isEqualToString:@"TradeDetailController"]) {
            [arrayM removeObject:vcD];
        }
        UIViewController *vcO = self.navigationController.childViewControllers[count-2];
        if ([NSStringFromClass([vcO class]) isEqualToString:@"TradeOrderingController"]) {
            [arrayM removeObject:vcO];
        }
        [self.navigationController setViewControllers:arrayM animated:NO];
    }
}
#pragma mark - timerFired:

- (void)timerFired:(NSTimer *)timer
{
//        NSLog(@"定时器1");
    if (!self.dataModel.myCommitModel)
    {
        if (self.downTime ==0)
        {
            [self.timer setFireDate:[NSDate distantFuture]];
        }
        else
        {
            NSString *timeStr =[NSString zhuDate_countDownFromDifferenceTime:self.downTime appendSeconds:YES];
            self.countTimeLab.text = [NSString stringWithFormat:@"还剩：%@",timeStr];
            self.downTime --;
        }
    }
}
- (void)zxEmptyViewUpdateAction
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)updateData:(NSNotification *)noti
{
    if (self.navigationController.topViewController ==self)
    {
        return;
    }
    [self.tableView.mj_header beginRefreshing];
}

 


#pragma mark - headerRefresh

- (void)headerRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestHeaderData];
       }];
}

- (void)requestHeaderData
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getTradeMainAPI]getTradeBussinessDetailWithPostId:self.postId success:^(id data) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        NSArray *translation = weakSelf.dataModel.translation;
        if (data)
        {
            weakSelf.dataModel = nil;
            weakSelf.dataModel = [[TradeDetailModel alloc] init];
            weakSelf.dataModel = data;
            weakSelf.dataModel.translation = translation;//不然下啦刷新效果有点差
        }
        [weakSelf.emptyViewController hideEmptyViewInController:weakSelf hasLocalData:weakSelf.dataModel?YES:NO];
        
        [weakSelf reloadAllData];
        
        if (weakSelf.dataModel.tradeType == WYTradeType_foreignDirect)
        {//翻译
            [self requestTranslatorSimple];
        }
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataModel?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
//外商内容翻译
- (void)requestTranslatorSimple
{
    NSMutableArray *arrayM = [NSMutableArray array];
    if (self.dataModel.title) {
        [arrayM addObject:self.dataModel.title];
    }
    if (self.dataModel.content) {
        [arrayM addObject:self.dataModel.content];
    }
    [[[AppAPIHelper shareInstance]getTradeMainAPI] getTranslatorSimpleWithType:WYTranslatorType_EN_to_CN sources:arrayM success:^(id data) {
        
        self.dataModel.translation = data;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        self.dataModel.translation = [NSArray array];//当translation.count!=2时展示重新翻译
        [self.tableView reloadData];
    }];
}
#pragma mark - 刷新所有数据

- (void)reloadAllData
{
    self.bottomContainerView.hidden = NO;

    if (self.dataModel.otherReplyModel.count ==0)
    {
        if (self.tableView.tableFooterView.zx_height==0)
        {
            self.tableView.tableFooterView.hidden = NO;
            self.tableView.tableFooterView.zx_height =IS_IPHONE_6P?LCDScale_iPhone6_Width(280.f):LCDScale_iPhone6_Width(240.f);
            self.tableView.tableFooterView = self.tableFooterView;
        }
    }
    else
    {
        if (self.tableView.tableFooterView.zx_height != 0.f)
        {
            self.tableView.tableFooterView.hidden = YES;
            self.tableView.tableFooterView.zx_height = 0.f;
        }
    }

    if (self.dataModel.myCommitModel)
    { //已接单
        
        if (self.dataModel.tradeType == WYTradeType_foreignDirect)
        { //外商直采
            [self.bottomCallBtn setImage:nil forState:UIControlStateNormal];
            [self.bottomCallBtn setTitle:NSLocalizedString(@"联系方式", nil) forState:UIControlStateNormal ];
        }else{
            [self.bottomCallBtn setTitle:NSLocalizedString(@"拨打电话", nil) forState:UIControlStateNormal ];
        }
     
        //移除子视图，再添加新按钮
        [self.bottomOrderingView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIButton* button = [[UIButton alloc] initWithFrame:self.bottomOrderingView.frame];
        [button setTitle:NSLocalizedString(@"在线沟通", nil) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button zx_setBorderWithRoundItem];
        [button setImage:[UIImage imageNamed:@"im"] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        button.backgroundColor = [UIColor clearColor];
        [self.bottomContainerView addSubview:button];

        UIImage *backgroundImage2 = [WYUTILITY getCommonVersion2RedGradientImageWithSize:button.frame.size];
        [button setBackgroundImage:backgroundImage2 forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(ckickNowTalk:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    { //未接单
        self.downTime = self.dataModel.expirationTime/1000;
        NSString *timeStr =[NSString zhuDate_countDownFromDifferenceTime:self.downTime appendSeconds:YES];
        self.countTimeLab.text = [NSString stringWithFormat:@"还剩：%@",timeStr];
        self.countTimeLab.textColor = UIColorFromRGB_HexValue(0xAD0D0c);
    }
    self.bottomContainerView.hidden = NO;
    
    [self.tableView reloadData];

}


#pragma mark - 在线沟通

- (void)ckickNowTalk:(UIButton *)sender forEvent:(UIEvent *)event
{
    if (event.type ==UIEventTypeTouches)
    {
        UITouch *touch= [[event allTouches]anyObject];
        if (touch.tapCount==1)
        {
            [self ckickNowTalk:sender];
        }
        else
        {
            NSLog(@"touch.tapCount>1 =%ld",(long)touch.tapCount);
        }
    }
}


-(void)ckickNowTalk:(UIButton*)sender
{
    if ([[WYNIMAccoutManager shareInstance]cheackAccoutEnable:self])
    {
        WS(weakSelf);
        [[[AppAPIHelper shareInstance]getNimAccountAPI]getChatUserIMInfoWithIDType:NIMIDType_Trade thisId:self.dataModel.postId success:^(id data) {
            
            [MobClick event:kUM_b_businessIM_2];

            NSString *accid = [data objectForKey:@"accid"];
            NSString *hisUrl = [data objectForKey:@"url"];
            NIMSession *session = [NIMSession session:accid type:NIMSessionTypeP2P];
            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
            vc.hisUrl = hisUrl;
            vc.hideUnreadCountView = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataModel?7:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==section_OtherCommit)
    {
        return self.dataModel.otherReplyModel.count;
    }
    if (section ==section_DetailTranslation)
    {
        if (self.dataModel.tradeType != WYTradeType_foreignDirect){
            return 0;
        }
    }
    if (section ==section_DetailPhotos)
    {
        if (!self.dataModel.photosArray || self.dataModel.photosArray.count==0){
            return 0;
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //详情
    if (indexPath.section ==section_DetailInfo)
    {
        WYTradeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell.personalBtn addTarget:self action:@selector(personalBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell setData:self.dataModel];
     
        return cell;
    }
    //发布时间
    if (indexPath.section == section_DetailRow)
    {
        TradeDetailRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rowCell" forIndexPath:indexPath];
        if (self.dataModel)
        {
            cell.textLab.text = NSLocalizedString(@"发布时间", nil);
            cell.detailLab.text =_dataModel.publishTime;
            cell.lineView.hidden = YES;
            cell.lengthLineView.hidden = YES;
//            cell.textLab.text = [_titleArray objectAtIndex:indexPath.row];
//            if (indexPath.row ==0)
//            {
//                cell.lineView.hidden = NO;
//                cell.lengthLineView.hidden = !cell.lineView.hidden;
//                cell.detailLab.text =_dataModel.needCount ;
//            }
//            else if (indexPath.row ==1)
//            {
//                cell.lineView.hidden = YES;
//                cell.lengthLineView.hidden = !cell.lineView.hidden;
//                cell.lengthLineView.backgroundColor = UIColorFromRGB_HexValue(0xEFEFEF);
//                cell.detailLab.text =_dataModel.deliveryTime ;
//            }
//            else if (indexPath.row ==2)
//            {
//                cell.lineView.hidden = YES;
//                cell.lengthLineView.hidden = !cell.lineView.hidden;
//                cell.lengthLineView.backgroundColor = UIColorFromRGB_HexValue(0xD9D9D9);
//                cell.detailLab.text =_dataModel.publishTime;
//            }
//            [cell layoutIfNeeded];
        }
        return cell;
    }
    //我的评论－>我的回复(包括接单时间)
    if (indexPath.section ==section_MyCommit)
    {
        TradeDetailMyCommitCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"MyCommitCell" forIndexPath:indexPath];
        if (self.dataModel.myCommitModel)
        {
            cell2.photosView.delegate = self;
            [cell2 setData:self.dataModel.myCommitModel];
        }
        return cell2;
    }
    
    //已接单 
    if (indexPath.section ==section_OtherCommit)
    {
        TradeDetailOtherReplyCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"otherReplyCell" forIndexPath:indexPath];
        if (self.dataModel.otherReplyModel.count>0)
        {
            [cell3 setData:[self.dataModel.otherReplyModel objectAtIndex:indexPath.row]];
        }
        return cell3;
    }
    //外商直采翻译
    if (indexPath.section ==section_DetailTranslation)
    {
        TradeDetailTranslationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeDetailTranslationCell" forIndexPath:indexPath];
        if (self.dataModel)
        {
            [cell setData:self.dataModel];
        }
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section ==section_DetailPhotos)
    {
        TradeDetailPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeDetailPhotosCell" forIndexPath:indexPath];
        if (self.dataModel)
        {
            cell.photosView.delegate = self;
            [cell setData:self.dataModel];
        }
        return cell;
    }
    
    //采购数量、交货时间
    TradeDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_SecondCell forIndexPath:indexPath];
    if (self.dataModel)
    {
        [cell setData:self.dataModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //采购数量/交货时间，发布时间
    if (indexPath.section == section_DetailRow)
    {
        if (self.dataModel)
        {
            cell.contentView.backgroundColor = UIColorFromRGB(249.f, 249.f, 249.f);
//            if (indexPath.row ==2)
//            {
//                cell.contentView.backgroundColor = UIColorFromRGB(249.f, 249.f, 249.f);
//            }
//            else
//            {
//                cell.contentView.backgroundColor = [UIColor whiteColor];
//            }
        }
    }
}
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataModel)
    {
        if (indexPath.section ==section_DetailInfo)
        {
            return UITableViewAutomaticDimension;
        }
        else if (indexPath.section == section_DetailTranslation)
        {
            return UITableViewAutomaticDimension;
        }
        else if (indexPath.section == section_DetailPhotos)
        {
            static TradeDetailPhotosCell *cell = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                
                cell = (TradeDetailPhotosCell *)[tableView dequeueReusableCellWithIdentifier:@"TradeDetailPhotosCell"];
            });
            CGFloat height = [cell getCellHeightWithContentData:_dataModel];
            return height;
        }
        else if (indexPath.section == section_SecondSection)
        {
            return UITableViewAutomaticDimension;
        }
        else if (indexPath.section ==section_DetailRow)
        {
            return LCDScale_5Equal6_To6plus(40.f);
        }
        else if (indexPath.section ==section_MyCommit)
        {
            static TradeDetailMyCommitCell *cell = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                
                cell = (TradeDetailMyCommitCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCommitCell"];
            });
            CGFloat height = [cell getCellHeightWithContentData:_dataModel.myCommitModel];
            return height;
        }
        else if (indexPath.section ==section_OtherCommit)
        {
            if (self.dataModel.otherReplyModel.count>0)
            {
                return LCDScale_5Equal6_To6plus(75.f);
            }
        }
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataModel)
    {
        if (section == section_SecondSection || section ==section_DetailRow)
        {
            return LCDScale_5Equal6_To6plus(10.f);;
        }
        if (self.dataModel.myCommitModel && section==section_MyCommit)
        {
            return LCDScale_5Equal6_To6plus(35.f);;
        }
        if (section ==section_OtherCommit)
        {
            return LCDScale_5Equal6_To6plus(35.f);;
        }
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.dataModel.myCommitModel && section==section_MyCommit)
    {
        ZXCenterTitleView * view = [[[NSBundle mainBundle] loadNibNamed:@"ZXCenterTitleView" owner:self options:nil] firstObject];
        [view.centerBtn setTitle:NSLocalizedString(@"我的回复", nil) forState:UIControlStateNormal];
        [view.centerBtn setImage:[UIImage imageNamed:@"pic_hiufu"] forState:UIControlStateNormal];
        [view.centerBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
        view.centerBtnWidthLayout.constant = 80.f;
        view.centerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
    }
    else if (section ==section_OtherCommit)
    {
        ZXCenterTitleView * view = [[[NSBundle mainBundle] loadNibNamed:@"ZXCenterTitleView" owner:self options:nil] firstObject];
        [view.centerBtn setTitle:NSLocalizedString(@"回复", nil)  forState:UIControlStateNormal];
         [view.centerBtn setImage:[UIImage imageNamed:@"pic_hiufu"] forState:UIControlStateNormal];
        [view.centerBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
        view.centerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
    }

    return [[UIView alloc] init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    WYTradeDetailViewController * tradeDetail =[[WYTradeDetailViewController alloc]initWithNibName:@"WYTradeDetailViewController" bundle:nil];
//    tradeDetail.hidesBottomBarWhenPushed =YES;
//    [self.navigationController pushViewController:tradeDetail animated:YES];
//}

-(void)jl_reloadTranslationWithCell:(TradeDetailTranslationCell *)cell
{
    [self requestTranslatorSimple];
}

#pragma  mark - MWPhotoBrowser

- (void)zx_photosView:(ZXPhotosView *)photosView didSelectWithIndex:(NSInteger)index photosArray:(NSArray *)photos
{
    [_photoArray removeAllObjects];
    //大图浏览
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *zxPhoto = (ZXPhoto*)obj;
        NSURL *url = [NSURL URLWithString:zxPhoto.original_pic];
        //大图浏览
        [_photoArray addObject:url];
    }];
    
    //大图浏览
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:photos.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
    
}

#pragma mark    -   XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return _photoArray[index];
}


#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return  [self.tableView isRefreshing];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TradeOrderingController *vc = segue.destinationViewController;
    if ([vc respondsToSelector:@selector(dataModel)])
    {
        [vc setValue:self.dataModel forKey:@"dataModel"];
    }
    if ([vc respondsToSelector:@selector(reply)])
    {
        [vc setValue:self.historyReply forKey:@"reply"];
    }
    
}
#pragma mark - 头像点击查看采购商
- (void)personalBtnAction:(id)sender
{
    [MobClick event:kUM_b_toviewbuyer];

    [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_BuyerInfoController withData:@{@"bizId":self.dataModel.unId, @"boolChat":@(NO)}];
}


/**
 马上接单
 
 */
- (IBAction)takeOrderingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    [MobClick event:kUM_gotoQuotes];

//    sender.enabled = NO;
//    [self performSelector:@selector(requestTakeOrdering) withObject:nil afterDelay:2.f];
//    [self requestTakeOrdering];

    if (event.type ==UIEventTypeTouches)
    {
        UITouch *touch= [[event allTouches]anyObject];
        if (touch.tapCount==1)
        {
            [self requestTakeOrdering];
        }
        else
        {
            NSLog(@"touch.tapCount>1 =%ld",touch.tapCount);
        }
    }

}

- (void)requestTakeOrdering
{
    if (_doSomeThing)
    {
        return;
    }
    _doSomeThing = YES;
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getTradeMainAPI]getTradeDetailTakeOrderingWithPostId:self.postId success:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:nil];
        //没有认证，当前接单的时候剩余次数为0的时候提示：“您本月还剩下0次接生意权益，认证后可无限接单”
        NSDictionary *redirect = [data objectForKey:@"redirect"];
        if (redirect)
        {
            //“您本月还剩下0次接生意权益，认证后可无限接单”
            NSString *title = [redirect objectForKey:@"msg"];
            //去认证-跳转h5认证页面
            NSString *btn1 = [redirect objectForKey:@"btn1"];
            //放弃
            NSString *btn2 = [redirect objectForKey:@"btn2"];
            NSString *url = [redirect objectForKey:@"url"];

            [UIAlertController zx_presentGeneralAlertInViewController:weakSelf withTitle:title message:nil cancelButtonTitle:btn2 cancleHandler:nil doButtonTitle:btn1 doHandler:^(UIAlertAction * _Nonnull action) {
                
                [[WYUtility dataUtil]routerWithName:url withSoureController:weakSelf];
            }];
        }
        else
        {
            //历史回复
            if ([data objectForKey:@"ds"])
            {
                weakSelf.historyReply = [data objectForKey:@"ds"];
            }
            [weakSelf performSegueWithIdentifier:segue_TradeOrderingController sender:weakSelf];
            
        }
        weakSelf.doSomeThing = NO;
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error.userInfo);
        NSString *code = [error.userInfo objectForKey:@"code"];
        //未开店
        if ([code isEqualToString:@"not_completed_info"])
        {
            [MBProgressHUD zx_hideHUDForView:nil];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"完善商铺信息，一键接生意！", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"立即完善", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                WYPerfectShopInfoViewController *fastOpenShop = [[WYPerfectShopInfoViewController alloc] init];
                fastOpenShop.soureControllerType = SourceControllerType_Any;
                [weakSelf.navigationController pushViewController:fastOpenShop animated:YES];
                
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:doAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        else if ([code isEqualToString:@"subject_completed"])
        {
            [MBProgressHUD zx_showError:NSLocalizedString(@"手慢啦，去看看别的生意吧！", nil) toView:nil];
            [weakSelf performSelector:@selector(popToMainListController) withObject:nil afterDelay:2.f];
        }
//      接单受限，可能是因为恶意接单被采购商举报，app端需对此code特殊处理 
        else if ([code isEqualToString:@"bid_limited"])
        {
            [MBProgressHUD zx_hideHUDForView:nil];
            [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:[error localizedDescription] message:nil cancelButtonTitle:NSLocalizedString(@"关闭", nil) cancleHandler:nil doButtonTitle:NSLocalizedString(@"联系客服", nil) doHandler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf.view zx_performCallPhoneApplication:@"4006660998"];
            }];
        }
        //没有认证，受到限制；公开上架多少件产品；
        else if ([code isEqualToString:@"num_of_product_too_less"])
        {
            [MBProgressHUD zx_hideHUDForView:nil];
            [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:[error localizedDescription]  message:nil cancelButtonTitle:NSLocalizedString(@"关闭", nil) cancleHandler:nil doButtonTitle:NSLocalizedString(@"去传产品", nil) doHandler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_ProductManageController withData:@{@"selectIndex":@(0)}];
            }];
        }
        else
        {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }
        _doSomeThing = NO;
    }];

}
//联系对方，打电话
- (IBAction)callIphoneAction:(UIButton *)sender {
    
    if (!self.dataModel.myCommitModel)
    {
        [MobClick event:kUM_b_contactbuyer]; // 未接
        [MBProgressHUD zx_showError:NSLocalizedString(@"接单后即可联系采购商！", nil) toView:nil];
    }
    else
    {
//        [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_Trade identifier:@"TradeOrderSuccessViewController" withData:@{@"telString":self.dataModel.phoneNum,@"tradeId":self.dataModel.postId,@"isForeign":@(NO)}];
//        return;
        [MobClick event:kUM_b_businesscall_2]; //已接
        
        if (self.dataModel.tradeType == WYTradeType_foreignDirect)
        { //外商
            if ([NSString zhIsBlankString:self.dataModel.mobile]&&[NSString zhIsBlankString:self.dataModel.email]) {
                [WYAlertViewController presentedBy:self message:@"这个采购商没有留下联系方式噢～可以尝试与他进行在线沟通。" bottonBtnTitle:@"知道了" bottonBtnBlock:nil];
            }else{
                [TradeDetailForeignInfoController presentBy:self email:self.dataModel.email mobile:self.dataModel.mobile];
            }
        }else{
            [self.view zx_performCallPhone:self.dataModel.phoneNum];
        }
        
    }
}




- (void)popToMainListController
{
//    返回的时候，告诉已经被接单，重复接单
    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Trade_subjectCompleted object:nil userInfo:@{@"tradeId":self.dataModel.postId}];

    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1]animated:YES];
}

//介绍给朋友
-(void)shareFriends
{
    
    if (!_dataModel)
    {
        return;
    }
    [MobClick event:kUM_b_businessshare];
    WS(weakSelf);
    //分享
    [[[AppAPIHelper shareInstance] getMessageAPI] getShareWithType:@25 success:^(id data) {
        
        shareModel *model = data;
        NSString *titleStr = [model.title stringByReplacingOccurrencesOfString:@"{productName}" withString:weakSelf.dataModel.title];
        NSString *link = [model.link stringByReplacingOccurrencesOfString:@"{id}" withString:weakSelf.dataModel.postId];
        NSString *picStr = model.pic;
        if (weakSelf.dataModel.photosArray.count>0)
        {
            picStr = [[weakSelf.dataModel.photosArray firstObject] picURL];
        }

        [WYShareManager shareInVC:weakSelf withImage:picStr withTitle:titleStr withContent:model.content withUrl:link];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
    
}


@end
