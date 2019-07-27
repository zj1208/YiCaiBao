//
//  QRModel.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"


@interface QRItemsModel : BaseModel
@property(nonatomic, copy) NSString *pic;               //图片
@property(nonatomic, copy) NSString *desc;              //中文内容
@property(nonatomic, copy) NSString *url;               //点击跳转url
@property(nonatomic, copy) NSNumber *iid;               //广告id

@end




@interface TipModel : BaseModel
@property(nonatomic, copy) NSArray *items;               //展示类型
@property(nonatomic, copy) NSNumber *type;              //展现方式
@property(nonatomic, copy) NSNumber *num;               //
@end



@interface QRModel : BaseModel

@property(nonatomic, copy) NSString *shopIcon;              //商铺头像
@property(nonatomic, copy) NSString *shopName;              //商铺名称
//@property(nonatomic, copy) NSArray *serviceIcons;          //重点供应商标识、市场认证标识等，如："http://icon1.png","http://icon2.png"
@property(nonatomic, copy) NSString *address;               //地址
@property(nonatomic, copy) NSString *qrBgPicUrl;            //二维码背景url
@property(nonatomic, copy) NSString *qrCodeUrl;             //二维码url
@property(nonatomic, copy) NSString *shopInfoUrl;           //商铺信息url
@property(nonatomic, strong)NSDictionary *tip;                 //展示类型
@property(nonatomic, strong) NSArray *sellerBadges;

@end
