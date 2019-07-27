//
//  AddProBriefsController.m
//  YiShangbao
//
//  Created by simon on 2018/3/16.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "AddProBriefsController.h"
#import "TMDiskManager.h"
#import "AddProductModel.h"
#import "IQKeyboardManager.h"
#import "ZSSBarButtonItem.h"
#import "ZXImagePickerVCManager.h"
#import "AliOSSUploadManager.h"
#import "TZImagePickerController.h"


@interface AddProBriefsController ()<ZXImagePickerVCManagerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong)TMDiskManager *diskManager;
@property (nonatomic, strong)ZXImagePickerVCManager *imagePickerVCManager;

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;

@end

@implementation AddProBriefsController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"产品图文详情", nil);
    
    self.navigationItem.rightBarButtonItem = self.rightButtonItem;

    [self setData];
}

-(UIBarButtonItem*)rightButtonItem{
    if (!_rightButtonItem) {
        
        UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 28)];
        [backButton setTitle:@"确定" forState:UIControlStateNormal];
        [backButton setTitleColor:UIColorFromRGB_HexValue(0xFF6936) forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColorFromRGB_HexValue(0xFF6936) colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [backButton setBackgroundColor:UIColorFromRGB_HexValue(0xfff5f1)];
        [backButton addTarget:self action:@selector(rightButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [backButton zx_setCornerRadius:28/2 borderWidth:0.5 borderColor:UIColorFromRGB_HexValue(0xFE744A)];
        _rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _rightButtonItem;
}

- (void)rightButtonItemAction:(id)sender
{
    NSString *string = [self getHTML];
    [self.diskManager setPropertyImplementationValue:string forKey:@"desc"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [[IQKeyboardManager sharedManager]setEnable:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)dealloc
{
    
}

- (void)initImagePickerVCManager {
    //初始化照片／拍照选择
    ZXImagePickerVCManager *pickerVCManager = [[ZXImagePickerVCManager alloc] init];
    pickerVCManager.morePickerActionDelegate = self;
    self.imagePickerVCManager = pickerVCManager;
    //初始化oss上传
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
    //是否需要获取图片信息，长宽
    [AliOSSUploadManager sharedInstance].getPicInfo = YES;
}

- (void)setData
{
    
    self.placeholder = @"请输入产品描述或添加产品图片~";
    
    [self initImagePickerVCManager];
  
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    if (![NSString zhIsBlankString:model.desc])
    {
        [self setHTML:model.desc];
    }
}

- (void)centerBtnAction
{
    NSString *string = [self getHTML];
    
    if ([NSString zhGetImgSrcCountWithHTMLString:string]>=20)
    {
        [MBProgressHUD zx_showError:@"您最多只能添加20张图片哦～" toView:self.view];
        return;
    }
    NSInteger maxImagesCount = [NSString zhGetImgSrcCountWithHTMLString:string]>11?(20-[NSString zhGetImgSrcCountWithHTMLString:string]):9;

    [self presentImagePickerControllerWithMaxImagesCount:maxImagesCount];
//    [self.imagePickerVCManager zxPresentActionSheetToImagePickerWithSourceController:self];
}

//代理
- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
    NSData *imageData = [WYUtility zipNSDataWithImage:image];
    //    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];
    self.rightButtonItem.enabled = NO;
    WS(weakSelf);
  [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_uploadProductPicText uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        }singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
        NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:imagePath];
        
            [weakSelf insertImage:picUrl.absoluteString alt:nil];
            [weakSelf focusTextEditor];
        //这里处理上传图片
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        weakSelf.rightButtonItem.enabled = YES;

    } failure:^(NSError *error) {
        
        weakSelf.rightButtonItem.enabled = YES;
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}


- (void)presentImagePickerControllerWithMaxImagesCount:(NSInteger)maxImagesCount
{
    //初始化多选择照片
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount delegate:self];
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
    
    self.rightButtonItem.enabled = NO;
    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];
    __block NSInteger currentIndex = 0;
    NSMutableArray *tempMArray = [NSMutableArray array];
    WS(weakSelf);
    [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImage *image = (UIImage *)obj;
        NSData *imageData = [WYUtility zipNSDataWithImage:image];
        
        [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_uploadProductPicText uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
        } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
            
            currentIndex ++;
            //这里处理上传图片
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:imagePath];
            [tempMArray addObject:picUrl.absoluteString];
            if (currentIndex ==photos.count){
             
                weakSelf.rightButtonItem.enabled = YES;
                [MBProgressHUD zx_hideHUDForView:weakSelf.view];
                
               NSArray * tempMArray2 = [AliOSSUploadManager sortAliOSSImage_UserID_time_WithStringArr:tempMArray];
                NSArray *reverseObjects = [tempMArray2 reverseObjectEnumerator].allObjects;
             
                [reverseObjects enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [weakSelf insertImage:obj alt:nil];
                    [weakSelf focusTextEditor];
                }];

            }
            
        } failure:^(NSError *error) {
            
            weakSelf.rightButtonItem.enabled = YES;
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)savaBarItemAction:(UIBarButtonItem *)sender {
//
//    NSString *string = [self getHTML];
//    [self.diskManager setPropertyImplementationValue:string forKey:@"desc"];
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (BOOL)navigationShouldPopOnBackButton
{
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    NSString *string = [self getHTML];
    if ([model.desc isEqualToString:string] ||(model.desc.length == string.length && model.desc ==nil))
    {
        return YES;
    }
    
    NSString *message =@"是否保存更改后的内容";
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:message message:nil cancelButtonTitle:@"不保存" cancleHandler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } doButtonTitle:@"保存" doHandler:^(UIAlertAction * _Nonnull action) {
        
        NSString *string = [self getHTML];
        [weakSelf.diskManager setPropertyImplementationValue:string forKey:@"desc"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    return NO;
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

