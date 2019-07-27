//
//  AddProductPicsController.m
//  YiShangbao
//
//  Created by simon on 17/3/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  collectionView

#import "AddProductPicsController.h"
#import "ZXAddProPicCollectionCell.h"
#import "ZXImagePickerVCManager.h"
#import "TMDiskManager.h"
#import "AliOSSUploadManager.h"

#define DeleteBtnWidth  36.f
#define DeleteBtnHeight 36.f
#define Section1InsetMagin   89.f
#define Section2InsetMagin   26.f
#define Section2PicToPicMangin 50.f
#define Section1HeaderHeight   18.f
#define Section2HeaderHeight   32.f

#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]
#endif

@interface AddProductPicsController ()<UICollectionViewDelegateFlowLayout,ZXImagePickerVCManagerDelegate,AddProductPicViewDelegate>

@property (nonatomic ,strong)ZXImagePickerVCManager *imagePickerVCManager;

@property (nonatomic, strong)NSMutableArray *section1MArray;
@property (nonatomic, strong)NSMutableArray *section2MArray;

@property (nonatomic, strong)TMDiskManager *diskManager;


@property (nonatomic, strong)NSIndexPath *editIndexPath;
//总数据集合
@property (nonatomic, strong)NSMutableArray *dataMArray;
@end

@implementation AddProductPicsController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = UIColorFromRGB_HexValue(0xf3f3f3);

    ZXImagePickerVCManager *pickerVCManager = [[ZXImagePickerVCManager alloc] init];
    pickerVCManager.morePickerActionDelegate = self;
    self.imagePickerVCManager = pickerVCManager;
    
    NSMutableArray *dataM = [NSMutableArray array];
    self.dataMArray = dataM;
    

    NSMutableArray *mArr = [NSMutableArray array];
    self.section1MArray = mArr;
    
    NSMutableArray *mArr2 = [NSMutableArray array];
    self.section2MArray = mArr2;

    [self.collectionView registerClass:[ZXAddProPicCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];

    //初始化oss上传
    
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
    [AliOSSUploadManager sharedInstance].getPicInfo = YES;

    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    if (model.pics.count>0)
    {
        [self.section1MArray addObject:[model.pics firstObject]];
        if (model.pics.count>1)
        {
            NSArray *arr = [model.pics subarrayWithRange:NSMakeRange(1, model.pics.count-1)];
            [self.section2MArray addObjectsFromArray:arr];
        }
    }
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (section ==0)
    {
        return 1;
    }
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        CGFloat width = floorf(LCDW-LCDScale_iPhone6_Width(Section1InsetMagin)*2);
        return CGSizeMake(width, width);
    }
    CGFloat picToPicWidth =(Section2PicToPicMangin-DeleteBtnWidth/2);
    CGFloat width2 = floorf((LCDW-2*Section2InsetMagin+DeleteBtnWidth/2-picToPicWidth)/2);
    return CGSizeMake(width2, width2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section ==1)
    {
        return CGSizeMake(0, Section2HeaderHeight-DeleteBtnWidth/2);
    }
    //最小应该是一半删除按钮的高度；
    CGFloat headerHeight = Section1HeaderHeight-DeleteBtnWidth/2;
    if (headerHeight<0)
    {
        headerHeight = 0.1f;
    }
    return CGSizeMake(0, headerHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section ==0)
    {
        CGFloat magin =floorf(LCDScale_iPhone6_Width(Section1InsetMagin));
        return UIEdgeInsetsMake(0, magin+DeleteBtnWidth/4, 0, magin-DeleteBtnWidth/4);
    }
    return UIEdgeInsetsMake(0, Section2InsetMagin, 0, Section2InsetMagin-DeleteBtnWidth/2);;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXAddProPicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.section ==0)
    {
        if (self.section1MArray.count >indexPath.item)
        {
            [cell setData:[self.section1MArray objectAtIndex:indexPath.item]];
        }
        else
        {
            [cell setData:[NSNull null]];
        }
        cell.itemView.origTitleLab.text = @"上传主图";
    }
    else
    {
        if (self.section2MArray.count>indexPath.item)
        {
            [cell setData:[self.section2MArray objectAtIndex:indexPath.item]];
        }
        else
        {
            [cell setData:[NSNull null]];
        }
        cell.itemView.origTitleLab.text = @"上传细节图";

    }
    
    [cell.itemView.picBtn addTarget:self action:@selector(uploadPic:) forControlEvents:UIControlEventTouchUpInside];
    cell.itemView.delegate = self;
    // Configure the cell
    
    return cell;
}


//代理
- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
    NSData *imageData = [WYUtility zipNSDataWithImage:image];
    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];
//    self.rightBarItem.enabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    WS(weakSelf);
    [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_uploadProduct uploadingData:imageData progress:nil singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
 
        AliOSSPicUploadModel *model = [[AliOSSPicUploadModel alloc] init];
        model.p = imagePath;
        model.w = imageSize.width;
        model.h = imageSize.height;
        
        [weakSelf zhHUD_showSuccessWithStatus:@"上传成功"];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
//        self.rightBarItem.enabled = YES;
        if (weakSelf.editIndexPath.section ==0)
        {
            [weakSelf.section1MArray addObject:model];
//          [weakSelf.section1MArray replaceObjectAtIndex:_editIndexPath.item withObject:imagePath];
        }
        else
        {
            [weakSelf.section2MArray addObject:model];
//          [weakSelf.section2MArray replaceObjectAtIndex:_editIndexPath.item withObject:imagePath];
        }
        [weakSelf.collectionView reloadData];
        //这里处理上传图片
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
//        self.rightBarItem.enabled = YES;
        weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;

    }];
}

- (void)zxDeleteBtnAction:(UIButton *)sender
{
     NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.collectionView];
    if (indexPath.section ==0)
    {
        [_section1MArray removeAllObjects];
//        [_section1MArray replaceObjectAtIndex:0 withObject:[NSNull null]];
    }
    else
    {
        [_section2MArray removeObjectAtIndex:indexPath.item];
//        [_section2MArray replaceObjectAtIndex:indexPath.item withObject:[NSNull null]];
    }
    [self.collectionView reloadData];
}

- (void)uploadPic:(UIButton *)sender
{
    NSIndexPath *index = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.collectionView];
    self.editIndexPath = index;
    NSLog(@"indexPath =%@,section:%ld,row=%ld",self.editIndexPath,(long)self.editIndexPath.section,self.editIndexPath.item);

    [self.imagePickerVCManager zxPresentActionSheetToImagePickerWithSourceController:self];
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (IBAction)saveBarItemAction:(UIBarButtonItem *)sender
{
    [self.dataMArray removeAllObjects];
    
    if (self.section1MArray.count==0)
    {
        [self zhHUD_showErrorWithStatus:@"请上传主图"];
        return;
    }
    [self.dataMArray addObjectsFromArray:self.section1MArray];
    if (self.section2MArray.count>0)
    {
        [self.dataMArray addObjectsFromArray:self.section2MArray];
    }
    
    [self.diskManager setPropertyImplementationValue:self.dataMArray forKey:@"pics"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
