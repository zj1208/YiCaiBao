//
//  TradeOrderingController.m
//  YiShangbao
//
//  Created by simon on 17/1/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeOrderingController.h"
#import "ZXTitleView.h"
#import "TradePersonalInfoCell.h"
#import "TradeOrderContentCell.h"
#import "TradeOrderNoPhotoCell.h"

#import "ZXCenterBottomToolView.h"
#import "TZImagePickerController.h"
#import "XLPhotoBrowser.h"
#import "TradeOrderSuccessViewController.h"
#import "AliOSSUploadManager.h"
#import "IQKeyboardManager.h"
#import "ZXKeyboardManager.h"

@interface TradeOrderingController ()<UITextFieldDelegate,ZXAddPicCollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,TZImagePickerControllerDelegate,XLPhotoBrowserDatasource>

@property (nonatomic, strong)TradeOrderContentCell *contentCell;

@property (nonatomic, strong)NSMutableArray *mImages;
@property(nonatomic,assign)BOOL isChangeImages ;//判断图片上传成功后，发送失败，图片无变动将不再重复上传

@property (nonatomic, strong)NSMutableArray *photosMArray;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, assign) CGRect activedTextFieldRect;

@end

static NSString *const reuse_personalCell = @"personalCell";
static NSString *const reuse_photoCell = @"photoCell";


@implementation TradeOrderingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];

    [self setData];
    
//    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


- (void)setUI
{
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.backgroundColor = self.view.backgroundColor;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 125.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self addBottomView];
    
    ZXKeyboardManager *keyboardManager = [ZXKeyboardManager sharedInstance];
    keyboardManager.superView = self.tableView;
    
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = 60.f;
    self.tableView.contentInset = inset;
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0.f, 60.f, 0.f);
}

- (void)setData
{
    self.mImages = [NSMutableArray array];
    NSMutableArray *photos = [NSMutableArray array];
    self.photosMArray = photos;
    
    //初始化oss上传
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
    [AliOSSUploadManager sharedInstance].getPicInfo = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [[IQKeyboardManager sharedManager]setEnable:NO] ;
    [[ZXKeyboardManager sharedInstance]registerForKeyboardNotifications];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [IQKeyboardManager sharedManager].enable = YES;
    [[ZXKeyboardManager sharedInstance]removeObserverForKeyboardNotifications];
}


- (void)addBottomView
{
    
    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];

    ZXCenterBottomToolView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXCenterBottomToolView owner:self options:nil] lastObject];
    view.backgroundColor = [UIColor clearColor];
    [self.bottomContainerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(_bottomContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    view.centerBtnLeadingLayout.constant = LCDScale_5Equal6_To6plus(15.f);
    view.centerBtnTopLayout.constant = LCDScale_5Equal6_To6plus(8.f);
    //单独打电话按钮
    UIImage *backgroundImage2 = [WYUTILITY getCommonVersion2RedGradientImageWithSize:view.onlyCenterBtn.frame.size];
    [view.onlyCenterBtn setBackgroundImage:backgroundImage2 forState:UIControlStateNormal];
    [view.onlyCenterBtn setTitle:NSLocalizedString(@"发送给采购商", nil)  forState:UIControlStateNormal];
    [view.onlyCenterBtn addTarget:self action:@selector(postDataAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc
{
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModel?1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        TradePersonalInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse_personalCell forIndexPath:indexPath];
        if (self.dataModel)
        {
            [cell setData:self.dataModel];
        }
        return cell;
    }
   else if (indexPath.section ==1)
    {
        TradeOrderContentCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"contentCell" forIndexPath:indexPath];
        self.contentCell = cell2;
        cell2.foreignDescLabel.hidden = self.dataModel.tradeType == WYTradeType_foreignDirect?NO:YES;
        
        return cell2;
    }
    TradeOrderNoPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:reuse_photoCell forIndexPath:indexPath];
    photoCell.picsCollectionView.delegate = self;
    [photoCell.picBtn addTarget:self action:@selector(picBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [photoCell setData:self.mImages];
    return photoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return tableView.rowHeight;
    }
    else if (indexPath.section ==1)
    {
        CGFloat height = LCDScale_5Equal6_To6plus(5.f+140.f+0.f+45.f*3);
        return height;
    }
    else if (indexPath.section ==2)
    {
        static TradeOrderNoPhotoCell *cell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cell = (TradeOrderNoPhotoCell*)[tableView dequeueReusableCellWithIdentifier:reuse_photoCell];
        });
        CGFloat height = [cell.picsCollectionView getCellHeightWithContentData:self.mImages];
        return height;
    }
    return  45.f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0 ||section ==1)
    {
        return 0;
    }
    return LCDScale_5Equal6_To6plus(35.f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section ==2)
    {
        ZXCenterTitleView * view = [[[NSBundle mainBundle] loadNibNamed:@"ZXCenterTitleView" owner:self options:nil] firstObject];
        [view.centerBtn setTitle:@"上传照片" forState:UIControlStateNormal];
        [view.centerBtn setImage:[UIImage imageNamed:@"pic_shanghcuanzhaopian"] forState:UIControlStateNormal];
        view.centerBtnWidthLayout.constant = 80.f;
        [view.centerBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
        view.centerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;

    }
    return [[UIView alloc] init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.f;
}

- (void)picBtnAction:(id)sender
{
    //初始化选择照片
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:(9-self.mImages.count) delegate:self];
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


#pragma mark - ZXAddPicCollectionViewDelegate

- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == ZXAddPicCellEditingStyleInsert)
    {
        [self picBtnAction:nil];
    }
    else
    {
        [self.mImages removeObjectAtIndex:indexPath.item];
        if (addPicCollectionView.isChangeDeleteContentHeight)
        {
            [self.tableView reloadData];
        }
    }

}


- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray
{
    
    //大图浏览
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:picsArray.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
  
//    self.isChangeImages = YES;
    [self.mImages addObjectsFromArray:photos];
//    [self.tableView beginUpdates];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
    [self.tableView reloadData];
}

#pragma mark    - XLPhotoBrowserDatasource
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.mImages[index];
}


//- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr
//{
//    
//}
/*
#pragma mark - ImagePickerControllerDelegate
//代理
- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
    self.photoCell.picBtn.hidden =YES;
    self.photoCell.label.hidden = self.photoCell.picBtn.hidden;
    self.photoCell.pyPhotosView.hidden = !self.photoCell.picBtn.hidden;
    [self.mImages addObject:image];
    [self.photoCell.pyPhotosView reloadDataWithImages:_mImages];
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

- (void)postDataAction:(UIButton *)sender {
    
    if (self.contentCell.textView.text.length<5)
    {
        [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:NSLocalizedString(@"老板，生意回复不能少于5个字哦～", nil) message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:NSLocalizedString(@"知道了", nil) doHandler:nil];
        return;
    }
    
    WYPromptGoodsType goodsType = [self.contentCell getGoodsPromptType];
    if (goodsType ==WYPromptGoodsType_NOSelect)
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请选择是否现货", nil) toView:self.view];
        return;
    }
    
//    NSString * price = [self.contentCell getSelectedTradePrice];
//    if ([NSString zhIsBlankString:price])
//    {
//        [MBProgressHUD zx_showError:NSLocalizedString(@"请输入产品单价", nil) toView:self.view];
//        return;
//    }
    [MBProgressHUD zx_showLoadingWithStatus:NSLocalizedString(@"正在提交", nil) toView:self.view];
    if (self.mImages.count>0)
    {
        __block NSInteger currentIndex = 0;
        //清空数据
        [_photosMArray removeAllObjects];

        WS(weakSelf);
        [self.mImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImage *image = (UIImage *)obj;
            NSData *imageData = [WYUtility zipNSDataWithImage:image];
            
            [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_tradeReply uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                
            } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
                
                currentIndex ++;
                //这里处理上传图片
                AliOSSPicUploadModel *model = [[AliOSSPicUploadModel alloc] init];
                model.p = imagePath;
                model.w = imageSize.width;
                model.h = imageSize.height;
                
                [weakSelf.photosMArray addObject:model];
                if (currentIndex ==weakSelf.mImages.count)
                {
                    [weakSelf performSelector:@selector(uploadData)];
                }
                
                
            } failure:^(NSError *error) {

                [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
            }];
        }];
    }
    else
    {
         [self performSelector:@selector(uploadData)];
    }
    
}

- (void)uploadData2
{
    [MBProgressHUD zx_hideHUDForView:self.view];
    [self performSelector:@selector(popToMainListController) withObject:nil afterDelay:2.f];
    return;
}

- (void)uploadData
{
    NSString * price = [self.contentCell getSelectedTradePrice];
   
    WYPromptGoodsType  goodsType = [self.contentCell getGoodsPromptType];
    NSString *replyText = self.contentCell.textView.text;
    NSString *minCount = self.contentCell.orderCountField.text;
    
    
    NSArray *picArray = [MTLJSONAdapter JSONArrayFromModels:self.photosMArray error:nil];
    
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getTradeMainAPI]postOrderWithPostId:self.dataModel.postId replyContent:replyText promptGoodsType:goodsType price:price minCount:minCount photos:picArray success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        [MobClick event:kUM_sendPrice];
        [weakSelf orderSuccess];
        
    } failure:^(NSError *error) {

        NSString *code = [error.userInfo objectForKey:@"code"];
        //  subject_completed 求购已完成
        if ([code isEqualToString:@"subject_completed"])
        {
            [weakSelf performSelector:@selector(popToMainListController) withObject:nil afterDelay:2.f];
            [MBProgressHUD zx_showError:NSLocalizedString(@"手慢啦，去看看别的生意吧！", nil) toView:weakSelf.view];
        }
        //  已报价
        else if ([code isEqualToString:@"bid_exsits"])
        {
            [weakSelf performSelector:@selector(popToMainListController) withObject:nil afterDelay:2.f];
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }
        else
        {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }
    }];


}

- (void)popToMainListController
{
    //  返回的时候，告诉已经被接单，重复接单
    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Trade_subjectCompleted object:nil userInfo:@{@"tradeId":self.dataModel.postId}];
    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
}

- (void)orderSuccess
{
    //
    [self performSegueWithIdentifier:segue_TradeOrderSuccessViewController sender:self];

    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Trade_haveReceivedTrade object:nil userInfo:@{@"tradeId":self.dataModel.postId}];

}

/*
#define MAXLENGTH 16 //(起订量)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>= MAXLENGTH) //输入文字/删除文字后,但还没有改变textField时候的改变;
    {
        textField.text = [textField.text substringToIndex:MAXLENGTH];
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor colorWithHexString:@"#FFA6A6"].CGColor;
    textField.textColor = [UIColor colorWithHexString:@"#EC1E11"];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([NSString zhIsBlankString: textField.text]) {
        textField.layer.borderColor = [UIColor colorWithHexString:@"#E8E8E8"].CGColor;
        textField.textColor = [UIColor colorWithHexString:@"#2F2F2F"];
    }else{
        textField.layer.borderColor = [UIColor colorWithHexString:@"#FFA6A6"].CGColor;
        textField.textColor = [UIColor colorWithHexString:@"#EC1E11"];
    }
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *viewController= segue.destinationViewController;
    
    NSString* telString =  self.dataModel.phoneNum;
    NSString *tradeId =  self.dataModel.postId;
    if ([segue.identifier isEqualToString:segue_TradeOrderSuccessViewController])
    {
        [viewController setValue:telString forKey:@"telString"];
        [viewController setValue:tradeId forKey:@"tradeId"];

        BOOL isForeign = self.dataModel.tradeType == WYTradeType_foreignDirect?YES:NO;
        [viewController setValue:@(isForeign) forKey:@"isForeign"];
        if (![NSString zhIsBlankString:self.dataModel.email]) {
            [viewController setValue:self.dataModel.email forKey:@"email"];
        }
        if (![NSString zhIsBlankString:self.dataModel.mobile]) {
            [viewController setValue:self.dataModel.mobile forKey:@"mobile"];
        }
    }
    
}
@end
