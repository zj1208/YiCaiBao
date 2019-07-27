//
//  ExtendProductViewController.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ExtendProductViewController.h"
#import "ProductClassViewController.h"
#import "UIViewController+XMNavBarCustom.h"
#import "ExtendProductFirstTableViewCell.h"
#import "ExtendProductSecondTableViewCell.h"

#import "ZXImagePickerVCManager.h"
#import "TZImagePickerController.h"
#import "XLPhotoBrowser.h"
#import "AliOSSUploadManager.h"

#import "ExtendSuccessViewController.h"
#import "ExtendProductAlertController.h"
#import "SEProductSelectController.h"

typedef NS_ENUM(NSUInteger, ExtentUploadType) {
    EUploadUpdatePhoto = 0,           //新增、修改过图片,发布时再次重新上传图片
    EUploadPostFailNoUpdatePhoto = 1, //已提交状态:图片上传成功、但发布失败（网络失败、未认证）,未修改图片产品,图片不再重新上传
};
@interface ExtendProductViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,ZXAddPicCollectionViewDelegate,XLPhotoBrowserDatasource,ExtendProductFirstTableViewCellDelegate,ExtendSuccessViewControllerDelegate,ZXEmptyViewControllerDelegate>

@property(nonatomic,strong)UITableView* tableview;
@property(nonatomic,strong)ExtendProductFirstTableViewCell *textViewCell;
@property(nonatomic,strong)ExtendProductSecondTableViewCell* photoCell;

@property(nonatomic,strong)ExtendModel* extendInitModel;//推产品，推库存同一个数据模型
@property (nonatomic, strong)NSMutableArray *mImages;     //选择的图片数组<UIimage>
@property (nonatomic, strong)NSMutableArray *imagesProcutsArray; //预览数组数组<UIimage+ExtendSelectProcuctModel>

@property (nonatomic, strong)NSMutableArray *photosMArray; //图片上传成功后<AliOSSPicUploadModel>
@property(nonatomic)ExtentUploadType photoUploadType ;

@property(nonatomic,strong)NSString* intro;       //推广简介
@property(nonatomic,strong)NSString* sysCateId;    //选择的类目id字符串（多个类目“,”拼接）
@property(nonatomic,strong)NSString* sysCateName;  //选择的类目名称字符串（多个类目“,”拼接）

@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;
@property (nonatomic, strong)ExtendSuccessViewController *successController;


@end

@implementation ExtendProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    NSArray* arr = @[@"",@"推广产品",@"发布库存"];//后台枚举1／2
    self.title = arr[_numId.integerValue];
    
    [self setData];
    
    [self buildUI];
    [self requsetData];
    
}
-(void)setData
{
    self.photoUploadType = EUploadUpdatePhoto;
    self.mImages = [NSMutableArray array];
    self.photosMArray = [NSMutableArray array];
    self.imagesProcutsArray = [NSMutableArray array];
    if (self.selProModel) {
        [self.imagesProcutsArray addObject:self.selProModel];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.successController){
        [self.tabBarController addChildViewController:self.successController];
        [self.tabBarController.view addSubview:self.successController.view];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.successController.view.superview) {
        [self.successController.view removeFromSuperview];
        [self.successController removeFromParentViewController];
    }
}
#pragma mark 根据推广id获取重新发布信息
-(void)requsetDataWithExtendOldId
{
    [[[AppAPIHelper shareInstance] getExtendProductAPI] getExtendOldSpreadWithOldId:self.oldId Success:^(id data) {
       
        //重新重置下状态，防止弱网或selProModel影响
        self.photoUploadType = EUploadUpdatePhoto;
        self.mImages = [NSMutableArray array];
        self.photosMArray = [NSMutableArray array];
        self.imagesProcutsArray = [NSMutableArray array];
        
        ExtendOldModel *model = (ExtendOldModel *)data;
        
        self.textViewCell.textView.text = model.intro;
        self.sysCateId = model.sysCateId;
        self.sysCateName = model.sysCateName;
        
        for (int i=0; i<model.pics.count; ++i) {
            ExtendOldPicModel *picModel = model.pics[i];

            AliOSSPicUploadModel *aModel = [[AliOSSPicUploadModel alloc] init];
            aModel.w = picModel.w.floatValue;
            aModel.h = picModel.h.floatValue;
            aModel.p = picModel.p;
            
            ExtendSelectProcuctModel *eSPModel = [[ExtendSelectProcuctModel alloc] init];
            eSPModel.mainPic = aModel;
            if (picModel.pid) { //只有是产品才存在
                eSPModel.iid = [NSNumber numberWithInteger:picModel.pid.integerValue];
            }
            if (picModel.url) { //只有是产品才存在
                eSPModel.url = picModel.url;
            }
            [self.imagesProcutsArray addObject:eSPModel];
        }
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:[error localizedDescription] updateBtnHide:NO];
    }];
}
#pragma mark 推广初始化
-(void)requsetData
{
    [[[AppAPIHelper shareInstance] getExtendProductAPI] getExtendProductOrInventoryWithNumId:self.numId Success:^(id data) {
        
        ExtendModel* extendInitModel = (ExtendModel*)data;
        self.extendInitModel = extendInitModel;
        self.sysCateId = self.extendInitModel.sysCateIdLast;
        self.sysCateName = self.extendInitModel.sysCateNameLast;
        [self.tableview reloadData];

        //获取重新发布初始化信息
        if (self.oldId) {
            [self requsetDataWithExtendOldId];
        }
        
        if (self.extendInitModel) {
            [self addRightBarButton];
        }
        [self.emptyViewController hideEmptyViewInController:self hasLocalData:extendInitModel];

    } failure:^(NSError *error) {
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:[error localizedDescription] updateBtnHide:NO];
    }];
}
-(void)addRightBarButton
{
    UIButton* rigBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 22)];
    [rigBtn setImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [rigBtn setAdjustsImageWhenHighlighted:NO];
    [rigBtn addTarget:self action:@selector(clickRightBarbutton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rigBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    if (LCDW >375.f) {  //单独处理plus自动偏移间距（plus多5.f）
        self.navigationItem.rightBarButtonItems = [self xm_navigationItem_leftOrRightItemReducedSpaceToMagin:-7.f withItems:@[rightBarButtonItem]];
    }else{
        self.navigationItem.rightBarButtonItems = [self xm_navigationItem_leftOrRightItemReducedSpaceToMagin:-2.f withItems:@[rightBarButtonItem]];
    }
    
}
#pragma mark - ZXEmptyViewControllerDelegate
-(void)zxEmptyViewUpdateAction
{
    [self requsetData];
}
-(void)buildUI
{
    self.tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [[WYUIStyle style] colorWithHexString:@"f3f3f3"];
    [self.view addSubview:self.tableview];
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;//收缩键盘

    //初始化oss上传
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
    [AliOSSUploadManager sharedInstance].getPicInfo = YES;
    
    self.photoCell = [[NSBundle mainBundle] loadNibNamed:@"ExtendProductSecondTableViewCell" owner:nil options:nil][0];
    self.photoCell.picsCollectionView.delegate = self;

    self.textViewCell = [[NSBundle mainBundle] loadNibNamed:@"ExtendProductFirstTableViewCell" owner:nil options:nil][0];
    self.textViewCell.delegate = self;
    
    if ([self.numId integerValue] == 1) {
        self.textViewCell.textView.placeholder = @"描述产品信息：如名称、优势、起订量、价格区间等";
    }else if ([self.numId integerValue] == 2){
        self.textViewCell.textView.placeholder = @"描述库存信息：如名称、数量、价格、优势等";
    }
}
-(ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
        emptyVC.delegate = self;
         emptyVC.view.frame = self.view.bounds;
        self.emptyViewController = emptyVC;
    }return _emptyViewController;
}
#pragma mark - ExtendProductFirstTableViewCellDelegate 
#pragma mark - 类目选择按钮
-(void)jl_clcikExtendProductFirstTableViewCellChoseClassbtn:(ExtendProductFirstTableViewCell *)cell classLabel:(UILabel *)classlabel
{
    ProductClassViewController* VC = [[ProductClassViewController alloc] init];    
    VC.maxSelectPuoducts = [self.extendInitModel.cateNum integerValue];
    VC.level = self.extendInitModel.cateLevel;
    
    VC.sysCateIds = [self.sysCateId copy];
    VC.sysCateNames = [self.sysCateName copy];

    VC.classSelectedBlock = ^(NSString *sysCateIds, NSString *sysCateNames) {
        self.sysCateId = [sysCateIds copy];
        self.sysCateName = [sysCateNames copy];
        [self.tableview reloadData];
    };
    [self.navigationController pushViewController:VC animated:YES];

}
#pragma mark - ZXAddPicCollectionViewDelegate
//点击新增、删除
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView  commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //一旦点击即视为增加、减少,则重新上传图片
    self.photoUploadType = EUploadUpdatePhoto;
    
    if (editingStyle == ZXAddPicCellEditingStyleInsert)
    {
        [self presentAlertController];
    }
    if (editingStyle == ZXAddPicCellEditingStyleDelete)
    {
        id objc = self.imagesProcutsArray[indexPath.item];
        if ([objc isKindOfClass:[UIImage class]]) {
            [self.mImages removeObject:objc];
        }
        [self.imagesProcutsArray removeObjectAtIndex:indexPath.item];
        [self.tableview reloadData];
    }
}
#pragma mark  - 预览
//点击已存在的图片
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray
{
     XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoAndProductBrowserWithCurrentImageIndex:index  imageCount:self.imagesProcutsArray.count goodsUrlList:[self getGoodsUrlList] datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;

}
-(NSArray *)getGoodsUrlList
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i=0; i<self.imagesProcutsArray.count; ++i) {
        id objc = self.imagesProcutsArray[i];
        XLPhotoUrlModel *model = [[XLPhotoUrlModel alloc] init];
        if ([objc isKindOfClass:[UIImage class]]) {
            [arrayM addObject:model];
        }
        if ([objc isKindOfClass:[ExtendSelectProcuctModel class]]) {
            ExtendSelectProcuctModel *mod = (ExtendSelectProcuctModel *)objc;
            model.goodsUrl = mod.url;
            [arrayM addObject:model];
        }
    }
    return arrayM;
}
#pragma mark    - 预览XLPhotoBrowserDatasource
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    id objc = self.imagesProcutsArray[index];
    if ([objc isKindOfClass:[UIImage class]]) {
        return self.imagesProcutsArray[index];
    }
    return nil;
}
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
{
    id objc = self.imagesProcutsArray[index];
    if ([objc isKindOfClass:[ExtendSelectProcuctModel class]]) {
        ExtendSelectProcuctModel *model = (ExtendSelectProcuctModel *)objc;
        NSURL *url = [NSURL URLWithString:model.mainPic.p];
        return url;
    }
    return nil;
}
#pragma  mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    //    // photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
    //    self.photosArray = [NSMutableArray arrayWithArray:photos];
    //    // 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
    //    self.assestArray = [NSMutableArray arrayWithArray:assets];
    //    //    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    //    [_collectionView reloadData];
    //
    [self.mImages addObjectsFromArray:photos];
    [self.imagesProcutsArray addObjectsFromArray:photos];
    
    [self.tableview reloadData];
}
-(void)presentAlertController
{
    NSString *title = [NSString stringWithFormat:@" 注意：产品和图片一共只能添加%@个",self.extendInitModel.picNum];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionProduct = [UIAlertAction actionWithTitle:@"选择产品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.numId isEqualToNumber:@1]) {//推产品
            [MobClick event:kUM_b_push_selectproduct];
        }else{
            [MobClick event:kUM_b_promotion_selectproduct];
        }
        
        SEProductSelectController *vc = (SEProductSelectController *)[self xm_getControllerWithStoryboardName:sb_Extend controllerWithIdentifier:SBID_SEProductSelectController];
        NSInteger numPic = self.extendInitModel.picNum.integerValue-self.imagesProcutsArray.count;//张数限制
        vc.maxProsucts = numPic;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        WS(weakSelf);
        vc.productDidSelectBlock = ^(NSMutableArray<__kindof ExtendSelectProcuctModel *> *arrayProducts) {
            [weakSelf.imagesProcutsArray addObjectsFromArray:arrayProducts];
          
            [weakSelf.tableview reloadData];

        };
    }];
    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"拍照／相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.numId isEqualToNumber:@1]) {//推产品
            [MobClick event:kUM_b_push_photograph];
        }else{
            [MobClick event:kUM_b_promotion_photograph];
        }
        
        [self presentTZImagePickerController];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:actionProduct];
    [alertC addAction:actionPhoto];
    [alertC addAction:actionCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 海参添加的 产品数组 转换为zxPhoto数组
- (NSMutableArray *)manyZXPhotoFormSelectProcuctModelArray:(NSMutableArray *)modelsArray
{
    NSMutableArray *zxPhotoMArray = [NSMutableArray arrayWithArray:modelsArray];
    [modelsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ExtendSelectProcuctModel class] ]) {
            
            ExtendSelectProcuctModel *productModel = (ExtendSelectProcuctModel *)obj;
            AliOSSPicUploadModel *picModel = productModel.mainPic;
            NSString *imagePath = picModel.p;
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:imagePath];
            ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:imagePath thumbnailUrl:picUrl.absoluteString];
            photo.width = picModel.w;
            photo.height = picModel.h;
            if (productModel.url) {
                photo.type = ZXAssetModelMediaTypeCustom;
            }else{
                photo.type = ZXAssetModelMediaTypePhoto;
            }
            
            [zxPhotoMArray replaceObjectAtIndex:idx withObject:photo]; //替换用于展示
        }
       
    }];
    return  zxPhotoMArray;
}
- (void)presentTZImagePickerController
{
    //张数限制
    NSInteger numPic = self.extendInitModel.picNum.integerValue-self.imagesProcutsArray.count;
    //初始化选择照片
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:(numPic) delegate:self];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePicker setSortAscendingByModificationDate:NO];
    //是否有选择原图
    imagePicker.allowPickingOriginalPhoto = NO;
    //    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    //用户选中的图片
    //    imagePicker.selectedAssets = _assestArray;
    //是否允许选择视频
    imagePicker.allowPickingVideo = YES;
    //是否可以拍照
    imagePicker.allowTakePicture = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 发送
-(void)clickRightBarbutton
{    
    [self.view endEditing:YES];
    
    NSString* userStr = self.textViewCell.textView.text;
    if ([NSString zhIsBlankString:userStr])
    {
        [MBProgressHUD zx_showError:@"请输入产品描述" toView:self.view];
        return;
    }

    if ([NSString zhIsBlankString:self.sysCateId]) {
        [MBProgressHUD zx_showError:@"请选择所属类目" toView:self.view];
        return;
    }
    if (self.imagesProcutsArray.count < 1) {
        [MBProgressHUD zx_showError:@"至少要选择一个产品或图片哦" toView:self.view];
        return;
    }
    if (self.imagesProcutsArray.count > 9) {
        [MBProgressHUD zx_showError:@"产品和图片一共只能上传九个哦" toView:self.view];
        return;
    }
    
    [MBProgressHUD zx_showLoadingWithStatus:@"正在提交" toView:nil];
    if (self.photoUploadType == EUploadPostFailNoUpdatePhoto) {
        [self uploadData]; //图片上传成功、但发布失败（网络失败、未认证）,未修改图片产品,图片不再重新上传
        return;
    }
    if (self.mImages.count> 0 )
    {
        __block NSInteger currentIndex = 0;
        //清空数据
        [_photosMArray removeAllObjects];

        [self.mImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImage *image = (UIImage *)obj;
            NSData *imageData = [WYUtility zipNSDataWithImage:image];
            WS(weakSelf);
            OSSFileCatalog catelog ;
            if ([self.numId isEqualToNumber:@(1)])
            {
                catelog = OSSFileCatalog_ProductExtend;
            }
            else
            {
                catelog = OSSFileCatalog_ProductExtendStock;
            }
            [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:catelog uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                
            } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
                
                NSLog(@"%@",imagePath);
                currentIndex ++;
                //这里处理上传图片
                AliOSSPicUploadModel *model = [[AliOSSPicUploadModel alloc] init];
                model.p = imagePath;
                model.w = imageSize.width;
                model.h = imageSize.height;
                
                [_photosMArray addObject:model];
                if (currentIndex ==_mImages.count)
                {
                    [weakSelf performSelector:@selector(uploadData)];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            }];
        }];
    }
    else  //没有图片、全是产品
    {
        [self uploadData];
    }
}
#pragma mark 发布
- (void)uploadData
{
    NSString* userDescStr = self.textViewCell.textView.text;
    NSString* classIdStr = self.sysCateId;
    
    //json
    NSArray *picArray = [self getJsonFromImagesProcutsArrayModels];
    
    //类目等级，推产品1,库存2级
    NSNumber* cateLevel = self.numId;
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getExtendProductAPI] postExtendWithCateLevel:cateLevel Desc:userDescStr sysCate:classIdStr photos:picArray success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:nil];
        
        NSDictionary *redirect = [data objectForKey:@"redirect"];
        if (redirect)
        {
            self.photoUploadType = EUploadPostFailNoUpdatePhoto;

            NSString *title = [redirect objectForKey:@"msg"];
            //去认证-跳转h5认证页面
            NSString *btn1 = [redirect objectForKey:@"btn1"];
            NSString *url = [redirect objectForKey:@"url"];
            //取消
            NSString *btn2 = [redirect objectForKey:@"btn2"];

            [ExtendProductAlertController showWithMessage:title presenting:self cancelTitle:btn2 cancelBlock:^{
                
            }cerTitle:btn1 certificationNowBlock:^{
                [[WYUtility dataUtil]routerWithName:url withSoureController:self];
            }];
        }
        else
        {
            self.photoUploadType = EUploadUpdatePhoto;

            NSString* shareUrl = [data objectForKey:@"link"];
            NSString* shareTitle = [data objectForKey:@"title"];
            
            //1、获取分享参数
            NSString* DescStr = weakSelf.textViewCell.textView.text;
           
            NSString *imageStr = @"";
            id objcFirst = self.imagesProcutsArray.firstObject;
            if ([objcFirst isKindOfClass:[UIImage class] ]) {
                AliOSSPicUploadModel *model = self.photosMArray.firstObject;
                imageStr = model.p;
            }
            if ([objcFirst isKindOfClass:[ExtendSelectProcuctModel class] ]) {
                ExtendSelectProcuctModel *model = self.imagesProcutsArray.firstObject;
                imageStr = model.mainPic.p;
            }
            
            //成功
            UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:sb_Extend bundle:[NSBundle mainBundle]];
            ExtendSuccessViewController* shareVC =  [extendSottrbord instantiateViewControllerWithIdentifier:SBID_ExtendSuccessViewController];
            [shareVC shareWithImage:imageStr Title:shareTitle Content:DescStr withUrl:shareUrl];
            shareVC.delegate = self;
            self.successController = shareVC;
            [self.tabBarController addChildViewController:self.successController];
            [self.tabBarController.view addSubview:self.successController.view];
        }
        
    } failure:^(NSError *error) {
        self.photoUploadType = EUploadPostFailNoUpdatePhoto;
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        
    }];
    
}
-(NSArray *)getJsonFromImagesProcutsArrayModels
{
    //1.对阿里云图片排序
    NSArray * arrSort = [AliOSSUploadManager sortAliOSSImage_UserID_time_WithModelArr:self.photosMArray];
    self.photosMArray = [NSMutableArray arrayWithArray:arrSort];
    
    //2.替换imagesProcutsArray中Image为AliOSSPicUploadModel
    NSMutableArray *iProArrayM = [NSMutableArray arrayWithArray:self.imagesProcutsArray];
    NSInteger index = 0;
    for (int i=0; i<_imagesProcutsArray.count; ++i) {
        id objc = _imagesProcutsArray[i];
        if ([objc isKindOfClass:[UIImage class]]) {
            AliOSSPicUploadModel *model = self.photosMArray[index];
            [iProArrayM replaceObjectAtIndex:i withObject:model] ;
            index++;
        }
    }
    NSLog(@"%@",iProArrayM);

    //3.统一转为ExtendUpLoadModel
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i=0; i<iProArrayM.count; ++i) {
        ExtendUpLoadModel *model = [[ExtendUpLoadModel alloc] init];

        id objc = iProArrayM[i];
        if ([objc isKindOfClass:[AliOSSPicUploadModel class]]) {
            AliOSSPicUploadModel *mod = (AliOSSPicUploadModel *)objc;
            model.p = mod.p;
            model.w = mod.w;
            model.h = mod.h;
            [arrayM addObject:model];
        }
        if ([objc isKindOfClass:[ExtendSelectProcuctModel class]]) {
            ExtendSelectProcuctModel *mod = (ExtendSelectProcuctModel *)objc;
            model.p = mod.mainPic.p;
            model.w = mod.mainPic.w;
            model.h = mod.mainPic.h;
            model.pid = mod.iid;
            [arrayM addObject:model];
        }
    }
    //4.转json
    NSArray *picArray = [MTLJSONAdapter JSONArrayFromModels:arrayM error:nil];
    return picArray;
    
}
#pragma mark 分享后View将要移除代理
-(void)ExtendSuccessViewControllerViewWillRemoveFromSuperview:(ExtendSuccessViewController *)extendSuccessViewController
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.extendInitModel) {
        return 2;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CGFloat Height = LCDScale_iPhone6_Width(255.f)+45+30+10+1;
        return Height;
    }else if (indexPath.row == 1){
    
        NSMutableArray *zxPhotoMArray = [self manyZXPhotoFormSelectProcuctModelArray:self.imagesProcutsArray];
        CGFloat HightPhotosCell =  [self.photoCell.picsCollectionView getCellHeightWithContentData:zxPhotoMArray];
        return HightPhotosCell+34;
    }
    return 0.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.textViewCell.numWordsOfcountLabel  = [self.extendInitModel.wordsNum integerValue];//字数限制（传入不大于0目前无限制输入）（待完善）
        NSString *classStr = self.sysCateName?self.sysCateName:@"";
        self.textViewCell.classLabel.text = [NSString stringWithFormat:@"%@",classStr];

        self.textViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.textViewCell;
        
    }else{
        self.photoCell.picsCollectionView.maxItemCount = [self.extendInitModel.picNum integerValue]; //上传图片最大张限制（本地判断最少两张）
        NSMutableArray *zxPhotoMArray = [self manyZXPhotoFormSelectProcuctModelArray:self.imagesProcutsArray];
        [self.photoCell.picsCollectionView setData:zxPhotoMArray];
        
        self.photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.photoCell;
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
