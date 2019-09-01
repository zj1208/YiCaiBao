//
//  AddProductController.m
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AddProductController.h"
#import "ZXActionTitleView.h"
#import "TMDiskManager.h"
#import "AddProductModel.h"
#import "ModelNumberCell.h"
#import "ProductContentCell.h"
#import "MainBusinessCell.h"
#import "HeaderPicsViewCell.h"

#import "AddProductPicController.h"
#import "ProductMdoleAPI.h"

#import "ProductManageController.h"
#import "ZXCenterBottomToolView.h"
#import "ZXAddPicCollectionView.h"
#import "TZImagePickerController.h"
#import "XLPhotoBrowser.h"
#import "ZXCenterTitleView.h"
#import "ZXTowBtnBottomToolView.h"
#import "UIViewController+ZXSystemBackButtonAction.h"
#import "AliOSSUploadManager.h"
#import "WYSearchCategoryViewController.h"
#import "CCChooseVideoViewController.h"
#import <Photos/Photos.h>
#import "CCVideoPlayerViewController.h"
#import "WYChooseShopCateViewController.h"
#import "IQKeyboardManager.h"
#import "ZXKeyboardManager.h"

#import "ZXTableViewUnfoldFooterView.h"
#import "AddProFreightViewController.h"
#import "CustomAddPicLayoutConfig.h"
#import "GuideAddProController.h"

@interface AddProductController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,ZXAddPicCollectionViewDelegate,TZImagePickerControllerDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource,WYSearchCategoryViewControllerDelegate,UITextFieldDelegate>

@property (nonatomic, copy) NSArray *sectionFirstArray;
@property (nonatomic, copy) NSArray *sectionSecondArray;
@property (nonatomic, copy) NSArray *sectionThirdArray;

@property (nonatomic, strong) TMDiskManager *diskManager;

@property (nonatomic, strong) ModelNumberCell *modelNumberCell;
@property (nonatomic, strong) ProductContentCell *contentCell;
//@property (nonatomic, strong) HeaderPicsViewCell *photoCell;


@property (nonatomic, strong) ProductPutawayInitModel *putawayInitModel;

@property (nonatomic, strong) NSMutableArray *photosMArray;

@property (nonatomic, assign, getter=isUnfoldTable) BOOL unfoldTable;


@property (nonatomic, strong) UIButton *publicPrivChangeBtn;

//@property (nonatomic, assign) CGRect activedTextFieldRect;

@property (nonatomic, assign) BOOL useWm;

@end

static NSString * const CellId_headerPicsView = @"picCell";
static NSString * const CellId_contentCell = @"contentCell";



@implementation AddProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    [[CitiesDataTool sharedManager] requestGetData];
//    self.chooseLocationView.address = @"广东省 广州市 越秀区";
//    self.chooseLocationView.areaCode = @"440104";
//    self.addresslabel.text = @"广东省 广州市 越秀区";
    [self initUI];
    [self initData];
    [self requestInitData];
}


- (BOOL)isUnfoldTable
{
    return _unfoldTable;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO] ;
//    [self registerForKeyboardNotifications];
    [[ZXKeyboardManager sharedInstance]registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
//    [self removeObserverForKeyboardNotifications];
    [[ZXKeyboardManager sharedInstance]removeObserverForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self lauchFirstNewFunction];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

//- (void)textFieldBeginEditing:(NSNotification *)noti
//{
//    UITextField *textField = noti.object;
//    self.activedTextFieldRect = [textField.superview convertRect:textField.frame toView:self.tableView];
//}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//- (void)registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
//- (void)removeObserverForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//}
//
//- (void)keyboardWillShow:(NSNotification *)noti
//{
//    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
//
//    if ((self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height+HEIGHT_NAVBAR) >  ([UIScreen mainScreen].bounds.size.height - rect.size.height-40))
//    {
//        [UIView animateWithDuration:duration animations:^{
//            self.tableView.contentOffset = CGPointMake(0, 64 + self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height-40));
//        }];
//    }
//}
//- (void)keyboardWillHide:(NSNotification *)noti
//{
//    [self.tableView scrollRectToVisible:CGRectMake(0, 1, 1, 1) animated:NO];
//}
//


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - initUI

- (void)initUI
{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    self.tableView.separatorColor = self.tableView.backgroundColor;
    self.tableView.separatorInset = UIEdgeInsetsZero;
//    self.tableView.separatorColor = [UIColor redColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = 60.f;
    self.tableView.contentInset = inset;

    
    if (self.controllerDoingType ==ControllerDoingType_EditProduct)
    {
        self.title =NSLocalizedString(@"编辑产品", nil);
        self.bottomContainerView.hidden = YES;
        self.bottomContainerView.alpha = 0;
        self.saveBtn.hidden = YES;
    }
    else
    {
        self.saveBtn.hidden = YES;
        [self addBottomView2];
    }
    
    self.tableView.estimatedRowHeight = 45.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self addFooterView];
}

- (void)lauchFirstNewFunction
{
    if (![WYUserDefaultManager getNewFunctionGuide_AddProPicV1])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GuideAddProController *vc = [sb instantiateViewControllerWithIdentifier:SBID_GuideAddProController];
        [self.tabBarController addChildViewController:vc];
        [self.tabBarController.view addSubview:vc.view];
    }
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.tableFooterView.zx_height = 115;
}
#pragma mark-底部视图+收回/展开

- (void)addFooterView
{
    ZXTableViewUnfoldFooterView *footerView = [ZXTableViewUnfoldFooterView zx_viewFromNib];
    footerView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableFooterView = footerView;
    WS(weakSelf);
    footerView.footerActionBlock = ^(UIButton *footerBtn) {
        
        [MobClick event:kUM_b_product_moreinfo];
        
        weakSelf.unfoldTable = footerBtn.selected;

        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 2)] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView endUpdates];
    };
    if (self.controllerDoingType ==ControllerDoingType_EditProduct)
    {
        self.tableView.tableFooterView.hidden = YES;
    }
}

// 请求完后 添加编辑的底部视图
-(void)addToolbar
{
    [self.bottomContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, LCDScale_iPhone6_Width(103), CGRectGetHeight(self.bottomContainerView.frame)-16);
    [btn1 zx_setBorderWithRoundItem];
    [btn1 setImage:[UIImage imageNamed:@"ic_shanchu"] forState:UIControlStateNormal];
    [btn1 setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [btn1 zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [btn1 setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    [btn1 addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, LCDScale_iPhone6_Width(103), CGRectGetHeight(self.bottomContainerView.frame)-16);
    [btn2 zx_setBorderWithRoundItem];
    [btn2 setImage:[UIImage imageNamed:@"ic_xiajia"] forState:UIControlStateNormal];
    [btn2 setTitle:NSLocalizedString(@"下架", nil) forState:UIControlStateNormal];
    [btn2 zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [btn2 setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    [btn2 addTarget:self action:@selector(soldOutAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, 0, LCDScale_iPhone6_Width(103), CGRectGetHeight(self.bottomContainerView.frame)-16);
    [btn3 zx_setBorderWithRoundItem];
    UIImage *backgroundImage2 = [WYUTILITY getCommonVersion2RedGradientImageWithSize:btn3.frame.size];
    [btn3 setBackgroundImage:backgroundImage2 forState:UIControlStateNormal];
    
    [btn3 setTitle:NSLocalizedString(@"转为公开", nil) forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(toPublicPrivChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar3 = [[UIBarButtonItem alloc]initWithCustomView:btn3];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.publicPrivChangeBtn = btn3;
    
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(0, 0, LCDScale_iPhone6_Width(158), CGRectGetHeight(self.bottomContainerView.frame)-16);
    [btn4 zx_setBorderWithRoundItem];
    UIImage *backgroundImage = [WYUTILITY getCommonVersion2RedGradientImageWithSize:btn4.frame.size];
    [btn4 setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [btn4 setTitle:NSLocalizedString(@"公开上架", nil) forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn4 addTarget:self action:@selector(soldoutionProductToPublic:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar4 = [[UIBarButtonItem alloc]initWithCustomView:btn4];

    
    
    UIToolbar *toolbar =[[UIToolbar alloc] init];
    [self.bottomContainerView addSubview:toolbar];

    [toolbar setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionBottom                      barMetrics:UIBarMetricsDefault];
    [toolbar setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionBottom];
    
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(_bottomContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    _bottomContainerView.hidden =NO;

    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    if ([model.status integerValue] == ProductEditStatus_SoldOut)
    {
        btn1.zx_width =LCDScale_iPhone6_Width(158);
        NSArray *array = [NSArray arrayWithObjects:bar1,space,bar4,nil];
        [toolbar setItems:array animated:YES];
    }
    else
    {
        if ([model.status integerValue] ==ProductEditStatus_PublicPro)
        {
            [btn3 setTitle:NSLocalizedString(@"转为私密", nil) forState:UIControlStateNormal];
        }
        NSArray *array = [NSArray arrayWithObjects:bar1,space,bar2,space,bar3,nil];
        [toolbar setItems:array animated:YES];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        _bottomContainerView.alpha = 1;

    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)addBottomView2
{
    [self.bottomContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    ZXTowBtnBottomToolView * view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXTowBtnBottomToolView class]) owner:self options:nil] firstObject];
    view.backgroundColor = [UIColor clearColor];
    [self.bottomContainerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(_bottomContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
   
    NSMutableAttributedString *line1Att = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@" 设为私密", nil) attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                                   NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    UIImage *attachImg = [UIImage imageNamed: @"ic_simi"];
    textAttachment.image = attachImg;  //设置图片源
    textAttachment.bounds = CGRectMake(0, -4, attachImg.size.width, attachImg.size.height);          //设置图片位置和大小
    NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [line1Att insertAttributedString:attrStr atIndex:0];
    
    NSAttributedString *line2Att = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"(不公开只能分享查看)", nil) attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                          NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    [view.leftBtn zh_setTowOfLinesStringWithLineSpace:5.f firstLineWithAttributedTitle:line1Att secondLineWithAttributedTitle:line2Att];
    
    [view.leftBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    [view.leftBtn addTarget:self action:@selector(privacyBtnAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    view.leftBtnWidthLayout.constant = LCDScale_iPhone6_Width(162);
    UIImage *backgroundImage2 = [WYUTILITY getCommonVersion2RedGradientImageWithSize:view.rightBtn.frame.size];
    [view.rightBtn setBackgroundImage:backgroundImage2 forState:UIControlStateNormal];
    [view.rightBtn setTitle:NSLocalizedString(@"公开上架", nil) forState:UIControlStateNormal];
    [view.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [view.rightBtn addTarget:self action:@selector(uploadBtnAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
}



# pragma  mark - 初始化请求数据

- (void)requestInitData
{
    WS(weakSelf);
    if (self.controllerDoingType ==ControllerDoingType_EditProduct)
    {
         [MBProgressHUD zx_showLoadingWithStatus:@"正在加载..." toView:self.view];
         [ProductMdoleAPI getProductDetailInfoWithProductId:self.productId success:^(id data) {
             
             [MBProgressHUD zx_hideHUDForView:weakSelf.view];
             //请求回来判断 就知道是否是主营的；
             [weakSelf.diskManager setData:data];
             //设置原始数据是否是主营，来判断是否能响应是否主营的按钮及状态；
             [weakSelf.diskManager setPropertyImplementationValue:@([data isMain]) forKey:@"getEditOrinalIsMainPro"];
             [weakSelf setupZXPhotoModelArray:[data pics]];
             [weakSelf setupAddVideoModel:[data video]];
             [weakSelf.tableView reloadData];
             [weakSelf  addToolbar];
             if (self.controllerDoingType ==ControllerDoingType_EditProduct)
             {
                 self.tableView.tableFooterView.hidden = NO;
                 self.saveBtn.hidden = NO;
             }
//             //如果这里直接赋值，有问题，一旦页面还没有展示出来，就是还没有被重用初始化，则这里赋值就无效了；
//             AddProductModel *model = (AddProductModel *)data;
//             //货源类型
//             if ([model.sourceType integerValue] ==2)
//             {
//                 [weakSelf.contentCell getPromptGoodsAction:weakSelf.contentCell.noPromptGoodsBtn];
//             }
//             else
//             {
//                 [weakSelf.contentCell getPromptGoodsAction:weakSelf.contentCell.promptGoodsBtn];
//             }

             
         } failure:^(NSError *error) {
             
             [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
             [weakSelf performSelector:@selector(zx_goBackPreController) withObject:nil afterDelay:1.f];
         }];
    }
    else
    {
        
    }
    [self requestProuductInitData];
    
    [self requestQueryIsExistWaterMark];

}

#pragma mark - 请求配置接口

- (void)requestProuductInitData
{
    WS(weakSelf);
    [ProductMdoleAPI getProductPutawayInitWithSuccess:^(id data) {
        
        weakSelf.putawayInitModel = nil;
        weakSelf.putawayInitModel = [[ProductPutawayInitModel alloc] init];
        weakSelf.putawayInitModel = data;
        
        // 添加产品的时候改变默认主营
        if (weakSelf.controllerDoingType ==ControllerDoingType_AddProduct)
        {
            AddProductModel *model = (AddProductModel *)[_diskManager getData];
            model.sysCateId = weakSelf.putawayInitModel.sysCateId;
            model.sysCateName = weakSelf.putawayInitModel.sysCateName;
            if (!weakSelf.putawayInitModel.ifRadioDisplay)
            {
                model.isMain = NO;
            }
            else
            {
                model.isMain = YES;
            }
            [weakSelf.diskManager setData:model];
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 检查是否启用水印
- (void)requestQueryIsExistWaterMark
{
    [ProductMdoleAPI getQueryIsExistWaterMarkWithSuccess:^(id data) {
        
        if (data)
        {
            NSNumber *useWmNum = (NSNumber *)data;
           _useWm = [useWmNum boolValue];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

# pragma mark - 初始化数据

- (void)initData
{
    NSArray *sectionFirstArray = @[NSLocalizedString(@"*所属类目:", nil),NSLocalizedString(@"*价格(元):", nil),NSLocalizedString(@"*货源类型:", nil),NSLocalizedString(@"*运费设置:", nil)];
    self.sectionFirstArray = sectionFirstArray;
    self.sectionSecondArray = @[NSLocalizedString(@"货号/型号:", nil),NSLocalizedString(@"规格尺寸:", nil),NSLocalizedString(@"箱规:", nil)];
    self.sectionThirdArray = @[NSLocalizedString(@"本店分类:", nil),NSLocalizedString(@"图文详情", nil)];
    

    [self addKeyboardManager];
    // 初始化本地数据
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    
    AddProductModel *model = [[AddProductModel alloc] init];
    [self.diskManager setData:model];
    if (self.controllerDoingType ==ControllerDoingType_AddProduct)
    {
        
        [self.diskManager setPropertyImplementationValue:self.shopClassifys forKey:NSStringFromSelector(@selector(shopCatgs))];
    }
 
    // 监听本地数据改变；
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productInfoChange:) name:TMDiskAddProcutKey object:nil];
 

    //初始化oss上传
    
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
    [AliOSSUploadManager sharedInstance].getPicInfo = YES;

//    存储ZXPhoto对象的数组
    NSMutableArray *photos = [NSMutableArray array];
    self.photosMArray = photos;
}

- (void)addKeyboardManager
{
    ZXKeyboardManager *keyboardManager = [ZXKeyboardManager sharedInstance];
    keyboardManager.superView = self.tableView;
}

- (void)setupZXPhotoModelArray:(NSArray *)aliossModelArray
{
    
    [aliossModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AliOSSPicUploadModel *model = (AliOSSPicUploadModel *)obj;
        NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.p];
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:model.p thumbnailUrl:picUrl.absoluteString];
        photo.width = model.w;
        photo.height = model.h;
        [_photosMArray addObject:photo];
    }];
}

- (void)setupAddVideoModel:(NSString *)video
{
    if (![NSString zhIsBlankString:video])
    {
        ZXPhoto *photo = [[ZXPhoto alloc] init];
        photo.videoURLString = video;
        photo.type = ZXAssetModelMediaTypeVideo;
        [_photosMArray insertObject:photo atIndex:0];
    }

}

- (void)productInfoChange:(id)notification
{
    [self.tableView reloadData];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.controllerDoingType ==ControllerDoingType_EditProduct)
    {
        AddProductModel *model = (AddProductModel *)[self.diskManager getData];
        return [NSString zhIsBlankString:model.name]?0:6;
    }
    return 6;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
   
        case 0:return 1;break;
        case 2:return 4; break;
        case 3:return self.isUnfoldTable?3:0; break;
        case 4:return self.isUnfoldTable?2:0; break;

        default:return 1;
            break;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return LCDScale_5Equal6_To6plus(25.f);
    }
      return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==0)
    {
//        ZXCenterTitleView * view = [[[NSBundle mainBundle] loadNibNamed:@"ZXCenterTitleView" owner:self options:nil] firstObject];
//        [view.centerBtn setTitle:@"上传照片" forState:UIControlStateNormal];
//        [view.centerBtn setImage:[UIImage imageNamed:@"pic_shanghcuanzhaopian"] forState:UIControlStateNormal];
//        view.centerBtnWidthLayout.constant = 80.f;
//        [view.centerBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
//        view.centerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        view.backgroundColor =WYUISTYLE.colorBGgrey;
//        return view;
        ZXActionTitleView * titleView = [[[NSBundle mainBundle] loadNibNamed:@"ZXActionTitleView" owner:self options:nil] lastObject];
        [titleView.btn setTitle:NSLocalizedString(@"长按可以拖动图片,调整图片顺序", nil) forState:UIControlStateNormal];
        titleView.btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [titleView.btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        titleView.backgroundColor =WYUISTYLE.colorBGgrey;
        titleView.btn.userInteractionEnabled = NO;
        return titleView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:return LCDScale_5Equal6_To6plus(25.f); break;
//        case 4:{
//
//            if (self.controllerDoingType == ControllerDoingType_AddProduct && _putawayInitModel)
//            {
//                if (!_putawayInitModel.ifRadioDisplay)
//                {
//                    return 0.1f;
//                }
//            }
//            return LCDScale_5Equal6_To6plus(10.f);
//        }
        case 3:return self.isUnfoldTable?LCDScale_5Equal6_To6plus(10.f):0.1; break;
        case 4:return self.isUnfoldTable?LCDScale_5Equal6_To6plus(10.f):0.1; break;
        default:return LCDScale_5Equal6_To6plus(10.f);
            break;
    }
    return 0.1f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section ==0)
    {
        ZXActionTitleView * titleView = [[[NSBundle mainBundle] loadNibNamed:@"ZXActionTitleView" owner:self options:nil] lastObject];
        [titleView.btn setTitle:NSLocalizedString(@"带*为必填项", nil) forState:UIControlStateNormal];
        titleView.btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [titleView.btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        titleView.backgroundColor =WYUISTYLE.colorBGgrey;
        titleView.btn.userInteractionEnabled = NO;
        return titleView;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    if (indexPath.section ==0)
    {
        HeaderPicsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId_headerPicsView forIndexPath:indexPath];
         cell.picsCollectionView.delegate = self;
        [cell setData:_photosMArray];
        return cell;
    }
    if (indexPath.section ==1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        cell.textLabel.attributedText = [self titleLabelAttributedString:NSLocalizedString(@"*产品名称:", nil)];

        if (indexPath.row ==0)
        {
            cell.detailTextLabel.text = model.name?model.name:NSLocalizedString(@"例如:8寸大菜盘家用碗盘子水果盘陶瓷盘",nil);
            cell.detailTextLabel.textColor = model.name?UIColorFromRGB_HexValue(0x222222):UIColorFromRGB_HexValue(0xC2C2C2);
        }
        return cell;
    }
    if (indexPath.section ==2)
    {
        return [self secondSectionTableViewCell:tableView forRowAtIndexPath:indexPath model:model];
    }
    if (indexPath.section ==3)
    {
        return [self thirdSectionTableViewCell:tableView forRowAtIndexPath:indexPath model:model];
    }
//    本店分类，图文
    if (indexPath.section ==4)
    {
        return [self fourthSectionTableViewCell:tableView forRowAtIndexPath:indexPath model:model];
    }
//    设置主营
    MainBusinessCell *mainBusinessCell = [self.tableView dequeueReusableCellWithIdentifier:@"mainBusinessCell"];
    mainBusinessCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [mainBusinessCell.mainBusinessBtn addTarget:self action:@selector(mainBusinessBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.putawayInitModel)
    {
        [mainBusinessCell setData:self.putawayInitModel doingType:(int)_controllerDoingType];
    }
    return mainBusinessCell;
}

- (UITableViewCell *)secondSectionTableViewCell:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath model:(AddProductModel *)model
{
    if (indexPath.row ==0 || indexPath.row ==1|| indexPath.row ==3)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        cell.textLabel.attributedText = [self titleLabelAttributedString: [self.sectionFirstArray objectAtIndex:indexPath.row]];
        
        if (indexPath.row ==0)
        {
            cell.detailTextLabel.text = model.sysCateName?model.sysCateName:NSLocalizedString(@"选择精确分类，更易搜索",nil);
            cell.detailTextLabel.textColor = model.sysCateName?UIColorFromRGB_HexValue(0x222222):UIColorFromRGB_HexValue(0xC2C2C2);
        }
        else if (indexPath.row ==1)
        {
            //                3.26-改为阶梯价格
            NSString *price = [model.priceGrads isEqualToString:@"1,-1"]?NSLocalizedString(@"价格面议",nil):NSLocalizedString(@"已设置价格",nil);
            cell.detailTextLabel.text = model.priceGrads?price:NSLocalizedString(@"未设置",nil);
            cell.detailTextLabel.textColor = model.priceGrads?UIColorFromRGB_HexValue(0x222222):UIColorFromRGB_HexValue(0xC2C2C2);
        }
        //            运费
        else if (indexPath.row ==3)
        {
            NSString *detailText = nil;
            if (!model.freightId)
            {
                detailText = NSLocalizedString(@"未设置",nil);
            }
            else if ([model.freightId isEqualToNumber:@(-1)])
            {
                detailText = NSLocalizedString(@"买家到付",nil);
            }
            else if ([model.freightId isEqualToNumber:@(0)])
            {
                detailText = NSLocalizedString(@"免运费",nil);
            }
            else
            {
                detailText = model.freightName;
            }
            cell.detailTextLabel.text = detailText;
            cell.detailTextLabel.textColor =model.freightId?UIColorFromRGB_HexValue(0x222222):UIColorFromRGB_HexValue(0xC2C2C2);
        }
        return cell;
    }
    
    ProductContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId_contentCell forIndexPath:indexPath];
    //货源类型
    if ([model.sourceType integerValue] ==2)
    {
        [cell setPromptGoodsWithButton:cell.noPromptGoodsBtn];
    }
    else
    {
        [cell setPromptGoodsWithButton:cell.promptGoodsBtn];
    }
    self.contentCell = cell;
    return cell;
}

- (UITableViewCell *)thirdSectionTableViewCell:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath model:(AddProductModel *)model
{
    if (indexPath.row ==0)
    {
        ModelNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"modelNumberCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.modelNumberCell = cell;
        if (![NSString zhIsBlankString:model.model])
        {
            cell.textField.text = model.model;
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        cell.textLabel.text = [self.sectionSecondArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        //            规格尺寸
        if (indexPath.row ==1)
        {
            cell.detailTextLabel.text =[NSString zhIsBlankString:model.spec]?NSLocalizedString(@"未设置",nil):NSLocalizedString(@"已设置",nil);
            cell.detailTextLabel.textColor = [NSString zhIsBlankString:model.spec]?UIColorFromRGB_HexValue(0xC2C2C2):UIColorFromRGB_HexValue(0x222222);
        }
        //            箱规
        else if (indexPath.row ==2)
        {
            if (!model.volumn && !model.weight&& !model.number&& [NSString zhIsBlankString:model.unitInBox])
            {
                cell.detailTextLabel.text = NSLocalizedString(@"未填写",nil);
                cell.detailTextLabel.textColor = UIColorFromRGB_HexValue(0xCCCCCC);
            }
            else
            {
                NSMutableArray *arr = [NSMutableArray array];
                if (model.volumn)
                {
                    [arr addObject:model.volumn];
                }
                if (model.weight)
                {
                    [arr addObject:model.weight];
                }
                if (model.number)
                {
                    [arr addObject:model.number];
                }
                if (model.unitInBox)
                {
                    [arr addObject:model.unitInBox];
                }
                NSString *str = [arr componentsJoinedByString:@","];
                cell.detailTextLabel.text = str;
                cell.detailTextLabel.textColor = UIColorFromRGB_HexValue(0x222222);
            }
        }
        
        return cell;
    }
}

- (UITableViewCell *)fourthSectionTableViewCell:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath model:(AddProductModel *)model
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
    cell.textLabel.text = [self.sectionThirdArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.row == 0)
    {
        cell.detailTextLabel.text = model.shopCatgs.count>0?[self getShopClassifyStringWithArray:model.shopCatgs]:NSLocalizedString(@"未设置",nil);
        cell.detailTextLabel.textColor = model.shopCatgs.count>0?UIColorFromRGB_HexValue(0x222222):UIColorFromRGB_HexValue(0xC2C2C2);
    }
    else if (indexPath.row ==1)
    {
        cell.detailTextLabel.text = [NSString zhIsBlankString:model.desc]?NSLocalizedString(@"未添加",nil):NSLocalizedString(@"已添加",nil);
        cell.detailTextLabel.textColor = [NSString zhIsBlankString:model.desc]?UIColorFromRGB_HexValue(0xC2C2C2):UIColorFromRGB_HexValue(0x222222);
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 )
    {
        static  HeaderPicsViewCell *cell = nil;
        static dispatch_once_t onceToken;
        //只会走一次
        dispatch_once(&onceToken, ^{
            cell = (HeaderPicsViewCell *)[tableView dequeueReusableCellWithIdentifier:CellId_headerPicsView];
        });
        CGFloat height = [cell.picsCollectionView getCellHeightWithContentData:_photosMArray];
        return height;
    }
//   隐藏设为主营一栏
//    else if (indexPath.section ==6)
//    {
//        if (self.controllerDoingType == ControllerDoingType_AddProduct && _putawayInitModel)
//        {
//            if (!_putawayInitModel.ifRadioDisplay)
//            {
//                return 0.1;
//            }
//        }
//    }
   
    return LCDScale_5Equal6_To6plus(45.f);
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGAffineTransform transformA = CGAffineTransformMakeScale(0.1, 0.1);
//    CGAffineTransform transformB = CGAffineTransformMakeRotation(M_PI_2);
//    cell.transform = CGAffineTransformConcat(transformA, transformB);
//    [UIView animateWithDuration:0.5 animations:^{
//       
//        cell.transform = CGAffineTransformIdentity;
//    }];
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section ==0)
    {
        [self picBtnAction:nil];
    }
    else if (indexPath.section ==1)
    {
        [self performSegueWithIdentifier:segue_AddProNameController sender:self];
    }
    else if (indexPath.section ==2)
    {
        [self secondSectionDidSelectRowAtIndexPath:indexPath];
    }
    else if (indexPath.section ==3)
    {
        [self thirdSectionDidSelectRowAtIndexPath:indexPath];
    }
    else if (indexPath.section ==4)
    {
        [self fourthSectionDidSelectRowAtIndexPath:indexPath];
    }

}

- (void)secondSectionDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0)
    {
        [self chooseSysCategory];
    }
    else if (indexPath.row == 1)
    {
        [self makePriceAction];
    }
    // 设置运费
    else if (indexPath.row ==3)
    {
        [MobClick event:kUM_b_product_express];
        [self performSegueWithIdentifier:segue_AddProFreightViewController sender:self];
    }
}
- (void)thirdSectionDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==1)
    {
        // 规格尺寸
        [self performSegueWithIdentifier:segue_AddProSpecController sender:self];
    }
    else if (indexPath.row ==2)
    {
        //箱规
        [self performSegueWithIdentifier:segue_ProductSizeController sender:self];
    }
}

- (void)fourthSectionDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // 本店分类
        [self chooseShopClassify];
    }
    else if (indexPath.row == 1)
    {
        // 图文详情
        [self performSegueWithIdentifier:segue_AddProBriefsController sender:self];
    }
}


#pragma mark - 富文本标题

- (NSMutableAttributedString *)titleLabelAttributedString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF5434"] range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    return attributedString;
}

#pragma mark - 所属类目

- (void)chooseSysCategory
{
    WYSearchCategoryViewController *vc = [[WYSearchCategoryViewController alloc] init];
    vc.delegate = self;
    vc.historyArray = _putawayInitModel.latestSysCates;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectedCategory:(NSString *)categoryString categoryId:(NSNumber *)cateId
{
    [self.diskManager setPropertyImplementationValue:cateId forKey:@"sysCateId" postNotification:NO];
    [self.diskManager setPropertyImplementationValue:categoryString forKey:@"sysCateName" postNotification:NO] ;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
    [self.navigationController popToViewController:self animated:YES];

}

#pragma mark - 价格

- (void)makePriceAction
{
    UIViewController * messageList =[[NSClassFromString(@"AddProPriceController") alloc]init];
    [self.navigationController pushViewController:messageList animated:YES];
}

#pragma mark- 选择本店分类

- (void)chooseShopClassify
{
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    WYChooseShopCateViewController *vc = (WYChooseShopCateViewController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_WYChooseShopCateViewController];
    [vc selectedArray:model.shopCatgs return:^(NSArray *selectedArray) {
        
        [_diskManager setPropertyImplementationValue:selectedArray forKey:@"shopCatgs" postNotification:YES];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSString *)getShopClassifyStringWithArray:(NSArray *)shopCatgs
{
    NSMutableArray *valuesMArray = [NSMutableArray array];
    [shopCatgs enumerateObjectsUsingBlock:^(CodeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [valuesMArray addObject:obj.value];
    }];
    NSString *valuesString = [valuesMArray componentsJoinedByString:@","];
    return valuesString;
}


#pragma mark - 设置为主营

- (void)mainBusinessBtnAction:(UIButton *)sender
{
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    if ([model.status isEqualToNumber:@(2)])
    {
        [MBProgressHUD zx_showError:@"私密产品无法设置为主营产品" toView:self.view];
        return;
    }
    else if ([model.status isEqualToNumber:@(0)])
    {
        [MBProgressHUD zx_showError:@"下架中产品无法设置为主营产品" toView:self.view];
        return;
    }
//    不展示20件用完了+当前不是主营产品
    if (!self.putawayInitModel.ifRadioDisplay && !model.getEditOrinalIsMainPro)
    {
        NSString *title = [NSString stringWithFormat:@"您已设置%@个主营产品，请先取消其他产品的主营设置，再设置主营产品哦～",self.putawayInitModel.totalTimes];
        [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:title message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"知道了" doHandler:nil];
        return;
    }
    sender.selected = !sender.selected;
    BOOL isMain = sender.selected;
    [self.diskManager setPropertyImplementationValue:@(isMain) forKey:@"isMain"];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 添加图片视频

- (void)picBtnAction:(id)sender
{
    if ([self getViedoStringFormPicArray:self.photosMArray])
    {
        [self presentImagePickerController];
        return;
    }
    NSString *title = NSLocalizedString(@"如需编辑水印,请至电脑编辑:www.iyicaibao.com", nil);
    NSString *otherTitle1 = NSLocalizedString(@"上传图片", nil);
    NSString *otherTitle2 = NSLocalizedString(@"上传视频", nil);
    WS(weakSelf);
    [UIAlertController zx_presentActionSheetInViewController:self withTitle:title message:nil cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:@[otherTitle1,otherTitle2] tapBlock:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {

        if (buttonIndex ==alertController.firstOtherButtonIndex)
        {
            [weakSelf presentImagePickerController];
        }
        else if (buttonIndex ==alertController.firstOtherButtonIndex+1)
        {
            [weakSelf presentChooseVideoController];
        }
    }];
}

- (void)presentChooseVideoController
{
    CCChooseVideoViewController *chooseVideoVC = [[CCChooseVideoViewController alloc]init];
    chooseVideoVC.maximumDuration = 10.0;
    WS(weakSelf);
    [chooseVideoVC returnVideoInfo:^(NSData *videoData, NSURL *playURL) {
        
        [weakSelf uploadVideoWith:videoData];
    }];
    [self.navigationController pushViewController:chooseVideoVC animated:YES];
}

- (void)uploadVideoWith:(NSData *)videoData
{
    WS(weakSelf);
    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];
    [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_ProductVideo uploadingData:videoData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    } singleComplete:^(id  _Nullable imageInfo, NSString * _Nullable imagePath, CGSize imageSize) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        ZXPhoto *photo = [[ZXPhoto alloc] init];
        photo.videoURLString = imagePath;
        photo.type = ZXAssetModelMediaTypeVideo;
        [weakSelf.photosMArray insertObject:photo atIndex:0];
//        [self.photoCell.picsCollectionView setData:_photosMArray];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];

    }];
}

- (void)presentImagePickerController
{
    //初始化多选择照片
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:(9-self.photosMArray.count) delegate:self];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePicker setSortAscendingByModificationDate:NO];
    //是否有选择原图
    imagePicker.allowPickingOriginalPhoto = NO;
    //    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    //用户选中的图片
    //    imagePicker.selectedAssets = _assestArray;
    //是否允许选择视频
    imagePicker.allowPickingVideo = NO;
    //是否可以拍照
    imagePicker.allowTakePicture = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark- TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    
 
    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];
    __block NSInteger currentIndex = 0;
    NSMutableArray *tempMArray = [NSMutableArray array];
    WS(weakSelf);
    [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImage *image = (UIImage *)obj;
        NSData *imageData = [WYUtility zipNSDataWithImage:image];
        
        [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_uploadProduct uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
        } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
            
            currentIndex ++;
            //这里处理上传图片
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:imagePath];
            ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:imagePath thumbnailUrl:picUrl.absoluteString];
            photo.width = imageSize.width;
            photo.height = imageSize.height;
            photo.type = ZXAssetModelMediaTypePhoto;
            [tempMArray addObject:photo];
            if (currentIndex ==photos.count){
                
                if (weakSelf.useWm)
                {
                    [weakSelf requestUploadGetWaterMarkPicWithPicUrls:tempMArray];
                }
                else
                {
                    NSArray * tempMArray2 = [AliOSSUploadManager sortAliOSSImage_UserID_time_WithPhotoModelArr:tempMArray];
                    
                    [weakSelf.photosMArray addObjectsFromArray:tempMArray2];
                    [MBProgressHUD zx_hideHUDForView:weakSelf.view];
                    [weakSelf.tableView reloadData];
                }
            }
       
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
        
    }];
    
}

- (void)requestUploadGetWaterMarkPicWithPicUrls:(NSMutableArray*)picUrlModels
{
    WS(weakSelf);
    __block NSInteger currentIndex = 0;
    NSMutableArray *tempMArray = [NSMutableArray array];
    [picUrlModels enumerateObjectsUsingBlock:^(ZXPhoto *  _Nonnull photo, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        [ProductMdoleAPI postUploadGetWaterMarkPicWithPicUrl:photo.original_pic success:^(id data) {
            
             currentIndex ++;
            if ([data isKindOfClass:[NSString class]])
            {
                photo.original_pic = data;
                NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:data];
                photo.thumbnail_pic = [picUrl absoluteString];
                [tempMArray addObject:photo];
                if (currentIndex ==picUrlModels.count)
                {
                    NSArray * tempMArray2 = [AliOSSUploadManager sortAliOSSImage_UserID_time_WithPhotoModelArr:tempMArray];
                    
                    [weakSelf.photosMArray addObjectsFromArray:tempMArray2];
                    [MBProgressHUD zx_hideHUDForView:weakSelf.view];
                    [weakSelf.tableView reloadData];
                }
            
            }
     
            
        } failure:^(NSError *error) {
            
        }];
    }];

}

#pragma mark - ZXAddPicCollectionViewDelegate

#pragma mark- 长按移动代理
- (BOOL)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView shouldLongPressGestureStateBeganCanMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item>=addPicCollectionView.dataMArray.count)
    {
        return NO;
    }
 
    id obj = [addPicCollectionView.dataMArray objectAtIndex:indexPath.item];
    if ([obj isKindOfClass:[ZXPhoto class]])
    {
        ZXPhoto *photo = (ZXPhoto *)obj;
        if (photo.type == ZXAssetModelMediaTypeVideo)
        {
            [MBProgressHUD zx_showError:NSLocalizedString(@"视频不能拖动哦!", nil) toView:self.view];
            return NO;
        }
    }
    BOOL flag = addPicCollectionView.isContainVideoAsset;
    if (flag)
    {
        ZXAddPicViewCell *cell =(ZXAddPicViewCell *) [addPicCollectionView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        CustomCoverView *contentView = (CustomCoverView *) cell.customContentView;
        contentView.alphaCoverView.hidden = NO;
        contentView.alphaCoverView.alpha = 0.f;
        [UIView animateWithDuration:0.2 animations:^{
            contentView.alphaCoverView.alpha = 1.f;
        } completion:nil];
    }
    ZXAddPicViewCell *cell1 =(ZXAddPicViewCell *) [addPicCollectionView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:flag?1:0 inSection:0]];
    CustomCoverView *contentView1 = (CustomCoverView *) cell1.customContentView;
    contentView1.hidden = YES;
    return YES;
}

- (BOOL)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    BOOL flag = addPicCollectionView.isContainVideoAsset;
    if (flag && destinationIndexPath.item==0)
    {
        NSLog(@"视频");
        return NO;
    }
    return YES;
}


- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView longPressGestureStateEndAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    BOOL flag = addPicCollectionView.isContainVideoAsset;
    if (flag)
    {
        ZXAddPicViewCell *cell =(ZXAddPicViewCell *) [addPicCollectionView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        CustomCoverView *contentView = (CustomCoverView *) cell.customContentView;
        [UIView animateWithDuration:0.2 animations:^{
            contentView.alphaCoverView.alpha = 0.f;
        } completion:^(BOOL finished) {
            contentView.alphaCoverView.hidden = YES;
        }];
    }
//    没有发生主图数据变动的时候
    ZXAddPicViewCell *cell1 =(ZXAddPicViewCell *) [addPicCollectionView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:flag?1:0 inSection:0]];
    CustomCoverView *contentView1 = (CustomCoverView *) cell1.customContentView;
    contentView1.hidden = NO;
}

- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView didEndMoveAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger fromItem = sourceIndexPath.item;
    NSUInteger toItem = destinationIndexPath.item;
    id object = [self.photosMArray objectAtIndex:fromItem];
    [self.photosMArray removeObjectAtIndex:fromItem];
    [self.photosMArray insertObject:object atIndex:toItem];
    
//    发生主图数据展示变动的时候
    BOOL flag = addPicCollectionView.isContainVideoAsset;
    if ((flag && sourceIndexPath.item ==1) || (flag && destinationIndexPath.item ==1) ||(!flag && sourceIndexPath.item ==0) ||(!flag && destinationIndexPath.item ==0))
    {
        [addPicCollectionView.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == ZXAddPicCellEditingStyleInsert)
    {
        [self picBtnAction:nil];
    }
    else
    {
        BOOL flag = addPicCollectionView.isContainVideoAsset;
        if ((flag && indexPath.item ==1) ||(!flag && indexPath.item ==0))
        {
            [addPicCollectionView.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
        [self.photosMArray removeObjectAtIndex:indexPath.item];
        if (addPicCollectionView.isChangeDeleteContentHeight)
        {
            [self.tableView reloadData];
        }
    }
}


- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray
{
    ZXPhoto *photo = [picsArray objectAtIndex:index] ;
    if (photo.type == ZXAssetModelMediaTypeVideo)
    {
        CCVideoPlayerViewController *playerViewVC = [[CCVideoPlayerViewController alloc]init];
        [playerViewVC updatePlayerWithURL:photo.videoURLString];
        [self presentViewController:playerViewVC animated:YES completion:nil];
    }
    else
    {
        
        NSMutableArray *array = [NSMutableArray array];
        [self.photosMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZXPhoto *photo = (ZXPhoto *)obj;
            if (photo.type == ZXAssetModelMediaTypePhoto)
            {
                [array addObject:photo];
            }
        }];
        NSInteger inde = index;
        if (array.count < picsArray.count)
        {
            inde = index-1;
        }
        //大图浏览
        XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:inde imageCount:array.count datasource:self];
        browser.browserStyle = XLPhotoBrowserStyleCustom;
        browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
    }
 
}



#pragma mark    - XLPhotoBrowserDatasource

- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    
    NSMutableArray *array = [NSMutableArray array];
    [self.photosMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *photo = (ZXPhoto *)obj;
        if (photo.type == ZXAssetModelMediaTypePhoto)
        {
            [array addObject:photo];
        }
    }];
    NSString *orginal =[[array objectAtIndex:index]original_pic];
    return [NSURL URLWithString:orginal];
}



#pragma mark - 保存

//编辑产品－保存；更新信息
- (IBAction)saveBtnAction:(UIButton *)sender {

    AddProductModel *nModel = [self getPostDataModelWithProType:ProductSaveAction_edit];
    if (![self testProductModelParameters:nModel])
    {
        return;
    }

    [self updateProductWithParameters:nModel];
}

#pragma  mark - 上架产品，存私密
//存私密
- (void)privacyBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    if (event.type ==UIEventTypeTouches)
    {
        UITouch *touch= [[event allTouches]anyObject];
        if (touch.tapCount==1)
        {
            AddProductModel *model = [self getPostDataModelWithProType:ProductSaveAction_toPrivacy];
            if (![self testProductModelParameters:model])
            {
                return;
            }
            [self addNewProductWithParameters:model gotoControllerSelectIndex:1];
        }
        else
        {
            NSLog(@"touch.tapCount>1 =%ld",(long)touch.tapCount);
        }
    }
    
}

#pragma  mark - 上架产品，存公开
//公开上架
- (void)uploadBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    if (event.type ==UIEventTypeTouches)
    {
        UITouch *touch= [[event allTouches]anyObject];
        if (touch.tapCount==1)
        {
            AddProductModel *model = [self getPostDataModelWithProType:ProductSaveAction_toPublic];
            if (![self testProductModelParameters:model])
            {
                return;
            }
            [self addNewProductWithParameters:model gotoControllerSelectIndex:0];
        }
        else
        {
            NSLog(@"touch.tapCount>1 =%ld",(long)touch.tapCount);
        }
    }

}


#pragma mark - 添加产品提交请求

- (void)addNewProductWithParameters:(AddProductModel *)model gotoControllerSelectIndex:(NSInteger)type
{
//  NSLog(@"正在提交..");
    [MBProgressHUD zx_showLoadingWithStatus:@"正在提交..." toView:nil];
    WS(weakSelf);
    
    [ProductMdoleAPI postProductNewPro:model success:^(id data) {
        
        [MBProgressHUD zx_showSuccess:@"添加产品成功" toView:nil];
        [weakSelf performSelector:@selector(goToNewController:) withObject:@(type) afterDelay:1.f];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}



- (void)soldoutionProductToPublic:(id)sender
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
   
    WS(weakSelf);
    [ProductMdoleAPI postMyProductToPublicWithProductId:_productId Success:^(id data) {
       
        [MBProgressHUD zx_showSuccess:@"上架成功" toView:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updateSoldouting object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_Edit_goBackUpdate object:nil userInfo:nil];


        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];

}

#pragma mark - 转为私密，公开事件；

- (void)toPublicPrivChangeAction:(id)sender
{
    //    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    UIButton *button = (UIButton *)sender;
    //    if ([model.status integerValue] ==ProductEditStatus_PublicPro)
    if ([button.currentTitle isEqualToString:@"转为私密"])
    {
        [self toPrivateAction:sender];
    }
    else
    {
        [self toPublicAction:sender];
    }
}


- (void)toPrivateAction:(UIButton *)sender
{
    [MobClick event:kUM_b_PMaddprivate];
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"确认转移为私密产品吗？" message:nil cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:@"转移私密" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
        [ProductMdoleAPI postMyProductToProtectedWithProductId:weakSelf.productId Success:^(id data) {
            
            [MBProgressHUD zx_showSuccess:@"成功转为私密产品" toView:nil];
            [weakSelf.diskManager setPropertyImplementationValue:@(ProductEditStatus_PrivacyPro) forKey:@"status"];
            [sender setTitle:@"转为公开" forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_Edit_goBackUpdate object:nil userInfo:nil];

            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }];
        
    }];
}


- (void)toPublicAction:(UIButton *)sender
{
    
    [MobClick event:kUM_b_PMaddpublicity];
    WS(weakSelf);
    [UIAlertController zx_presentCustomAlertInViewController:self withTitle:@"确认产品转移为公开上架吗？" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"公开上架"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex ==controller.firstOtherButtonIndex)
        {
            [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
            [ProductMdoleAPI postMyProductToPublicWithProductId:weakSelf.productId Success:^(id data) {
                [MBProgressHUD zx_showSuccess:NSLocalizedString(@"成功转为公开上架", nil) toView:nil];
                [self.diskManager setPropertyImplementationValue:@(ProductEditStatus_PublicPro) forKey:@"status"];
                [sender setTitle:@"转为私密" forState:UIControlStateNormal];
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_Edit_goBackUpdate object:nil userInfo:nil];


            } failure:^(NSError *error) {
                
                [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            }];
        }
        
    }];
}



#pragma mark - 编辑产品提交请求

- (void)updateProductWithParameters:(AddProductModel *)model
{
    WS(weakSelf);
    [MBProgressHUD zx_showLoadingWithStatus:NSLocalizedString(@"正在提交", nil) toView:self.view];
    [ProductMdoleAPI postUpdateProductInfo:model success:^(id data) {
        
        [MBProgressHUD zx_showSuccess:NSLocalizedString(@"编辑产品成功", nil) toView:weakSelf.view];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_Edit_goBackUpdate object:nil userInfo:nil];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];        
    }];

}



#pragma mark - 提交或保存后 页面跳转

- (void)goToNewController:(NSNumber *)type
{
    // 跳转到产品管理页面
    if (self.addProductPushType == AddProudctPushType_goToNewProductManager)
    {
        //push过去后，删除在导航控制器中子控制器的当前的控制器
        [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_ProductManageController withData:@{@"selectIndex":type}];
        
        NSMutableArray *viewControllers =[self.navigationController.viewControllers mutableCopy];
        NSInteger index = [viewControllers indexOfObject:self];
        [viewControllers removeObjectAtIndex:index];
        self.navigationController.viewControllers =viewControllers;
    }
    else if (self.addProductPushType == AddProudctPushType_goBackProductManager)
    {
        //pop回去的；自动从导航容器控制器删除当前子控制器
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_selectIndexUpdate object:nil userInfo:@{@"selectIndex":type}];
    }
    else if (self.addProductPushType == AddProudctPushType_goBackShopClassifySetting)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ShopCateProducts_update object:nil userInfo:nil];
    }
}


#pragma mark - 判断产品参数是否填充

- (BOOL)testProductModelParameters:(AddProductModel *)model
{
    if (model.pics.count==0)
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请上传产品图片", nil) toView:nil];
        return NO;
    }
    //所属类目
    if (!model.name)
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请输入产品名称", nil) toView:nil];
        return NO;
    }
    else if (!model.sysCateId)
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请输入所属类目", nil) toView:nil];
        return NO;
    }
//    阶梯价格
    else if ([NSString zhIsBlankString:model.priceGrads])
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请输入价格", nil) toView:nil];
        return NO;
    }
    else if (!model.freightId)
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请设置运费", nil) toView:nil];
        return NO;
    }
//    3.26可有可无的判断
    else if (model.priceGrads &&!model.priceUnit)
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请输入起订量单位", nil) toView:nil];
        return NO;
    }
//    3.26弃用
//    else if ([NSString zhIsBlankString:model.price])
//    {
//        [MBProgressHUD zx_showError:@"请输入批发价" toView:nil];
//        return NO;
//    }
    return YES;

}

- (AddProductModel *)getPostDataModelWithProType:(ProductSaveAction)type
{
//    NSDictionary *pic = @{@"h":@(1280),@"p":@"http://public-read-bkt-oss.oss-cn-hangzhou.aliyuncs.com/1/buy/f3bcb468447686be9259c61c57f054e1.jpg",@"w":@(960)};
//    NSArray *pics = @[pic];
//    [self.diskManager setPropertyImplementationValue:pics forKey:@"pics"];
    
    //名称，标签，型号，规格尺寸，产品介绍
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    //型号
    NSString *modelNum = self.modelNumberCell.textField.text;
    NSLog(@"%@",modelNum);
    model.model = modelNum;
    //图片
    model.pics = [self manyPicModelFormPicArray:self.photosMArray];
    model.video = [self getViedoStringFormPicArray:self.photosMArray];
    //货源类型
    NSInteger productType =[self.contentCell getGoodsPromptType];
    model.sourceType = @(productType);
    
    //是否主营 在本地数据源已经处理了；
    //批发价
//    NSString * price = [self.contentCell getSelectedTradePrice];
//    model.price = price;
   
    //起订量
//    NSString *minQuantity = self.contentCell.orderCountField.text;
//    NSNumber *quantity = [NSString zhIsBlankString:minQuantity]?nil:@([minQuantity integerValue]);
//    model.minQuantity = quantity;
    
//    //单位
//    NSString *unit = self.contentCell.unitField.text;
//    NSString *nUnit = [NSString zhIsBlankString:unit]?nil:unit;
//    model.priceUnit = nUnit;
    
    if (type== ProductSaveAction_toPublic ||type ==ProductSaveAction_toPrivacy)
    {
        model.isOnshelve =type;
    }
    return model;
}

- (NSMutableArray *)manyPicModelFormPicArray:(NSMutableArray *)photoArray
{
    NSMutableArray *uploadPicArray = [NSMutableArray array];
    [self.photosMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *photo = (ZXPhoto *)obj;
        if (photo.type == ZXAssetModelMediaTypePhoto)
        {
            AliOSSPicUploadModel *model = [[AliOSSPicUploadModel alloc] init];
            model.p = photo.original_pic;
            model.w = photo.width;
            model.h = photo.height;
            [uploadPicArray addObject:model];
        }
  
    }];
    return  uploadPicArray;
}

- (NSString *)getViedoStringFormPicArray:(NSMutableArray *)photoArray
{
    __block NSString *video = nil;
    [self.photosMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *photo = (ZXPhoto *)obj;
        if (photo.type == ZXAssetModelMediaTypeVideo)
        {
            video = photo.videoURLString;
        }
        
    }];
    return  video;
}


#pragma mark - 删除

- (void)deleteAction:(UIButton *)sender
{
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"确认删除该产品？" message:nil cancelButtonTitle:@"关闭" cancleHandler:nil doButtonTitle:@"确认删除" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
        
        [ProductMdoleAPI postDeleteProductWithProductId:_productId success:^(id data) {
            
            [MBProgressHUD zx_showSuccess:NSLocalizedString(@"成功删除该产品", nil) toView:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_Edit_goBackUpdate object:nil userInfo:nil];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];

        }];
    }];
}


#pragma mark - 下架

- (void)soldOutAction:(UIButton *)sender
{
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"确认下架该产品？" message:nil cancelButtonTitle:@"关闭" cancleHandler:nil doButtonTitle:@"确认下架" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
        
        [ProductMdoleAPI postSoldoutProductWithProductId:_productId success:^(id data) {
            
            [MBProgressHUD zx_showSuccess:NSLocalizedString(@"成功下架该产品", nil) toView:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_Edit_goBackUpdate object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updateSoldouting object:nil userInfo:nil];

            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            
        }];
    }];
}

#pragma mark - 自定义返回按钮事件

- (IBAction)backItemAction:(UIBarButtonItem *)sender {
    
    NSString *message = nil;
    if (self.controllerDoingType == ControllerDoingType_AddProduct)
    {
        message = NSLocalizedString(@"确定放弃新增产品?", nil);
    }
    else
    {
        message = NSLocalizedString(@"确定放弃编辑产品?", nil);
    }
    WS(weakSelf);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [_diskManager removeData];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (BOOL)navigationShouldPopOnBackButton
{
    NSString *message = self.controllerDoingType == ControllerDoingType_AddProduct?NSLocalizedString(@"确定放弃新增产品?", nil):NSLocalizedString(@"确定放弃编辑产品?", nil);
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:message message:nil cancelButtonTitle:NSLocalizedString(@"放弃", nil) cancleHandler:^(UIAlertAction * _Nonnull action) {

        [weakSelf.diskManager removeData];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } doButtonTitle:NSLocalizedString(@"继续", nil) doHandler:nil];
 
    return NO;
}

//#pragma mark - 流量暴增按钮事件
//
//- (void)titleViewAction:(UIButton *)sender
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@/ysb/page/takePhoto.html",[WYUserDefaultManager getkAPP_H5URL]];
//
//    [[WYUtility dataUtil]routerWithName:urlStr withSoureController:self];
//
//}

@end
