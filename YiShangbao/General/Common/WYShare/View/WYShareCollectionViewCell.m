//
//  WYShareCollectionViewCell.m
//  YiShangbao
//
//  Created by light on 2018/4/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYShareCollectionViewCell.h"
#import "WYShareViewController.h"

NSString *const WYShareCollectionViewCellID = @"WYShareCollectionViewCellID";

@interface WYShareCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;


@end

@implementation WYShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updaDataShareType:(WYShareType)shareType{
//    WYShareTypeHotProduct           = (1 << 0),//热销产品
//    WYShareTypeStock                = (1 << 1),//库存收购
//    WYShareTypeCopyLink             = (1 << 2),//复制链接
//    WYShareTypeCustomers            = (1 << 3),//义采宝客户
//    WYShareTypeWechatSession        = (1 << 4),//微信好友
//    WYShareTypeWechatCircle         = (1 << 5),//朋友圈
//    WYShareTypeQQ                   = (1 << 6),//QQ
//    WYShareTypeQQZone               = (1 << 7),//QQ空间
    switch (shareType) {
        case WYShareTypeHotProduct:
        {
            [self.imageView setImage:[UIImage imageNamed:@"ic_share_rexiao"]];
            self.title.text = @"热销产品";
        }
            break;
        case WYShareTypeStock:
        {
            [self.imageView setImage:[UIImage imageNamed:@"ic_share_kucun"]];
            self.title.text = @"库存收购";
        }
            break;
        case WYShareTypeCopyLink:
        {
            [self.imageView setImage:[UIImage imageNamed:@"ic_share_lianjie"]];
            self.title.text = @"复制链接";
        }
            break;
        case WYShareTypeCustomers:
        {
            [self.imageView setImage:[UIImage imageNamed:@"ic_share_kehu"]];
            self.title.text = @"义采宝客户";
        }
            break;
        case WYShareTypeWechatSession:
        {
            [self.imageView setImage:[UIImage imageNamed:@"ic_share_weixin"]];
            self.title.text = @"微信好友";
        }
            break;
        case WYShareTypeWechatCircle:
        {
            [self.imageView setImage:[UIImage imageNamed:@"ic_share_pengyouquan"]];
            self.title.text = @"朋友圈";
        }
            break;
        case WYShareTypeQQ:
        {
            [self.imageView setImage:[UIImage imageNamed:@"ic_share_QQ"]];
            self.title.text = @"QQ";
        }
            break;
        case WYShareTypeQQZone:
        {
            [self.imageView setImage:[UIImage imageNamed:@"ic_share_QQzone"]];
            self.title.text = @"QQ空间";
        }
            break;
            
        default:
        {
            [self.imageView setImage:[UIImage imageNamed:@"ic_share_kehu"]];
            self.title.text = @"分享";
        }
            break;
    }
}

@end
