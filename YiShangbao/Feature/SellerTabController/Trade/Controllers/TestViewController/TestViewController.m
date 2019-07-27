//
//  TestViewController.m
//  YiShangbao
//
//  Created by simon on 17/2/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TestViewController.h"
#import "ZXPhotosView.h"
#import "ZXImagePickerVCManager.h"
#import "AliOSSUploadManager.h"

#define PhotoMargin 30*LCDW/375  //间距
#define ContentWidth LCDW-20



@interface TestViewController ()<ZXPhotosViewDelegate,ZXImagePickerVCManagerDelegate>

@property (nonatomic, strong) ZXPhotosView *photosView;
@property (nonatomic,strong)ZXImagePickerVCManager *imagePickerVCManager;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZXPhotosView *photoView   = [ZXPhotosView photosView];
    photoView.photosState = ZXPhotosViewStateWillCompose;
    photoView.frame = CGRectMake(10, 80, LCDW-20, 150);
    photoView.photosMaxColoum = 4;
    photoView.imagesMaxCountWhenWillCompose = 4;
    photoView.delegate = self;
    photoView.promptLab.text = [NSString stringWithFormat:@"上传真实的图片(最多4张)\n有图的供应商有助于提高抢单成功率"];
    photoView.images = [@[]mutableCopy];
    photoView.photoMargin = PhotoMargin;
    photoView.photoWidth = (ContentWidth-PhotoMargin*3)/photoView.imagesMaxCountWhenWillCompose;
    photoView.photoHeight = photoView.photoWidth;
    //    photoView.delegate = self;
    self.photosView = photoView;
    
    [self.view addSubview:photoView];
    
    
    //初始化照片／拍照选择
    ZXImagePickerVCManager *pickerVCManager = [[ZXImagePickerVCManager alloc] init];
    pickerVCManager.morePickerActionDelegate = self;
    self.imagePickerVCManager = pickerVCManager;
    //初始化oss上传
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
    [self.photosView.images addObject:image];
    
    
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    [self zhHUD_showHUDAddedTo:self.view labelText:@"正在上传"];
//    WS(weakSelf);
//    [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
//        
//    } singleComplete:^(id model, NSString *imageName, NSNumber *imgId) {
//        
//        //这里处理上传图片
//        [weakSelf zhHUD_hideHUDForView:weakSelf.view];
//        
//    } failure:^(NSError *error) {
//        
//        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
//    }];
}


- (void)photosView:(ZXPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images
{
     [self.imagePickerVCManager zxPresentActionSheetToImagePickerWithSourceController:self];
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
