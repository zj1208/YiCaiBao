//
//  ZXAddPicCollectionView.h
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.

//  简介：N行*N列 格式的添加图片组件，最后一个是添加图片按钮；可以自定义提示view（UIButton图 + 提示UILabel）；目前为止数据源是ZXPhoto对象，才可以添加自定义的遮图；本地image对象数据源不可以；

//  注意：（1）删除item时候，如果外层tableView/collectionView调用[self.tableView  reloadData]方法会让cell中的删除动画无效；
//       （2）如果当前view是作为cell的子视图，则不要用reloadIndexPaths，reloadSections方法刷新cell，否则必须每次重新调用setData方法新赋值数据，因为会新创建一个cell2+cell2数据作为复用；不然会有莫名不好用户交互；

//  待优化 
//   （1）长按item时候，可以增加动画抖动效果；（2）iOS9方法遇到不能切换的需要cancle，如果遇到中间不能切换的item，造成无法越过那个item，用户使用体验非常的差；
//   （3）self.tableView.estimatedRowHeight = 125.f;self.tableView.rowHeight = UITableViewAutomaticDimension; 当tableView使用预算高度方法后，调用[self.tableView  reloadData]会导致tableView滚动一下,让离屏幕最近的cell到屏幕起点；除非每个cell高度固定，也不用预算高度技术；
//  5.03  九宫格组件优化；改为外部动态配置遮图；
//  5.17  增加长按item移动功能；
//  6.01  增加裁剪；
//  6.08  过滤9宫格编辑图片组件中cell空白区域的无效长按事件，点击事件；

#import <UIKit/UIKit.h>
#import "ZXAddPicViewCell.h"
// 图片模型
#import "ZXPhoto.h"
#import "ZXAddPicCoverView.h"
#import "ZXAddPicViewKit.h"

NS_ASSUME_NONNULL_BEGIN

// 图片状态
typedef NS_ENUM(NSInteger, ZXPhotosViewState) {
    
    ZXPhotosViewStateWillCompose = 0,   // 未发布
    ZXPhotosViewStateDidCompose = 1     // 已发布
};

// 编辑方式
typedef NS_ENUM(NSInteger, ZXAddPicCellEditingStyle) {
    
    ZXAddPicCellEditingStyleNone,
    ZXAddPicCellEditingStyleDelete, // 删除
    ZXAddPicCellEditingStyleInsert  // 添加
};

static NSString * const ZXAddAssetImageName = @"zxPhoto_addAsset";
static NSString * const ZXAddPhotoImageName = @"zxPhoto_addImage";

@protocol ZXAddPicCollectionViewDelegate;


@interface ZXAddPicCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<ZXAddPicCollectionViewDelegate>delegate;

@property (nonatomic, strong) UICollectionView *collectionView;


// 添加默认提示view
@property (nonatomic, strong) ZXAddPicCoverView *addPicCoverView;


@property (nonatomic, assign) BOOL showAddPicCoverView;

/** 所有图片的状态（默认为已发布状态） */
@property (nonatomic, assign) ZXPhotosViewState photosState;

// 可以是image数组，也可以是url地址；
@property (nonatomic, strong) NSMutableArray *dataMArray;

// 本地image数组
@property (nonatomic, strong) NSMutableArray *images;

// 设置collectionView的sectionInset

@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@property (nonatomic, assign) CGFloat minimumLineSpacing;


/**
 *  一个屏幕显示多少列；最好小于等于4列；
 */
@property (nonatomic, assign) NSInteger columnsCount;


@property (nonatomic, getter=isExistInputItem) BOOL existInputItem;

@property (nonatomic, strong) UIImage *addButtonPlaceholderImage;

@property (nonatomic, assign) NSInteger maxItemCount;

// 设置item的width，height，size；
@property (nonatomic, assign) CGFloat picItemWidth;
@property (nonatomic, assign) CGFloat picItemHeight;
@property (nonatomic, assign) CGSize picItemSize;


// 设置是否可以移动item；默认NO； 移动item的开关；
@property (nonatomic, assign, getter=isCanMoveItem) BOOL canMoveItem;

// 是否展示删除icon按钮
@property (nonatomic, assign) BOOL showDeleteIconButton;

// 获取是否包含视频资源；
@property (nonatomic, getter=isContainVideoAsset) BOOL containVideoAsset;

// 获取删除item前后内容高度是否改变；
@property (nonatomic, readonly, getter=isChangeDeleteContentHeight) BOOL changeDeleteContentHeight;


// 自适应缩放宽度大小：计算出来后用于设置一个总宽度（比如屏幕宽度）下放几个的平均item宽度；
- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)columnsCount sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing;

- (BOOL)containsVideoObject:(NSArray *)data;

- (void)updatePlaceholderButtonImage:(UIImage *)placeholderImage;


- (void)setData:(NSArray *)data;

/**
 获取整个collectionView需要的高度
 
 @param data 数组
 @return 高度
 */
- (CGFloat)getCellHeightWithContentData:(NSArray *)data;

@end



@protocol ZXAddPicCollectionViewDelegate <NSObject>

@required
/**
 编辑（添加按钮,删除小按钮）的时候回调；

 @param addPicCollectionView self
 @param editingStyle ZXAddPicCellEditingStyle
 @param indexPath indexPath  在默认覆盖图按钮 响应事件的时候为nil
 */
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView  commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(nullable NSIndexPath *)indexPath;


// 点击已存在的图片
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray;

@optional

//注意：长按事件正在进行的时候，不能调用collectionView的reload方法；

/**
 长按手势事件刚开始began的时候回调,判断长按事件是否有效，是否可以移动item；

 @param addPicCollectionView addPicCollectionView description
 @param indexPath indexPath description
 @return return value description
 */
- (BOOL)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView shouldLongPressGestureStateBeganCanMoveItemAtIndexPath:(NSIndexPath *)indexPath;


/**
 长按手势在change移动的时候回调，判断是否可以移动到指定indexPath；sourceIndexPath非nil；

 @param addPicCollectionView addPicCollectionView description
 @param sourceIndexPath sourceIndexPath description
 @param destinationIndexPath destinationIndexPath description
 @return return value description
 */
- (BOOL)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(nullable NSIndexPath *)destinationIndexPath;


///**
// 长按手势在change移动,且有效更新数据的时候回调；非nil;
//
// @param addPicCollectionView addPicCollectionView description
// @param sourceIndexPath sourceIndexPath description
// @param destinationIndexPath destinationIndexPath description
// */
//- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView movingItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;


/**
 长按手势end时候回调;当移动到目标indexPath是nil时候，即destinationIndexPath = nil时候，直接结束；

 @param addPicCollectionView addPicCollectionView description
 @param sourceIndexPath sourceIndexPath description
 @param destinationIndexPath destinationIndexPath description
 */
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView longPressGestureStateEndAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(nullable NSIndexPath *)destinationIndexPath;



/**
 长按手势end时候回调;当有效sourceIndexPath结束移动,移动到一个目标有效的destinationIndexPath，会回调这个代理；如果没有改变sourceIndexPath（sourceIndexPath ==destinationIndexPath）， 或目标indexPath（destinationIndexPath） =nil，则不会回调；

 @param addPicCollectionView addPicCollectionView description
 @param sourceIndexPath sourceIndexPath description
 @param destinationIndexPath destinationIndexPath description
 */
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView didEndMoveAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end


NS_ASSUME_NONNULL_END


/*******************************例如*多张图片上传******************/

#pragma mark - 举例
#pragma mark -1.UITableViewCell:HeaderPicsViewCell初始化

//1.UITableViewCell:HeaderPicsViewCell初始化

//@implementation HeaderPicsViewCell
/*
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    ZXAddPicCollectionView *picView = [[ZXAddPicCollectionView alloc] init];
    picView.maxItemCount = 9;
    picView.minimumInteritemSpacing = 12.f;
    picView.photosState = ZXPhotosViewStateDidCompose;
    picView.sectionInset = UIEdgeInsetsMake(5, 15, 10, 15);
    picView.picItemWidth = [picView getItemAverageWidthInTotalWidth:LCDW columnsCount:4 sectionInset:picView.sectionInset minimumInteritemSpacing:picView.minimumInteritemSpacing];
    picView.picItemHeight = picView.picItemWidth;
    picView.addButtonPlaceholderImage = [UIImage imageNamed:ZXAddAssetImageName];
    
    picView.addPicCoverView.titleLabel.text = [NSString stringWithFormat:@"添加图片或视频\n(最多9个，视频时长不能超过10秒)"];
    picView.addPicCoverView.titleLabLeading.constant = 23.f;

    self.picsCollectionView = picView;
    [self.contentView addSubview:picView];
    
    [self.picsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(picView.superview.mas_top).offset(0);
        make.bottom.mas_equalTo(picView.superview.mas_bottom).offset(0);
        make.left.mas_equalTo(picView.superview.mas_left).offset(0);
        make.right.mas_equalTo(picView.superview.mas_right).offset(0);
    }];
    //    已经不用了，隐藏就行
    self.containerView.hidden = YES;
    //    如果需要自定义遮图，则用自己建立的自定义布局+contentView注册展示；
    [[ZXAddPicViewKit sharedKit]registerLayoutConfig:[CustomAddPicLayoutConfig new]];

}

// 当有数据的时候
- (void)setData:(id)data
{
    // 动态设置占位符按钮的图标
    if ([self.picsCollectionView containsVideoObject:data] ||self.picsCollectionView.isContainVideoAsset)
    {
        self.picsCollectionView.addButtonPlaceholderImage = [UIImage imageNamed:ZXAddPhotoImageName];
    }
    else
    {
        self.picsCollectionView.addButtonPlaceholderImage = [UIImage imageNamed:ZXAddAssetImageName];
    }
    [self.picsCollectionView setData:data];
}
*/


#pragma mark -2.controller页面

// 2.controller:

/*
#import "ZXAddPicCollectionView.h"
#import "TZImagePickerController.h" //多图选择
#import "XLPhotoBrowser.h" //大图浏览

- (void)viewDidLoad
{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    self.tableView.separatorColor = self.tableView.backgroundColor;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = 60.f;
    self.tableView.contentInset = inset;
    self.tableView.estimatedRowHeight = 45.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     if (indexPath.section ==0)
     {
         HeaderPicsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId_headerPicsView forIndexPath:indexPath];
         cell.picsCollectionView.delegate = self;
         if (_photosMArray.count >0)
         {
             [cell setData:_photosMArray];
         }
         return cell;
     }
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
}
//把请求回来的图片json数组转换成固定格式的ZXPhoto图片model数组：photosMArray
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
*/
/*
#pragma mark - 添加图片视频

- (void)picBtnAction:(id)sender
{
    // 只允许加一个视频，如果已经有视频了，直接添加图片/拍照
    if ([self getViedoStringFormPicArray:self.photosMArray])
    {
        [self presentImagePickerController];
        return;
    }
    [UIAlertController zx_presentActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照和照片",@"视频"] tapBlock:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex ==alertController.firstOtherButtonIndex)
        {
            [self presentImagePickerController];
        }
        else if (buttonIndex ==alertController.firstOtherButtonIndex+1)
        {
            [self presentChooseVideoController];
        }
    }];
}

 
//添加视频
- (void)uploadVideoWith:(NSData *)videoData
{
    WS(weakSelf);
    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];
    [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_ProductVideo uploadingData:videoData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    } singleComplete:^(id  _Nullable imageInfo, NSString * _Nullable imagePath, CGSize imageSize) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:imagePath thumbnailUrl:@""];
        photo.type = ZXAssetModelMediaTypeVideo;
        [weakSelf.photosMArray insertObject:photo atIndex:0];
        [weakSelf.photoCell.picsCollectionView setData:weakSelf.photosMArray];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        
    }];
}

#pragma mark - 添加图片

- (void)picBtnAction:(id)sender
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
 
            //这里处理上传完的图片：把上传添加后的图片数据加入到临时图片数组photosMArray
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:imagePath];
            ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:imagePath thumbnailUrl:picUrl.absoluteString];
            photo.width = imageSize.width;
            photo.height = imageSize.height;
            photo.type = ZXAssetModelMediaTypePhoto;

            [tempMArray addObject:photo];

            if (currentIndex ==photos.count)
            {
                 NSArray * tempMArray2 = [AliOSSUploadManager sortAliOSSImage_UserID_time_WithPhotoModelArr:tempMArray];
 
                 [weakSelf.photosMArray addObjectsFromArray:tempMArray2];
                 [MBProgressHUD zx_hideHUDForView:weakSelf.view];
 
                [weakSelf.photoCell.picsCollectionView setData:weakSelf.photosMArray];
                [weakSelf.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
    }];
}
*/

/*
#pragma mark - ZXAddPicCollectionViewDelegate

- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == ZXAddPicCellEditingStyleInsert)
    {
        [self picBtnAction:nil];
    }
    else
    {
        //删除图片数组models的指定图片数据
        [self.photosMArray removeObjectAtIndex:indexPath.item];
        [self.tableView reloadData];
    }
}


//- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray
//{
////    大图浏览
//    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:picsArray.count datasource:self];
//    browser.browserStyle = XLPhotoBrowserStyleCustom;
//    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
//}

//#pragma mark - XLPhotoBrowserDatasource
//
//- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
//
//    NSString *orginal =[[_photosMArray objectAtIndex:index]original_pic];
//    return [NSURL URLWithString:orginal];
//}

- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray
{
    ZXPhoto *photo = [picsArray objectAtIndex:index] ;
    if (photo.type == ZXAssetModelMediaTypeVideo)
    {
        CCVideoPlayerViewController *playerViewVC = [[CCVideoPlayerViewController alloc]init];
        [playerViewVC updatePlayerWithURL:photo.original_pic];
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
*/

/*
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

 */

// 上传图片地址给自己服务器的时候：转换

// 业务类型1.转换为model数组（json数组）上传
// 图片

/*
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

// model.pics = [self manyPicModelFormPicArray:self.photosMArray];
*/
 


//业务类型2.转换多张图片地址为一个string的拼接地址，直接给服务器；
/*
- (NSString *)manyPicStrFormPicArray:(NSMutableArray *)photoArray
{
    if (photoArray.count ==0)
    {
        return nil;
    }
    //图片
    NSMutableArray *uploadPicArray = [NSMutableArray array];
    [self.photosMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *photo = (ZXPhoto *)obj;
        NSString *picStr = photo.original_pic;
        [uploadPicArray addObject:picStr];
    }];
    return  [uploadPicArray componentsJoinedByString:@","];
}
*/
