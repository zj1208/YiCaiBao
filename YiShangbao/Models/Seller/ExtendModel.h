//
//  ExtendModel.h
//  YiShangbao
//
//  Created by 海狮 on 17/5/18.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface ExtendAlertViewModel : BaseModel
@property(nonatomic, copy)NSString *redirect_url;    //跳转页面url 2017.7.7
@property(nonatomic, copy)NSString *redirect_msg;    //文案 2017.7.7
@property(nonatomic, copy)NSString *redirect_btn2;    //去认证 2017.7.7
@property(nonatomic, copy)NSString *redirect_btn1;    //关闭 2017.7.7
@end

@interface ExtendModel : BaseModel
@property(nonatomic, copy)NSNumber *wordsNum;    //字数限制
@property(nonatomic, copy)NSNumber *cateNum;    //类目个数
@property(nonatomic, copy)NSNumber *cateLevel;    //类目等级1,2
@property(nonatomic, copy)NSNumber *picNum;    //上传照片张数限制

@property(nonatomic, copy)NSString *sysCateIdLast; //上次所选类目id
@property(nonatomic, copy)NSString *sysCateNameLast; //上次所选类目名称

@end

@interface ExtendShopModel : BaseModel
@property(nonatomic, copy)NSString *icon;    //商铺头像
@property(nonatomic, copy)NSString *name;    //商铺名称
@property(nonatomic, copy)NSNumber *EMid;    //商铺id
@property(nonatomic, copy)NSString *addr;    //商铺地址
@property(nonatomic, copy)NSString *qrCode;    //二维码

@end

@interface ExtendSelectProcuctModel : BaseModel
@property(nonatomic, strong)NSNumber *iid; //产品id
@property(nonatomic, copy)NSString *url;  //详情链接
@property(nonatomic, copy)NSString *model; // 
@property(nonatomic, copy)NSString *name;  //
@property(nonatomic, copy)NSString *priceDisp; //展示价格 "面议"
@property(nonatomic, copy)AliOSSPicUploadModel *mainPic; //主图

@end

//发布上传转json用
@interface ExtendUpLoadModel : BaseModel
@property(nonatomic, copy)NSString *p; //原图url
@property(nonatomic, assign)CGFloat h;//原图高度
@property(nonatomic, assign)CGFloat w;//原图宽度
@property(nonatomic, strong)NSNumber *pid;//若为产品，此属性填写产品ID
@end


@interface ExtendOldPicModel : BaseModel
@property(nonatomic, copy)NSNumber *w   ;//   N    string    图片宽度
@property(nonatomic, copy)NSNumber *h   ;//  N    string    高度
@property(nonatomic, copy)NSString *p   ;// N    string    图片url
@property(nonatomic, copy)NSString *pid  ;//  N    string    若为产品，为产品id
@property(nonatomic, copy)NSString *url  ;//  N    string    若为产品，为产品详情url
@end

@interface ExtendOldModel : BaseModel
@property(nonatomic, copy)NSString *intro      ;//  N    string    推广简介
@property(nonatomic, copy)NSString *sysCateId    ;//    N    string    所属系统类目Id
@property(nonatomic, copy)NSString *sysCateName ;//所属系统类目name
@property(nonatomic, copy)NSArray *pics      ;//  N    string    推广图片
@end


