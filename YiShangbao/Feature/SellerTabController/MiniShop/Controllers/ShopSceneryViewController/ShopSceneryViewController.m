//
//  ShopSceneryViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopSceneryViewController.h"
#import "ShopSceneryView.h"
#import "LiveAcitonModel.h"
#import "UIViewController+XHPhoto.h"

//图片上传
#import "AliOSSUploadManager.h"
@interface ShopSceneryViewController ()
@property(nonatomic, strong)LiveAcitonModel *model;
@property(nonatomic, strong)NSMutableArray *otherImage;
@property(nonatomic, copy)NSString *leftdownStr;
@property(nonatomic, copy)NSString *rightdownStr;
@end

@implementation ShopSceneryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self initData];

    //初始化oss上传
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
    self.leftdownStr = nil;
    self.rightdownStr = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)creatUI{
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = WYUISTYLE.fontWith28;
//    [rightBtn setTitleColor:WYUISTYLE.colorMTblack forState:UIControlStateNormal];
//    [rightBtn sizeToFit];
//    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
//    UIBarButtonItem *BtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem  = BtnItem;
    
    self.title = @"商铺实景";
    ShopSceneryView *view = [[ShopSceneryView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    
    [view.cellTop.btn addTarget:self action:@selector(cellTopTap) forControlEvents:UIControlEventTouchUpInside];
    [view.cellLeftup.btn addTarget:self action:@selector(cellLeftupTap) forControlEvents:UIControlEventTouchUpInside];
    [view.cellRightup.btn addTarget:self action:@selector(cellRightupTip) forControlEvents:UIControlEventTouchUpInside];
    [view.cellLeftDown.btn addTarget:self action:@selector(cellLeftDownTap) forControlEvents:UIControlEventTouchUpInside];
    [view.cellRightDown.btn addTarget:self action:@selector(cellRightDownTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_top addTarget:self action:@selector(btnTopTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_Leftup addTarget:self action:@selector(btnLeftupTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_Rightup addTarget:self action:@selector(btnRightTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_LeftDown addTarget:self action:@selector(btnLeftDownTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_RightDown addTarget:self action:@selector(btnRightDownTap) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initData{
    self.model = [[LiveAcitonModel alloc] init];
    
    [[[AppAPIHelper shareInstance] liveActionAPI] getLiveActionWithShopId:nil success:^(id data) {
        [self dataUI:data];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


-(void)dataUI:(id)data{

    self.model = (LiveAcitonModel *)data;
    if (self.model.others.length) {
        NSArray *array = [self.model.others componentsSeparatedByString:@","];
        if (array.count == 2) {
            self.leftdownStr = array[0];
            self.rightdownStr = array[1];
        }else{
            self.leftdownStr = array[0];
        }
    }
    [self refreshUI];
}
-(void)refreshUI{
    ShopSceneryView *view = (ShopSceneryView *)self.view;
    [view.cellTop.pic sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w600_hX relativeToImgPath:self.model.center] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    [view.cellLeftup.pic sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:self.model.left] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    [view.cellRightup.pic sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:self.model.right] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    [view.cellLeftDown.pic sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:self.leftdownStr] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    [view.cellRightDown.pic sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:self.rightdownStr] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    if (self.model.center.length) {
        view.btn_top.hidden = NO;
    }else{
        view.btn_top.hidden = YES;
    }
    if (self.model.left.length) {
        view.btn_Leftup.hidden = NO;
    }else{
        view.btn_Leftup.hidden = YES;
    }
    if (self.model.right.length) {
        view.btn_Rightup.hidden = NO;
    }else{
        view.btn_Rightup.hidden = YES;
    }
    if (self.leftdownStr.length) {
        view.btn_LeftDown.hidden = NO;
    }else{
        view.btn_LeftDown.hidden = YES;
    }
    if (self.rightdownStr.length) {
        view.btn_RightDown.hidden = NO;
    }else{
        view.btn_RightDown.hidden = YES;
    }
}
#pragma mark - btn事件
-(void)rightBtnAction{
    if (self.leftdownStr.length&&self.rightdownStr.length) {
        self.model.others = [NSString stringWithFormat:@"%@,%@",self.leftdownStr,self.rightdownStr];
    }else if(self.rightdownStr.length){
        self.model.others = [NSString stringWithFormat:@"%@",self.rightdownStr];
    }else if(self.leftdownStr.length){
        self.model.others = [NSString stringWithFormat:@"%@",self.leftdownStr];
    }else{
        self.model.others = @"";
    }
    
    [[[AppAPIHelper shareInstance] liveActionAPI] addOrUpdateLiveActionWith:@(self.model.shopId.integerValue) left:self.model.left center:self.model.center right:self.model.right others:self.model.others success:^(id data) {
//        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}
-(void)cellTopTap{
    WS(weakSelf)
    [self showCanEdit:NO photo:^(UIImage *photo) {
        if(photo){
            NSData *imageData = [WYUtility zipNSDataWithImage:photo];
//            NSData *imageData = UIImageJPEGRepresentation(photo, 1);
            [weakSelf zhHUD_showHUDAddedTo:weakSelf.view labelText:@"正在上传"];
            [[AliOSSUploadManager sharedInstance] putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_shopScenery uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
                ShopSceneryView *view = (ShopSceneryView *)weakSelf.view;
                weakSelf.model.center = imagePath;
                [weakSelf rightBtnAction];
                [view.cellTop.pic sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w600_hX relativeToImgPath:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakSelf zhHUD_hideHUDForView:weakSelf.view];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.model.center) {
                            view.btn_top.hidden = NO;
                        }else{
                            view.btn_top.hidden = YES;
                        }
                });
            } failure:^(NSError *error) {
                [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
            }];
        }
    }];
}
-(void)cellLeftupTap{
    WS(weakSelf)
    [self showCanEdit:NO photo:^(UIImage *photo) {
        if(photo){
//            NSData *imageData = UIImageJPEGRepresentation(photo, 1);
            NSData *imageData = [WYUtility zipNSDataWithImage:photo];
            [weakSelf zhHUD_showHUDAddedTo:weakSelf.view labelText:@"正在上传"];
            WS(weakSelf);
            [[AliOSSUploadManager sharedInstance] putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_shopScenery uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
                ShopSceneryView *view = (ShopSceneryView *)weakSelf.view;
                weakSelf.model.left = imagePath;
                [weakSelf rightBtnAction];
                [view.cellLeftup.pic sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakSelf zhHUD_hideHUDForView:weakSelf.view];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (weakSelf.model.left) {
                        view.btn_Leftup.hidden = NO;
                    }else{
                        view.btn_Leftup.hidden = YES;
                    }
                });
            } failure:^(NSError *error) {
                [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
            }];
        }
    }];
    
}
-(void)cellRightupTip{
    WS(weakSelf)
    [self showCanEdit:NO photo:^(UIImage *photo) {
        if(photo){
//            NSData *imageData = UIImageJPEGRepresentation(photo, 1);
            NSData *imageData = [WYUtility zipNSDataWithImage:photo];
            [weakSelf zhHUD_showHUDAddedTo:weakSelf.view labelText:@"正在上传"];
            [[AliOSSUploadManager sharedInstance] putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_shopScenery uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
                weakSelf.model.right = imagePath;
                ShopSceneryView *view = (ShopSceneryView *)weakSelf.view;
                [weakSelf rightBtnAction];
                [view.cellRightup.pic sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakSelf zhHUD_hideHUDForView:weakSelf.view];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.model.right) {
                        view.btn_Rightup.hidden = NO;
                    }else{
                        view.btn_Rightup.hidden = YES;
                    }
                });
            } failure:^(NSError *error) {
                [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
            }];
        }
    }];
}
-(void)cellLeftDownTap{
    WS(weakSelf)
    [self showCanEdit:NO photo:^(UIImage *photo) {
        if(photo){
//            NSData *imageData = UIImageJPEGRepresentation(photo, 1);
            NSData *imageData = [WYUtility zipNSDataWithImage:photo];
            [weakSelf zhHUD_showHUDAddedTo:weakSelf.view labelText:@"正在上传"];
            [[AliOSSUploadManager sharedInstance] putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_shopScenery uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
                ShopSceneryView *view = (ShopSceneryView *)weakSelf.view;
                weakSelf.leftdownStr = imagePath;
                [weakSelf rightBtnAction];
              [view.cellLeftDown.pic sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                  [weakSelf zhHUD_hideHUDForView:weakSelf.view];
              }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.leftdownStr) {
                        view.btn_LeftDown.hidden = NO;
                    }else{
                        view.btn_LeftDown.hidden = YES;
                    }
                });
            } failure:^(NSError *error) {
                [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
            }];
        }
    }];
}
-(void)cellRightDownTap{
    WS(weakSelf)
    [weakSelf showCanEdit:NO photo:^(UIImage *photo) {
        if(photo){
//            NSData *imageData = UIImageJPEGRepresentation(photo, 1);
            NSData *imageData = [WYUtility zipNSDataWithImage:photo];
            [weakSelf zhHUD_showHUDAddedTo:weakSelf.view labelText:@"正在上传"];
            [[AliOSSUploadManager sharedInstance] putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_shopScenery uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
                ShopSceneryView *view = (ShopSceneryView *)weakSelf.view;
                weakSelf.rightdownStr = imagePath;
                [weakSelf rightBtnAction];
                [view.cellRightDown.pic sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                     [weakSelf zhHUD_hideHUDForView:weakSelf.view];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (weakSelf.rightdownStr) {
                        view.btn_RightDown.hidden = NO;
                    }else{
                        view.btn_RightDown.hidden = YES;
                    }
                });
              
            } failure:^(NSError *error) {
                [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
            }];
        }
    }];
    
}
-(void)btnTopTap{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除此图片么？", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.model.center = @"";
        [self refreshUI];
        [self rightBtnAction];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)btnLeftupTap{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除此图片么？", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.model.left = @"";
        [self refreshUI];
        [self rightBtnAction];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)btnRightTap{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除此图片么？", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.model.right = @"";
        [self refreshUI];
        [self rightBtnAction];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)btnLeftDownTap{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除此图片么？", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.leftdownStr = @"";
        [self refreshUI];
        [self rightBtnAction];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)btnRightDownTap{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除此图片么？", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.rightdownStr = @"";
        [self refreshUI];
        [self rightBtnAction];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
