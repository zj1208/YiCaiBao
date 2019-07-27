//
//  TradeOrderSuccessViewController.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeOrderSuccessViewController.h"

#import "WYNIMAccoutManager.h"
#import "NTESSessionViewController.h"

#import "WYAlertViewController.h"
#import "TradeDetailForeignInfoController.h"

@interface TradeOrderSuccessViewController ()

@property (nonatomic, strong) advArrModel *advItemModel;

@end

@implementation TradeOrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"接单成功", nil);


    [self setUIstyle];
    
    [self setData];
    [self requestAdv];
    [self requestAdv2];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)setData
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getTradeMainAPI]getRemainOrderingTimesWithSuccess:^(id data) {
        
        //没有认证，接完单之后剩余次数为0的时候提示：“您本月还剩下0次接生意权益，认证后可无限接单”
        NSDictionary *redirect = [data objectForKey:@"redirect"];
        if (redirect)
        {
            //“您本月还剩下0次接生意权益，认证后可无限接单”
            NSString *title = [redirect objectForKey:@"msg"];
            //去认证-跳转h5认证页面
            NSString *btn1 = [redirect objectForKey:@"btn1"];
            //放弃
            NSString *btn2 = [redirect objectForKey:@"btn2"];
            NSString *url = [redirect objectForKey:@"url"];
            
            [UIAlertController zx_presentGeneralAlertInViewController:weakSelf withTitle:title message:nil cancelButtonTitle:btn2 cancleHandler:nil doButtonTitle:btn1 doHandler:^(UIAlertAction * _Nonnull action) {
                
                [[WYUtility dataUtil]routerWithName:url withSoureController:weakSelf];
            }];
        }

    } failure:^(NSError *error) {
        
        
    }];
}
-(void)setUIstyle
{
    self.callPhonebtn.backgroundColor = [UIColor whiteColor];
    self.callPhonebtn.layer.masksToBounds = YES;
    self.callPhonebtn.layer.borderWidth = 0.5f;
    self.callPhonebtn.layer.borderColor = [[WYUIStyle style] colorWithHexString:@"FD7953"].CGColor;
    
    
    UIImage* backimage = [WYUISTYLE imageWithStartColorHexString:@"FD7953" EndColorHexString:@"FE5247" WithSize:self.messagebtn.frame.size];
    self.messagebtn.layer.masksToBounds = YES;
    [self.messagebtn setBackgroundImage:backimage forState:UIControlStateNormal];
    
    
    self.callPhonebtn.adjustsImageWhenHighlighted = NO;
    self.messagebtn.adjustsImageWhenHighlighted = NO;
    
    if (self.isForeign){
        [self.callPhonebtn setImage:nil forState:UIControlStateNormal];
        [self.callPhonebtn setTitle:NSLocalizedString(@"联系方式", nil) forState:UIControlStateNormal ];
    }
    self.miaoshuLabel.font = [UIFont systemFontOfSize:LCDW/375.f*15];

}


- (void)requestAdv
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1020 rnd:@(1)  success:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        AdvModel *model = (AdvModel *)data;
        advArrModel *advItemModel = [model.advArr firstObject];
        weakSelf.miaoshuLabel.text = advItemModel.desc;

    } failure:^(NSError *error) {
        
        [weakSelf.promptImgView removeFromSuperview];
        [weakSelf.promptTitleLab removeFromSuperview];
        [weakSelf.miaoshuLabel removeFromSuperview];
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];

    }];
}

- (void)requestAdv2
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@10201 success:^(id data) {
        
        AdvModel *model = (AdvModel *)data;
        advArrModel *advItemModel = [model.advArr firstObject];
        if (advItemModel)
        {
            [weakSelf.advImgView sd_setImageWithURL:[NSURL URLWithString:advItemModel.pic] placeholderImage:AppPlaceholderImage];
            weakSelf.advItemModel = advItemModel;
        }
        else
        {
            weakSelf.advImgView.hidden = YES;
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.callPhonebtn.layer.cornerRadius = self.callPhonebtn.frame.size.height/2;
    self.messagebtn.layer.cornerRadius = self.messagebtn.frame.size.height/2;
    
}
#pragma mark - 打电话
- (IBAction)callPhone:(id)sender {
    
    [MobClick event:kUM_b_businesscall];
    
    if (self.isForeign)
    { //外商
        if ([NSString zhIsBlankString:self.mobile]&&[NSString zhIsBlankString:self.email]) {
            [WYAlertViewController presentedBy:self message:@"这个采购商没有留下联系方式噢～可以尝试与他进行在线沟通。" bottonBtnTitle:@"知道了" bottonBtnBlock:nil];
        }else{
            [TradeDetailForeignInfoController presentBy:self email:self.email mobile:self.mobile];
        }
    }
    else
    {
        if (self.telString) {
            [MobClick event:kUM_b_businesscall];
            [self.view zx_performCallPhone:self.telString];
        }else{
            [MBProgressHUD zx_showError:@"电话号码获取失败" toView:self.view];
        }
    }
}
#pragma mark - 发消息
- (IBAction)clickMessage:(id)sender {
    if ([[WYNIMAccoutManager shareInstance]cheackAccoutEnable:self])
    {
        self.messagebtn.enabled = NO;
        WS(weakSelf);
        [[[AppAPIHelper shareInstance] getNimAccountAPI] getChatUserIMInfoWithIDType:NIMIDType_Trade thisId:self.tradeId success:^(id data) {
            weakSelf.messagebtn.enabled = YES;

            [MobClick event:kUM_b_businessIM];

            NSString *accid = [data objectForKey:@"accid"];
            NSString *hisUrl = [data objectForKey:@"url"];
            NIMSession *session = [NIMSession session:accid type:NIMSessionTypeP2P];
            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
            vc.hisUrl = hisUrl;
            vc.hideUnreadCountView = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            weakSelf.messagebtn.enabled = YES;

            [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
        
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

- (IBAction)tapAdvImgViewAction:(UITapGestureRecognizer *)sender {
    
    if (self.advItemModel)
    {
        [self requestClickAdvWithAreaId:@10201 advId:[NSString stringWithFormat:@"%@",self.advItemModel.iid]];
        //    [MobClick event:kUM_b_home_banner];
        
        [[WYUtility dataUtil]routerWithName:self.advItemModel.url withSoureController:self];
    }
}

#pragma mark － 后台广告点击统计
-(void)requestClickAdvWithAreaId:(NSNumber*)areaId advId:(NSString*)advId
{
    [[[AppAPIHelper shareInstance] getMessageAPI] postAddTrackInfoWithAreaId:areaId advId:advId success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
