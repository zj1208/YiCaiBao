//
//  CCChooseVideoViewController.m
//  SortOut
//
//  Created by light on 2017/11/23.
//  Copyright © 2017年 light. All rights reserved.
//

#import "CCChooseVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "CCVideoCollectionViewCell.h"
#import "SJRecordViewController.h"
#import "SJVideoInfoEditingViewController.h"
//#import "NSBundle+TZImagePicker.h"

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

@interface CCChooseVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIVideoEditorControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic ,strong) UIImagePickerController *imagePickerVc;

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UICollectionViewFlowLayout *customLayout;

@property (nonatomic ,strong) NSMutableArray *VideoArr;

@end

@implementation CCChooseVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频";
    [self creatUI];
    [self loadVideos];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)reload{
    [self.collectionView reloadData];
}

- (void)dealloc{
    
}

#pragma mark- 返回数据
- (void)returnVideoURL:(NSURL *)urlString{
    
    NSData *data = [NSData dataWithContentsOfURL:urlString];
    if (self.block) {
        self.block(data,urlString);
//        [self removeDelegateForItemNames];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)returnVideoInfo:(SelectedVideo)block{
    self.block = block;
}

#pragma mark- 拍视频
- (void)addTakeVideo{
    [self typeAudioStatus];
}

- (void)typeAudioStatus{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self typeVideoStatus];
                });
            }
        }];
    }else if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置-隐私”选项中，允许义采宝访问你的麦克风" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        [self typeVideoStatus];
    }else{
        [self typeVideoStatus];
    }
}

- (void)typeVideoStatus{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置-隐私”选项中，允许义采宝访问你的摄像头" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self takeVideo];
                });
            }
        }];
    } else {
        [self takeVideo];
    }
}

- (void)takeVideo{
    SJRecordViewController *vc = [[SJRecordViewController alloc]init];
    
    vc.recordVideoBlock = ^(AVAsset *asset) {
        AVURLAsset *avURLAsset = (AVURLAsset *)asset;
        NSLog(@"%@",avURLAsset.URL.absoluteString);
        
        
        SJVideoInfoEditingViewController *vc = [[SJVideoInfoEditingViewController alloc] initWithAsset:asset direction:0];
        vc.block = ^(BOOL isSelected) {
            if (isSelected) {
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([avURLAsset.URL path])){
                    UISaveVideoAtPathToSavedPhotosAlbum([avURLAsset.URL path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
                //视频压缩
                [self convertVideoQuailtyWithInputURL:avURLAsset.URL outputURL:nil completeHandler:nil];
            }else{
                [self takeVideo];
                [self.navigationController popToViewController:self animated:YES];
            }
        };
//        vc.coverImage = coverImage;
        [self.navigationController pushViewController:vc animated:YES];
//        self.areaView.enableRecordBtn = YES;
        
//        CCPlayTakeVideoViewController *vc = [[CCPlayTakeVideoViewController alloc]init];
//        vc.url = avURLAsset.URL.absoluteString;
//        vc.asset = asset;
//        CCVideoPlayerViewController *playerViewVC = [[CCVideoPlayerViewController alloc]init];
////        [playerViewVC updatePlayerWithURL:photo.original_pic];
//        [playerViewVC updatePlayerWithURL:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"];
//        [self presentViewController:playerViewVC animated:YES completion:nil];
//        [self.navigationController pushViewController:vc animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:vc animated:YES completion:nil];
    
//    _imagePickerVc = [[UIImagePickerController alloc] init];
//    _imagePickerVc.delegate = self;
//    _imagePickerVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    _imagePickerVc.showsCameraControls = NO;
//    UIView *overLayView=[[UIView alloc]initWithFrame:self.view.bounds];
//
//    _imagePickerVc.cameraOverlayView = overLayView;
////    _imagePickerVc.allowsEditing = YES;
//    _imagePickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
//    //录制视频时长，默认
//    _imagePickerVc.videoMaximumDuration = self.maximumDuration;
//    _imagePickerVc.modalPresentationStyle=UIModalPresentationOverFullScreen;
//    //相机类型（拍照、录像...）字符串需要做相应的类型转换
//    _imagePickerVc.mediaTypes = @[(NSString *)kUTTypeMovie];
//    //视频上传质量
//    //UIImagePickerControllerQualityTypeHigh高清
//    //UIImagePickerControllerQualityTypeMedium中等质量
//    //UIImagePickerControllerQualityTypeLow低质量
//    //UIImagePickerControllerQualityType640x480
//    _imagePickerVc.videoQuality = UIImagePickerControllerQualityTypeHigh;
//    //设置摄像头模式（拍照，录制视频）为录像模式
//    _imagePickerVc.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
//    [self presentViewController :_imagePickerVc animated:NO completion:nil];
    
}

#pragma mark- 编辑视频
- (void)editVideo:(AVURLAsset *)urlAsset{
    NSURL *videoURL = urlAsset.URL;
    UIVideoEditorController *editVC; // 检查这个视频资源能不能被修改
    if ([UIVideoEditorController canEditVideoAtPath:videoURL.path]) {
        editVC = [[UIVideoEditorController alloc] init];
        editVC.videoPath = videoURL.path;
        editVC.delegate = self;
        editVC.videoMaximumDuration = self.maximumDuration;
        [self presentViewController:editVC animated:YES completion:nil];
    }else{
        [MBProgressHUD zx_showError:@"视频不能被编辑" toView:nil];
    }
}

#pragma mark- 压缩视频
- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL completeHandler:(void (^)(AVAssetExportSession*))handler{
    
    if (!outputURL){
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        outputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp/output-%@.mp4", [formater stringFromDate:[NSDate date]]]];
    }
    __weak typeof(self)WeakSelf = self;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
             {
//                 NSLog(@"我录制的视频时长为:%@",[NSString stringWithFormat:@"%.2f s", 11.2]);//[self getVideoLength:outputURL]]);
//                 NSLog(@"我压缩后的视频大小为:%@", [NSString stringWithFormat:@"%.2f mb", [self getFileSize:[outputURL path]]]);
//                 if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([outputURL path])){
//                     UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//                 }
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [WeakSelf returnVideoURL:outputURL];
                         [WeakSelf.navigationController popViewControllerAnimated:YES];
                     });
                 
                 break;
             }
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
}

- (double) getFileSize:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }else{
        NSLog(@"保存视频成功");
    }
}

#pragma mark -UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //视频压缩
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
//    NSLog(@"我获取到的未压缩前的视频大小是:%@", [NSString stringWithFormat:@"%.2f mb", [self getFileSize:[sourceURL path]]]);
//    if ([[NSString stringWithFormat:@"%.2f", [self getFileSize:[sourceURL path]]] integerValue]>=1024) {
//    }
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([sourceURL path])){
        UISaveVideoAtPathToSavedPhotosAlbum([sourceURL path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
    //视频压缩
    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:nil completeHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UIVideoEditorControllerDelegate
//编辑成功后的Video被保存在沙盒的临时目录中
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
    //视频压缩
    [self convertVideoQuailtyWithInputURL:[NSURL fileURLWithPath:editedVideoPath] outputURL:nil completeHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 编辑失败后调用的方法
- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    NSLog(@"%@",error.description);
    [self dismissViewControllerAnimated:YES completion:nil];
}

//编辑取消后调用的方法
- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.VideoArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CCVideoCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:CCVideoCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.row > 0) {
        [cell updateData:self.VideoArr[indexPath.row - 1]];
    }else{
        [cell updateData:nil];
    }
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return (CGSize){([UIScreen mainScreen].bounds.size.width - 3)/4,([UIScreen mainScreen].bounds.size.width - 3)/4};
}

#pragma mark ---- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        CCVideoCollectionViewCell *cell = (CCVideoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.urlAsset){
            [self editVideo:cell.urlAsset];
        }else{
            [self reload];
        }
    }else{
        [self addTakeVideo];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark- PrivateUI
- (void)creatUI{
    _customLayout = [[UICollectionViewFlowLayout alloc] init];
    _customLayout.minimumLineSpacing = 1;
    _customLayout.minimumInteritemSpacing = 1;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_customLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[CCVideoCollectionViewCell class] forCellWithReuseIdentifier:CCVideoCollectionViewCellID];
    
}

- (void)loadVideos{
//相册权限判断
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if ((status == AVAuthorizationStatusRestricted || status ==AVAuthorizationStatusDenied)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置-隐私”选项中，允许义采宝访问您的相册" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusDenied ) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadVideos];
                });
            }
        }];
        return;
    }
    
    self.VideoArr = [NSMutableArray array];
    
    
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
    for (NSInteger i = 0; i < assetsFetchResults.count; i++) {
        // 获取一个资源（PHAsset）
        PHAsset *asset = assetsFetchResults[i];
        CCVideoModel *model = [[CCVideoModel alloc]init];
        if (asset.mediaType == PHAssetMediaTypeVideo){
            model.phAsset = asset;
            [self.VideoArr addObject:model];
        }
    }
    [self reload];
}

#pragma mark- Getter
- (CGFloat)maximumDuration{
    if(!_maximumDuration){
        _maximumDuration = 10.0;
    }
    return _maximumDuration;
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
