//
//  WYMessageListViewController.m
//  YiShangbao
//
//  Created by Lance on 16/12/7.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYMessageListViewController.h"
#import "WYMessageListTableViewCell.h"
#import "MessageDetailListViewController.h"
#import "MessageStackViewCell.h"

#import "NTESSessionViewController.h"
#import "NTESBundleSetting.h"
#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "WYNIMAccoutManager.h"
#import "NTESCellLayoutConfig.h"
#import "WYWKWebViewController.h"
#import "JLDragImageView.h"

@interface WYMessageListViewController ()<UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate,ZXMenuIconCollectionViewDelegate,ZXMenuIconCollectionViewDelegateFlowLayout,UIViewControllerPreviewingDelegate,JLDragImageViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataMArray;
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) MessageModel *messageModel;

@property (nonatomic, strong) JLDragImageView *tradeMoveView;
// 客服聊天id
@property (nonatomic, copy) NSString *supportIMAccid;
@end

@implementation WYMessageListViewController
//海狮帐号：15757126387

- (void)viewDidLoad {
    [super viewDidLoad];
    

//    NSString *userID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
//    NSLog(@"userId =%@",userID);
    [self creatUI];
    [self setData];
//    UINavigationItem *item = self.navigationController.navigationBar.topItem;
//    NSLog(@"%@",item);
   
}

- (void)dealloc{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.tableView isRefreshing])
    {
        [self requestData];
//        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)creatUI{
    //tableview
    self.navigationItem.title = @"消息";
    
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"E5E5E5"];

    self.autoRemoveRemoteSession = [[NTESBundleSetting sharedConfig] autoRemoveRemoteSession];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    
    NSLog(@"%@",self.navigationItem.backBarButtonItem);
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WYMessageListTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageStackViewCell class]) bundle:nil] forCellReuseIdentifier:@"MessageStackViewCell"];

    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate =self;
    self.emptyViewController = emptyVC;
    
    if (Device_SYSTEMVERSION_IOS9_OR_LATER)
    {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
        {
            [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(previewActionShare:) name:@"previewActionShare" object:nil];
        }
    }
}



- (void)setData
{
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
    [self.tableView.mj_header beginRefreshing];
    [self requestDragSupportIM];
}

- (void)requestData
{
    if (![UserInfoUDManager isLogin])
    {
        return;
    }
    [self requestHeaderData];
    [self requestDragSupportIM];
}



- (void)zxEmptyViewUpdateAction
{
    [self requestHeaderData];
}

- (void)requestHeaderData
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] messageAPI] getAbbrMsgListWithsuccess:^(id data) {
        
        MessageModel *model  = (MessageModel *)data;
        self.messageModel = model;
        [_dataMArray removeAllObjects];
        [_dataMArray addObjectsFromArray:model.list];
        
        [_emptyViewController hideEmptyViewInController:weakSelf hasLocalData:_dataMArray.count>0?YES:NO];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.f];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_TabBarItem_Message_unreadCount object:nil];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        if (weakSelf.recentSessions.count==0)
        {
            [_emptyViewController addEmptyViewInController:weakSelf hasLocalData:_dataMArray.count>0?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        }
    }];

}


#pragma mark - 加载最新数据
- (void)headerRefresh{
    
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestHeaderData];
    }];
}


//拖动在线客服按钮内容
- (void)requestDragSupportIM
{
    if ([WYUserDefaultManager getUserTargetRoleType] !=WYTargetRoleType_seller)
    {
        return;
    }

    
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getNimAccountAPI]getNIMSupportIMAccidWithSuccess:^(id data) {
        
        NSString *accid = [data objectForKey:@"accid"];
        //拖动按钮
        if (!weakSelf.tradeMoveView)
        {
            weakSelf.tradeMoveView = [[JLDragImageView alloc] init];
            weakSelf.tradeMoveView.delegate = self;
            weakSelf.tradeMoveView.jl_sectionInset = UIEdgeInsetsMake(HEIGHT_NAVBAR, 0, 0, 0);
            UIImage *image = [UIImage imageNamed:@"btu_lianxikefu"];
            weakSelf.tradeMoveView.image = image;
            [weakSelf.tradeMoveView showSuperview:weakSelf.view frameOffsetX:0 offsetY:21 Width:image.size.width Height:image.size.height];
        }
        weakSelf.supportIMAccid = accid;
        weakSelf.tradeMoveView.hidden = [NSString zhIsBlankString:accid];
   
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0)
    {
        return self.messageModel.grid.count>0?1:0;
    }
    else if (section ==1)
    {
       return self.dataMArray.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==1 && self.dataMArray.count>0 && self.messageModel.grid.count>0)
    {
        return LCDScale_iPhone6_Width(12.f);
    }
    else if (section ==2 && self.recentSessions.count>0)
    {
        return LCDScale_iPhone6_Width(12.f);
    }
    return 0.1;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0)
    {
        MessageStackViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageStackViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.menuIconCollectionView.delegate = self;
        cell.menuIconCollectionView.flowLayoutDelegate = self;
        if (self.messageModel.grid.count > 0)
        {
            [cell setData:self.messageModel.grid];
        }
        return cell;
    }
    else if (indexPath.section ==1)
    {
        WYMessageListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataMArray.count > 0)
        {
            MessageModelSub *model = [self.dataMArray objectAtIndex:indexPath.row];
            [cell setData:model];
        }
        return cell;

    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}



#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0)
    {
        static MessageStackViewCell *cell =  nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"MessageStackViewCell"];
        });
        return [cell getCellHeightWithContentIndexPath:indexPath data:self.messageModel.grid];
    }
    return LCDScale_5Equal6_To6plus(70);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0 ||indexPath.section ==1)
    {
        return NO;
    }
    return YES;
}

//- (CGSize)zx_menuIconCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(LCDScale_iPhone6_Width(80), LCDScale_iPhone6_Width(80));
//}



/**
 *  重新加载所有数据，调用时必须先调用父类方法
 *
 */
- (void)refresh
{
    [super refresh];
}


//选中某一条最近会话时触发的事件回调
- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0)
    {
        return;
    }
    else if (indexPath.section ==1)
    {
        
        MessageModelSub *model = [self.dataMArray objectAtIndex:indexPath.row];
        if (![NSString zhIsBlankString:model.url])
        {
            [[WYUtility dataUtil]routerWithName:model.url withSoureController:self];
            
            [[[AppAPIHelper shareInstance] messageAPI] markMsgReadWithType:@(model.type) success:^(id data){
                
            } failure:^(NSError *error) {
            }];
        }
        else
        {
            [self addUMClick:model];
            MessageDetailListViewController *vc = [[MessageDetailListViewController alloc] init];
            vc.type = @(model.type);
            vc.typeName = model.typeName;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        WS(weakSelf);
        if ([[WYNIMAccoutManager shareInstance]cheackAccoutEnable:self])
        {
            [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
            [[[AppAPIHelper shareInstance]getNimAccountAPI]getChatUserIMInfoWithIDType:NIMIDType_NIMAccout thisId:recent.session.sessionId success:^(id data) {
                
                [MBProgressHUD zx_hideHUDForView:weakSelf.view];
                
                NSString *hisUrl = [data objectForKey:@"url"];
                NSString *shopUrl = [data objectForKey:@"shopUrl"];
                NIMSession *session = [NIMSession session:recent.session.sessionId type:NIMSessionTypeP2P];
                NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                vc.hisUrl = hisUrl;
                vc.shopUrl = shopUrl;
//                vc.hideUnreadCountView = NO;
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
            }];

        }
        
    }
}

- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath
{
    if (recent.session.sessionType == NIMSessionTypeP2P)
    {
    }
}


- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
    if ([recent.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        return @"我的电脑";
    }
    return [super nameForRecentSession:recent];
}


- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent{
    
    NIMMessage *lastMessage = recent.lastMessage;
    NSString *content = nil;
    if (lastMessage.messageType == NIMMessageTypeCustom)
    {
        NIMCustomObject *object = lastMessage.messageObject;
        id attachment = object.attachment;
        if([attachment isKindOfClass:[NTESAttachment class]])
        {
            NTESAttachment *attach = (NTESAttachment *)attachment;
            NTESCustomProductLinkModel *model = attach.model;
            content = [NSString stringWithFormat:@"[链接]%@",model.title];
        }
        else if([attachment isKindOfClass:[NTESSendProductLinkAttachment class]])
        {
            NTESSendProductLinkAttachment *attach = (NTESSendProductLinkAttachment *)attachment;
            NTESSendProductLinkModel *model = attach.model;
            content = [NSString stringWithFormat:@"[链接]%@",model.name];
        }
        return [[NSAttributedString alloc] initWithString:content ?: @""];
    }
    
    return [super contentForRecentSession:recent];
}




- (NSString *)timestampDescriptionForRecentSession:(NIMRecentSession *)recent
{
    return  [super timestampDescriptionForRecentSession:recent];
}

#pragma mark - UIViewControllerPreviewingDelegate

- (nullable UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0)
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGRect rect = cell.frame;
        previewingContext.sourceRect = rect;
        if (indexPath.section ==1)
        {
            MessageModelSub *model = [self.dataMArray objectAtIndex:indexPath.row];
            if ([NSString zhIsBlankString:model.url])
            {
                NSString *detailUrl = [NSString stringWithFormat:@"microants://messageList?type=%@&title=%@",@(model.type),model.typeName];
                return [[WYUtility dataUtil] previewingNewControllerViewWithRouteUrl:detailUrl];
            }
            else
            {
                UIViewController *vc = [[WYUtility dataUtil] previewingNewControllerViewWithRouteUrl:model.url];
                if([vc isKindOfClass:[WYWKWebViewController class]])
                {
                    WYWKWebViewController *wkVC = (WYWKWebViewController *)vc;
                    wkVC.barTitle = model.typeName;
                    return wkVC;
                }
                return vc;
            }
        }
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}

- (void)previewActionShare:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    // 默认图片地址
    NSString *picStr = @"http://public-read-bkt-oss.oss-cn-hangzhou.aliyuncs.com/app/icon/logo_zj.png";
    NSString *link = [dic objectForKey:@"url"];
    NSString *title = [dic objectForKey:@"title"];
    [WYShareManager shareInVC:self withImage:picStr withTitle:title withContent:@"用了义采宝，生意就是好!" withUrl:link];
}


#pragma mark -ZXMenuIconCollectionViewDelegate

- (void)zx_menuIconView:(ZXMenuIconCollectionView *)labelsTagView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModelSub *model = [self.messageModel.grid objectAtIndex:indexPath.item];
    [self addUMClick:model];
    MessageDetailListViewController *vc = [[MessageDetailListViewController alloc] init];
    vc.type = @(model.type);
    vc.typeName = model.typeName;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)addUMClick:(MessageModelSub *)model
{
    switch (model.type)
    {
        case 7:[MobClick event:kUM_b_mestrade];break;
        case 1:[MobClick event:kUM_b_mesannouncement];break;
        case 3:[MobClick event:kUM_b_mesnotification];break;
        case 9:[MobClick event:kUM_b_mestodolist];break;
        case 2:[MobClick event:kUM_b_mesactivity];break;
        case 8:[MobClick event:kUM_b_messchool];break;
            //            推广动态
        case 10:;break;
            
        default:
            break;
    }
    
}



# pragma  mark - 广告点击 JLDragImageViewDelegate

-(void)JLDragImageView:(JLDragImageView *)view tapGes:(UITapGestureRecognizer *)tapGes
{
//    WS(weakSelf);
//    if ([[WYNIMAccoutManager shareInstance]cheackAccoutEnable:self])
//    {
//        [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
//        [[[AppAPIHelper shareInstance]getNimAccountAPI]getChatUserIMInfoWithIDType:NIMIDType_NIMAccout thisId:self.supportIMAccid success:^(id data) {
//
//            [MBProgressHUD zx_hideHUDForView:weakSelf.view];
//
//            NSString *hisUrl = [data objectForKey:@"url"];
//            NSString *shopUrl = [data objectForKey:@"shopUrl"];
//            NIMSession *session = [NIMSession session:self.supportIMAccid type:NIMSessionTypeP2P];
//            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
//            vc.hisUrl = hisUrl;
//            vc.shopUrl = shopUrl;
//            //                vc.hideUnreadCountView = NO;
//            vc.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//
//        } failure:^(NSError *error) {
//
//            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
//        }];
//
//    }

    NIMSession *session = [NIMSession session:self.supportIMAccid type:NIMSessionTypeP2P];
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
//  vc.hideUnreadCountView = NO;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
