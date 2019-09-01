//
//  CommunicationView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "Communicationview.h"

#import "NTESSessionViewController.h"

@interface CommunicationView ()
@property(nonatomic,strong)NSString* phone;
@property(nonatomic,strong)NSString* bizOrderId;

@property(nonatomic,assign)NIMIDType type;  //即时聊天类型

@end
@implementation CommunicationView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //根据选中状态设置买家／卖家不同图片
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) { //2买家图片 4卖家图片
        
        self.IMBtn.selected = NO;
        self.phoneBtn.selected = NO;
        
        _type = NIMIDType_Seller; //获取对方

    }else{
        self.IMBtn.selected = YES;
        self.phoneBtn.selected = YES;
        
        _type = NIMIDType_Buyer;

    }
}

-(void)setButtonUid:(NSString *)buttonUid buttonCall:(NSString *)buttonCall
{
    NSLog(@"%@",buttonUid);
    _phone = buttonCall;
    _bizOrderId = buttonUid;
}
- (IBAction)IMClick:(UIButton *)sender {
    
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) {
        [MobClick event:kUM_b_ordercontact]; //卖家联系买家
    }else{
        [MobClick event:kUM_c_ordercontact];
    }
    
    self.IMBtn.userInteractionEnabled = NO;
    [[[AppAPIHelper shareInstance]getNimAccountAPI]getChatUserIMInfoWithIDType:_type thisId:_bizOrderId success:^(id data) {
        self.IMBtn.userInteractionEnabled = YES;

        NSString *accid = [data objectForKey:@"accid"];
        NSString *hisUrl = [data objectForKey:@"url"];
        NIMSession *session = [NIMSession session:accid type:NIMSessionTypeP2P];
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        vc.hisUrl = hisUrl;
        NSString *shopUrl = [data objectForKey:@"shopUrl"];
        vc.shopUrl = shopUrl;
        vc.hideUnreadCountView = YES;
        
        UIViewController *curryVC = [self zx_getResponderViewController];
        [curryVC.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        self.IMBtn.userInteractionEnabled = YES;

        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];

    
}
- (IBAction)PhoneClick:(id)sender {
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) {
        [MobClick event:kUM_b_ordercall];
    }else{
        [MobClick event:kUM_c_odercall];
    }
    [self zx_performCallPhone:_phone];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
