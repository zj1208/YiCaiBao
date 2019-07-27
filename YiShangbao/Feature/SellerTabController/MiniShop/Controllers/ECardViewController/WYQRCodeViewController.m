//
//  WYQRCodeViewController.m
//  YiShangbao
//
//  Created by light on 2017/12/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYQRCodeViewController.h"
#import "ZXImgIconsCollectionView.h"
#import "ShopInfoViewController.h"

#import <CoreImage/CoreImage.h>
#import "QRModel.h"
#import "MessageModel.h"
#import "JLMoveTitleButton.h"
#import "CCRightButton.h"

@interface WYCircleFrame : NSObject

@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float redius;

@end

@implementation WYCircleFrame

@end

@interface WYQRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *headBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeBackImageView;

@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;

@property (weak, nonatomic) IBOutlet JLMoveTitleButton *topAdvButton;

@property (weak, nonatomic) IBOutlet UIButton *showCardButton;
@property (weak, nonatomic) IBOutlet UIView *saveQRCodeView;//按钮背景渐变
@property (weak, nonatomic) IBOutlet UIButton *saveQRCodeButton;

@property (weak, nonatomic) IBOutlet UIView *certificationIconsView;
@property (weak, nonatomic) IBOutlet UIView *QRCodeView;
@property (nonatomic, strong) ZXImgIconsCollectionView * iconsView;//认证图标控件
@property (nonatomic, strong) QRModel *model;

@property (nonatomic, strong) NSArray *pics;
@property (nonatomic) NSInteger index;

@end

@implementation WYQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商铺二维码";
    [self changeBackgroundRequest];
    [self setUI];
    [self requsetData];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.topAdvButton pauseJLMoveTitleButtonTimer];
}

#pragma mark- ButtonAction

- (IBAction)topAdvButtonAction:(id)sender {
    
    TipModel *tipModel = (TipModel *)self.model.tip;
    QRItemsModel *itemModel = tipModel.items[0];
    NSString *linkUrl = itemModel.url;
    NSString *linkiid = [NSString stringWithFormat:@"%@",itemModel.iid];
    if (linkUrl.length) {
        [self requestClickAdvWithAreaId:@1003 advId:linkiid];
        [self goHtmlWithUrl:linkUrl];
    }
}

- (IBAction)editCardButtonAction:(id)sender {
    [MobClick event:kUM_b_editcard];
    
    [self xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_ShopInfoViewController withData:nil];
}

- (IBAction)changeBackgroundAction:(id)sender {
    [MobClick event:kUM_b_home_changecode];
    if (self.pics.count <= 1) {
        [MBProgressHUD zx_showError:@"哎呀，没有图片可以换诶，换个时间再来试试吧～" toView:self.view];
        return;
    }
    self.index ++ ;
    self.index = self.index % self.pics.count;
    [self downloadQRCodeBackgroundView];
}


- (IBAction)showCardButtonAction:(id)sender {
    [MobClick event:kUM_b_viewcard];
    
    NSString *shopUrl = [self.model.shopInfoUrl stringByReplacingOccurrencesOfString:@"{shopId}" withString:[UserInfoUDManager getShopId]];
    shopUrl = [shopUrl stringByReplacingOccurrencesOfString:@"{token}" withString:[UserInfoUDManager getToken]];
    shopUrl = [shopUrl stringByReplacingOccurrencesOfString:@"{ttid}" withString:@"1.0.0_ysb@iphone"];
    [self goHtmlWithUrl:shopUrl];
}

- (IBAction)saveQRCodeButtonAction:(id)sender {
    [MobClick event:kUM_b_qrcodesave];
    
    UIImage *image = [self imageFromView:self.QRCodeView atFrame:CGRectMake(0, 0, SCREEN_WIDTH - 108, (SCREEN_WIDTH - 108 ) / 267 * 395)];
    [self saveImageToPhotos:image];
}

- (void)shareButtonAction{
    [MobClick event:kUM_b_qrcodeshare];
    
    //分享
    [self zhHUD_showWithStatus:nil];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI] getShareWithType:@22 success:^(id data) {
        
        [weakSelf zhHUD_hideHUD];
        
        shareModel *model = data;
        NSString *titleStr = [model.title stringByReplacingOccurrencesOfString:@"{shopName}" withString:self.model.shopName];
        NSString *shopUrl = [model.link stringByReplacingOccurrencesOfString:@"{id}" withString:[UserInfoUDManager getShopId]];
        shopUrl = [shopUrl stringByReplacingOccurrencesOfString:@"{os}" withString:@"ios"];
        //1、创建分享参数 model.pic
        [WYShareManager shareInVC:weakSelf withImage:self.model.shopIcon withTitle:titleStr withContent:model.content withUrl:shopUrl];
    } failure:^(NSError *error) {
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark- Request


- (void)requsetData{
    
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] creatQRAPI] getQRCodeWithsuccess:^(id data) {
        weakSelf.model = data;
        [weakSelf updataUI];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

//二维码背景
- (void)changeBackgroundRequest{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMessageAPI] GetFenLeiAdvWithType:@1013 sysCatesId:nil success:^(id data) {
        weakSelf.pics = data;
//        [weakSelf showLoaclImage];
        [weakSelf downloadQRCodeBackgroundView];
    } failure:^(NSError *error) {
        
    }];
}

//后台广告点击统计
- (void)requestClickAdvWithAreaId:(NSNumber*)areaId advId:(NSString*)advId{
    [[[AppAPIHelper shareInstance] getMessageAPI] postAddTrackInfoWithAreaId:areaId advId:advId success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark- 截图保存二维码

//保存当前界面的图片(截图)
- (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)frame{
    
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO, 0.0);//原图
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(frame);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}

//保存图片,里面方法是成功保存或者失败回调
- (void)saveImageToPhotos:(UIImage *)image {
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}
//回调方法(成功或者失败),在这里可以出现个动画之类的
-  (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [self zhHUD_showSuccessWithStatus:@"保存成功"];
    } else {
        [self zhHUD_showErrorWithStatus:@"保存失败"];
    }
}

#pragma mark- Private

- (void)setUI{
    
    CCRightButton *shareButton = [[CCRightButton alloc]initWithFrame:CGRectMake(0, 0, 52, 22)];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    [self.certificationIconsView addSubview:iconsView];
    self.certificationIconsView.backgroundColor = [UIColor clearColor];
    [self.iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.certificationIconsView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];
    
    self.headBackgroundView.layer.cornerRadius = (SCREEN_WIDTH - 108) / 267 * 35.0;
    self.headBackgroundView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = (SCREEN_WIDTH - 108) / 267 * 35.0 - 5.0;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.QRCodeImageView.layer.cornerRadius = 5.0;
    self.QRCodeImageView.layer.masksToBounds = YES;
    
    self.showCardButton.layer.borderColor = [UIColor colorWithHex:0xE23728].CGColor;
    [self.showCardButton setTitleColor:[UIColor colorWithHex:0xE23728] forState:UIControlStateNormal];
    self.showCardButton.layer.borderWidth = 0.5;
    self.showCardButton.layer.cornerRadius = 22.5;
    self.showCardButton.layer.masksToBounds = YES;
    
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1, 0);
    gradientLayer2.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 50)/265*375 , 45);
    gradientLayer2.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xE23728].CGColor,(id)[UIColor colorWithHex:0xCF2218].CGColor, nil];
    
    [self.saveQRCodeView.layer insertSublayer:gradientLayer2 atIndex:0];
    self.saveQRCodeView.layer.cornerRadius = 22.5;
    self.saveQRCodeView.layer.masksToBounds = YES;
    
    [self drawBackgroundView];
    
    [self showLoaclImage];
}

//根据请求数据，刷新页面
- (void)updataUI{
//    [self.headImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:self.model.shopIcon] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.shopIcon]];
    [self.QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:self.model.qrCodeUrl] placeholderImage:nil];
    
//    [self.QRCodeBackImageView sd_setImageWithURL:[NSURL URLWithString:self.model.qrBgPicUrl] placeholderImage:[UIImage imageNamed:@"QRCode_bg"]];
    self.shopNameLabel.text = self.model.shopName;
    
    TipModel *tipModel = (TipModel *)self.model.tip;
    if (tipModel.items.count) {
        self.topAdvButton.hidden = NO;
        QRItemsModel *itemModel = tipModel.items[0];
//        [self.topAdvButton setTitle:itemModel.desc forState:UIControlStateNormal];
        self.topAdvButton.moveString = itemModel.desc;
        self.topAdvButton.labelColor = [UIColor colorWithHex:0xE23728];
        [self.topAdvButton resumeJLMoveTitleButtonTimerAfterDuration:0];
    }else{
        self.topAdvButton.hidden = YES;
    }
    
    NSMutableArray *imgIcons = [NSMutableArray array];
    [self.model.sellerBadges enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
}

- (void)goHtmlWithUrl:(NSString *)url{
    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
}

#pragma mark- 绘制背景

- (NSMutableArray *)randomCircleData{
    NSMutableArray * array = [NSMutableArray array];
    //54为左右空的边距
    for (int i = 0; i < 20; i++) {
        int redius = arc4random() % 6 + 6;
        double x = arc4random() % (54 - redius * 2);
        if (i % 2) {
            x += SCREEN_WIDTH - 54;
        }
        int y = arc4random() % ((int)SCREEN_HEIGHT - 130) + 30;
        
        WYCircleFrame *circle = [[WYCircleFrame alloc]init];
        circle.x = x;
        circle.y = y;
        circle.redius = redius;
        
        BOOL isOverlay = NO;
        for (WYCircleFrame *model in array) {
            float distanceX = fabsf(circle.x + circle.redius - model.x - model.redius);
            float distanceY = fabsf(circle.y + circle.redius - model.y - model.redius);
            float distance = circle.redius + model.redius;
            if (sqrt(distanceX * distanceX + distanceY * distanceY) < 2 * distance) {
                isOverlay = YES;
                break;
            }
        }
        if (!isOverlay) {
            [array addObject:circle];
        }
        if (array.count == 10) {
            break;
        }
    }
    return array;
}

- (void)drawBackgroundView{
    NSArray *circleArray = [self randomCircleData];
    
    NSArray * colorArray = @[@"0x45A4E8",@"0xE6F7CD",@"0xE6F7CD",@"0xFFEFD6",@"0xFFCFCF"];
    for (WYCircleFrame *model in circleArray) {
        CALayer *sublayer =[CALayer layer];
        int random = arc4random() % 5;
        sublayer.backgroundColor =[UIColor colorWithHexString:colorArray[random] alpha:0.6].CGColor;
        sublayer.frame = CGRectMake(model.x, model.y, model.redius * 2, model.redius * 2);
        sublayer.cornerRadius = model.redius;
        [self.backgroundView.layer addSublayer:sublayer];
        
    }
}


#pragma mark - 保存二维码背景

- (void)downloadQRCodeBackgroundView{
    if (self.index >= self.pics.count) {
        return;
    }
    FenLeiLunboAdvModel *model = self.pics[self.index];
    WS(weakSelf)
    if (model.pic) {
        SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
        NSURL *url =  [NSURL URLWithString:model.pic];
        [sdManager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            if (image) {
                [weakSelf saveQRCodeBackgroundImage:image];
                [weakSelf.QRCodeBackImageView setImage:image];
            }
        }];
    }
}

- (void)saveQRCodeBackgroundImage:(UIImage *)image{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"QRCodeBackgroundImage"];
    BOOL success = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageFilePath  atomically:YES];
    if (success){
//        [MBProgressHUD zx_showSuccess:@"保存成功" toView:self.view];
    }else{
//        [MBProgressHUD zx_showError:@"保存失败" toView:self.view];
    }
}

- (void)showLoaclImage{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"QRCodeBackgroundImage"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:imageFilePath];
    if (savedImage) {
        [self.QRCodeBackImageView setImage:savedImage];
    }else {
        [self downloadQRCodeBackgroundView];
    }
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
