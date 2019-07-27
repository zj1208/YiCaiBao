//
//  WYAttentionModel.h
//  YiShangbao
//
//  Created by light on 2018/6/6.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface WYAttentionModel : BaseModel

@end

@interface WYSupplierModel : BaseModel

@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, copy) NSString *shopIcon;//商铺头像
@property (nonatomic, copy) NSString *shopName;//商铺名字
@property (nonatomic, copy) NSString *mainSell;//主营
@property (nonatomic) BOOL authStatus;//是否认证
@property (nonatomic, copy) NSString *iconUrl;//认证标识url
@property (nonatomic, strong) NSNumber *width;//认证标识宽度
@property (nonatomic, strong) NSNumber *height;//认证标识高度
@property (nonatomic, copy) NSString *link;//商铺地址


@property (nonatomic) BOOL isAttention;//是否关注 本地
@end

@interface WYAttentionProdutModel : BaseModel

@property (nonatomic, strong) NSNumber *produteId;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *linkUrl;

@end

@interface WYAttentionMessageModel : BaseModel

@property (nonatomic, copy) NSString *shopHeadPicUrl;//商铺头像
@property (nonatomic, copy) NSString *shopName;//商铺名字
@property (nonatomic, strong) NSNumber *followType;//1-上新 2-热销 3-库存
@property (nonatomic, copy) NSString *followTypeName;//上新 热销 库存
@property (nonatomic, copy) NSString *desc;//描述
@property (nonatomic, strong) NSArray *products;//产品图片
@property (nonatomic, copy) NSString *time;//时间
@property (nonatomic, copy) NSString *sellerId;//商家id
@property (nonatomic, copy) NSString *shopId;//商铺id
@property (nonatomic, copy) NSString *shopUrl;//商铺详情url
@property (nonatomic, strong) NSArray *icons;//标识 WYIconModlel
@property (nonatomic) BOOL showFollow;//是否展示关注按钮

@property (nonatomic) BOOL isAttention;//是否关注 本地

@end

@interface WYAttentionADVModel : BaseModel

@property (nonatomic, copy) NSString *advId;
@property (nonatomic, copy) NSString *aderIcon;//头像
@property (nonatomic, copy) NSString *aderInfo;//广告标题
@property (nonatomic, copy) NSString *adPics;//广告图片
@property (nonatomic, copy) NSString *adContentInfo;//广告内容简介
@property (nonatomic, copy) NSString *adUrl;//广告详情url
@property (nonatomic, copy) NSString *mark;//"广告" or "推广"


@end

@interface WYAttentionContentModel : BaseModel

@property (nonatomic, strong) NSNumber *contentType;//1-关注动态 2-精选供应商 3-广告
@property (nonatomic, strong) WYAttentionMessageModel *baseVO;
@property (nonatomic, strong) WYAttentionADVModel *adVO;

@end

@interface WYAttentionsModel : BaseModel

@property (nonatomic, copy) NSString *remark;//当没有动态时备注
@property (nonatomic, copy) NSString *responseId;//响应id
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) PageModel *page;

@end
