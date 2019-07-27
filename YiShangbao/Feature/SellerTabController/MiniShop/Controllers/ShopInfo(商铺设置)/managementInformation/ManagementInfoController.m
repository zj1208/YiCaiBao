//
//  ManagementInfoController.m
//  YiShangbao
//
//  Created by simon on 17/2/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ManagementInfoController.h"
#import "ZXMPickerView.h"
#import "TMDiskManager.h"
#import "ShopModel.h"

#import "WYMainCategoryViewController.h"
#import "TZImagePickerController.h"
#import "AliOSSUploadManager.h"
#import "ZXAddPicCollectionView.h"
#import "XLPhotoBrowser.h"

#define PhotoMargin 15*LCDW/375  //间距
#define ContentWidth LCDW-20


@interface ManagementInfoController ()<ZXMPickerViewDelegate,ZXAddPicCollectionViewDelegate,TZImagePickerControllerDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>

@property (nonatomic ,strong) ZXMPickerView *pickerView;

@property (nonatomic, strong)TMDiskManager *diskManager;

@property (nonatomic, strong)ShopManagerInfoModel *managerInfoModel;

@property (nonatomic, copy) NSArray *yearsArray;

@property (nonatomic, strong)NSMutableArray *photosMArray;

@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *assestArray;



@property (nonatomic, strong)ZXAddPicCollectionView *picsCollectionView;
@end

@implementation ManagementInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self creatUI];
    
    [self initData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
      [self requestData];
}



- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
}
- (void)viewDidLayoutSubviews
{
    //    NSLog(@"%@",self.titleLab);
    self.leftMagin.constant = self.titleLab.zx_x;
    self.leftMagin2.constant = self.titleLab.zx_x;
    self.leftMagin3.constant = self.titleLab.zx_x;
}

- (void)creatUI
{
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:self.saveBtn.frame.size startColor:UIColorFromRGB(255.f, 67.f, 82.f) endColor:UIColorFromRGB(243.f, 19.f, 37.f)];
    [self.saveBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self.saveBtn setCornerRadius:40.f/2 borderWidth:1 borderColor:nil];
    
    
    
    [self.yearBtn setCornerRadius:5.f borderWidth:1.f borderColor:[UIColor lightGrayColor]];
    
    UIImage *selectImage =[UIImage imageNamed:@"选中"];
    UIImage *noSelectImage = [UIImage imageNamed:@"未选"];
    
    [self.domesticSaleBtn zh_setImage:noSelectImage selectImage:selectImage titleColor:[UIColor grayColor] selectTitleColor:WYUISTYLE.colorMred];
    [self.exportSaleBtn zh_setImage:noSelectImage selectImage:selectImage titleColor:[UIColor grayColor] selectTitleColor:WYUISTYLE.colorMred];
    
    [self.ownFactoryBtn zh_setImage:noSelectImage selectImage:selectImage titleColor:[UIColor grayColor] selectTitleColor:WYUISTYLE.colorMred];
    [self.wholesaleBtn zh_setImage:noSelectImage selectImage:selectImage titleColor:[UIColor grayColor] selectTitleColor:WYUISTYLE.colorMred];
    
    self.ownFactoryBtn.tag = 200;
    self.selectModelBtn = self.ownFactoryBtn;
    self.selectModelBtn.selected = YES;
    
    
    ZXMPickerView *picker = [[ZXMPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, LCDScale_iPhone6_Width(260))];
    picker.pickerView.showsSelectionIndicator = YES;
    picker.delegate = self;
    self.pickerView = picker;
    
    [self addPicCollectionView];
}

- (void)addPicCollectionView
{
    self.picBtn.hidden =YES;
    self.label.hidden = self.picBtn.hidden;
    
    ZXAddPicCollectionView *picView = [[ZXAddPicCollectionView alloc] init];
    picView.maxItemCount = 3;
    picView.minimumInteritemSpacing = 16.f;
    picView.photosState = ZXPhotosViewStateDidCompose;
    picView.sectionInset = UIEdgeInsetsMake(5, 15, 10, 15);
    picView.picItemWidth = [picView getItemAverageWidthInTotalWidth:LCDW columnsCount:3 sectionInset:picView.sectionInset minimumInteritemSpacing:picView.minimumInteritemSpacing];
    picView.picItemHeight = picView.picItemWidth;
    picView.delegate =self;
    
    picView.addButtonPlaceholderImage = [UIImage imageNamed:ZXAddPhotoImageName];
    picView.addPicCoverView.titleLabel.text = [NSString stringWithFormat:@"请上传3张真实的工厂照片\n让采购商更清楚您的实力"];
    self.picsCollectionView = picView;
    [self.picCellContentView2 addSubview:picView];
    
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(picView.superview.mas_top).offset(0);
        make.bottom.mas_equalTo(picView.superview.mas_bottom).offset(0);
        make.left.mas_equalTo(picView.superview.mas_left).offset(0);
        make.right.mas_equalTo(picView.superview.mas_right).offset(0);
    }];
    [ZXAddPicViewKit resetLayoutConfig];


}
- (void)initData
{
    
    self.yearsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"10+"];
    [self.pickerView reloadDataWithDataArray:self.yearsArray];
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskShopManageInfoKey];
    self.diskManager = manager;
    
    ShopManagerInfoModel *model = [[ShopManagerInfoModel alloc] init];
    self.managerInfoModel =model;
    [self.diskManager setData:model];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopInfoChange:) name:TMDiskShopManageInfoKey object:nil];
    

    _photosMArray = [NSMutableArray arrayWithCapacity:3];
    

    
    [self initImagePickerVCManager];

}

- (void)initImagePickerVCManager {

    //初始化oss上传
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
//    //是否需要获取图片信息，长宽
//    [AliOSSUploadManager sharedInstance].getPicInfo = YES;
}

- (void)requestData
{
    [MBProgressHUD zx_showLoadingWithStatus:@"正在加载..." toView:self.view];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]shopAPI]getShopManagerInfoWithshopId:_shopId success:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        _managerInfoModel = nil;
        _managerInfoModel = [[ShopManagerInfoModel alloc] init];
        _managerInfoModel = data;
        
        [_diskManager setData:_managerInfoModel];
        [weakSelf reloadAllData:_managerInfoModel];
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}


#pragma mark - 选择添加图片按钮

- (void)picBtnAction:(id)sender
{
    //初始化选择照片
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:(3-self.photosMArray.count) delegate:self];
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

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{

 
    
    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];

    __block NSInteger currentIndex = 0;
    NSMutableArray *tempMArray = [NSMutableArray array];
    WS(weakSelf);
    [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIImage *image = (UIImage *)obj;
        NSData *imageData = [WYUtility zipNSDataWithImage:image];
        
        [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_ownFactory uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
        } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
            
            currentIndex ++;
            //这里处理上传图片
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:imagePath];
            ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:imagePath thumbnailUrl:picUrl.absoluteString];
            [tempMArray addObject:photo];
            if (currentIndex ==photos.count)
            {
                [MBProgressHUD zx_hideHUDForView:weakSelf.view];
                [weakSelf.photosMArray addObjectsFromArray:tempMArray];
                [weakSelf.picsCollectionView setData:weakSelf.photosMArray];
                [weakSelf.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];

    }];
    
}

#pragma mark - ZXAddPicCollectionViewDelegate
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == ZXAddPicCellEditingStyleInsert)
    {
        [self picBtnAction:nil];
    }
    else
    {
        [self.photosMArray removeObjectAtIndex:indexPath.item];
        [self.tableView reloadData];
    }
}

- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray
{
    //大图浏览
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:picsArray.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
}



#pragma mark    - XLPhotoBrowserDatasource

- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    
    NSString *orginal =[[_photosMArray objectAtIndex:index]original_pic];
    return [NSURL URLWithString:orginal];
}


#pragma  mark - 按钮转换

- (ShopSaleType)getShopSaleType
{
    if (self.exportSaleBtn.selected && !self.domesticSaleBtn.selected)
    {
        return ShopSaleType_export;
    }
    else if (!self.exportSaleBtn.selected && self.domesticSaleBtn.selected)
    {
        return ShopSaleType_domestic;
    }
    else if (self.exportSaleBtn.selected &&self.domesticSaleBtn.selected)
    {
        return ShopSaleType_domesticAndExport;
    }
    else return ShopSaleType_NO;
}


- (ShopProSourceType)getShopProductSource
{
    ShopProSourceType type ;
    switch (self.selectModelBtn.tag)
    {
        case 200:type =ShopProSourceType_ownFactory;  break;
            
        default:type =ShopProSourceType_wholesale;
            break;
    }
    return type;
}



- (IBAction)saleTypeAction:(UIButton *)sender {
//    if (sender != self.selectSaleBtn)
//    {
//        self.selectSaleBtn.selected = NO;
//        self.selectSaleBtn = sender;
//    }
//    self.selectSaleBtn.selected = YES;
    sender.selected = !sender.selected;
}

- (IBAction)proSoureTypeAction:(UIButton *)sender {
    
    if (sender != self.selectModelBtn)
    {
        self.selectModelBtn.selected = NO;
        self.selectModelBtn = sender;
        [self.tableView reloadData];
    }
    self.selectModelBtn.selected = YES;
}


#pragma  mark - 更新网络获取的数据

- (void)reloadAllData:(ShopManagerInfoModel *)model
{
    //贸易类型
    if ([model.sellChannel integerValue] ==ShopSaleType_domestic)
    {
//        self.domesticSaleBtn.selected = YES;
        [self saleTypeAction:self.domesticSaleBtn];
    }
    else if ([model.sellChannel integerValue] ==ShopSaleType_export)
    {
        [self saleTypeAction:self.exportSaleBtn];
    }
    else
    {
        self.domesticSaleBtn.selected = YES;
        self.exportSaleBtn.selected = YES;
    }
    //经营模式
    if ([model.mgrType integerValue] ==ShopProSourceType_ownFactory)
    {
        [self proSoureTypeAction:self.ownFactoryBtn];
    }
    else
    {
        [self proSoureTypeAction:self.wholesaleBtn];
    }
    if ([self.yearBtn currentTitle].length ==0)
    {
        if ([[model.mgrPeriod stringValue] isEqualToString:@"11"])
        {
            [self.yearBtn setTitle:@"10+" forState:UIControlStateNormal];
            [self.pickerView selectObject:@"10+" animated:YES];
        }
        else
        {
            [self.yearBtn setTitle:model.mgrPeriod.description forState:UIControlStateNormal];
            [self.pickerView selectObject:[model.mgrPeriod stringValue] animated:YES];
        }
    }
    if (![NSString zhIsBlankString:model.factoryPics])
    {
        NSArray *picsArray = [model.factoryPics componentsSeparatedByString:@","];
        if (picsArray.count>0)
        {
            self.picsCollectionView.hidden = NO;
            [self setupZXPhotoModelArray:picsArray];
            [self.picsCollectionView setData:_photosMArray];
        }
    }
    [self reloadData:model];
    [self.tableView reloadData];
}


- (void)setupZXPhotoModelArray:(NSArray *)aliossModelArray
{
    
    [aliossModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        NSString *picStr = (NSString *)obj;
        NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:picStr];
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:picStr thumbnailUrl:picUrl.absoluteString];
        [_photosMArray addObject:photo];
    }];
}


#pragma  mark - 更新本地数据

- (void)shopInfoChange:(id)notification
{
    ShopManagerInfoModel *model = (ShopManagerInfoModel *)[self.diskManager getData];
    self.managerInfoModel = model;
    [self reloadData:model];
}


- (void)reloadData:(ShopManagerInfoModel *)model
{
    self.shopProLab.text = [NSString zhIsBlankString:model.mainSell]?@"请输入主营产品":model.mainSell;
    self.shopProLab.textColor = [NSString zhIsBlankString:model.mainSell]?UIColorFromRGB_HexValue(0xCCCCCC):UIColorFromRGB_HexValue(0x222222);
    
    self.brandLab.text = [NSString zhIsBlankString:model.mainBrand]?@"请输入经营品牌":model.mainBrand;
    self.brandLab.textColor =[NSString zhIsBlankString:model.mainBrand]?UIColorFromRGB_HexValue(0xCCCCCC):UIColorFromRGB_HexValue(0x222222);

    if (model.sysCates.count>0)
    {
        self.categoryLab.text = [self getSysCatesTitleS];
        self.categoryLab.textColor = UIColorFromRGB_HexValue(0x222222);
    }
    else
    {
        self.categoryLab.text = @"请选择主营类目";
        self.categoryLab.textColor =UIColorFromRGB_HexValue(0xCCCCCC);
    }
}

#pragma mark - 获取类目 id ／title

- (NSString *)getSysCatesIds
{
    NSMutableArray *picIdsMArray = [NSMutableArray array];
    [_managerInfoModel.sysCates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SysCateModel *model = (SysCateModel *)obj;
        [picIdsMArray addObject:model.v];
    }];
    NSString *picIds = [picIdsMArray componentsJoinedByString:@","];
    
    return picIds;
}


- (NSString *)getSysCatesTitleS
{
    NSMutableArray *picIdsMArray = [NSMutableArray array];
    [_managerInfoModel.sysCates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SysCateModel *model = (SysCateModel *)obj;
        [picIdsMArray addObject:model.n];
    }];
    NSString *picIds = [picIdsMArray componentsJoinedByString:@","];

    return picIds;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.selectModelBtn == self.ownFactoryBtn)
    {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1)
    {
        return [self.picsCollectionView getCellHeightWithContentData:_photosMArray];
    }
  
    return LCDScale_iPhone6_Width(45.f);
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return LCDScale_iPhone6_Width(12.f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row ==0)
    {
        WYMainCategoryViewController *vc = [[WYMainCategoryViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section ==1)
    {
        [self picBtnAction: nil];
    }
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - pieckerViewDelegate

- (void)zx_pickerDidDoneStatus:(ZXMPickerView *)picker index:(NSUInteger)index itemTitle:(NSString *)title
{
    [self.yearBtn setTitle:title forState:UIControlStateNormal];
}


- (IBAction)yearBtnChangeAction:(UIButton *)sender {
    
    [self.pickerView showInView:self.tableView];
}


#pragma mark - 保存提交经营信息

- (IBAction)saveBtnAction:(UIButton *)sender {
    
    [self zhHUD_showHUDAddedTo:self.view labelText:@"正在提交"];

    [self uploadManagerInfo];
    
}


- (void)uploadManagerInfo
{
    
    ShopManagerInfoModel *model = (ShopManagerInfoModel *)[self.diskManager getData];
//    主营产品
    NSString *mainSell = model.mainSell;
    if ([NSString zhIsBlankString:mainSell])
    {
        [self zhHUD_showErrorWithStatus:@"请填写主营产品"];
        return;
    }
    //    //品牌
    //    NSString *mainBrand = model.mainBrand;
    //贸易类型
    ShopSaleType shopSaleType= [self getShopSaleType];
    if (shopSaleType ==ShopSaleType_NO)
    {
        [self zhHUD_showErrorWithStatus:@"请选择主要贸易类型"];
        return;
    }
    model.sellChannel = @(shopSaleType);
    //年限
    
    NSString *year = [self.yearBtn currentTitle];
    if (![NSString zhIsBlankString:year])
    {
        if ([year isEqualToString:@"10+"])
        {
            year = @"11";
        }
        model.mgrPeriod = @([year integerValue]);
    }
    //经营模式
    ShopProSourceType  productSource= [self getShopProductSource];
    model.mgrType = @(productSource);
    
    
    NSString *sysCatesIds = [self getSysCatesIds];
    model.sysCatesIds  = sysCatesIds;
    if ([NSString zhIsBlankString:sysCatesIds])
    {
        [self zhHUD_showErrorWithStatus:@"请填写主营类目"];
        return;
    }
    
    
    model.factoryPics = [self manyPicStrFormPicArray:self.photosMArray];
    
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]shopAPI]modifyShopManagerInfoWithParameters:model success:^(id data) {
        
        [_diskManager removeData];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];

}

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
@end
