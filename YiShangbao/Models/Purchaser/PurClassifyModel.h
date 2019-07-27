//
//  PurClassifyModel.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/12/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface ClassifyAdvModel : BaseModel
@property(nonatomic, copy) NSNumber *iid  ;//     N    广告id
@property(nonatomic, copy) NSNumber *areaId  ;//    N    区块id
@property(nonatomic, copy) NSString *pic  ;//  string    N    图片url
@property(nonatomic, copy) NSString *url;//    string    N    跳转地址
@property(nonatomic, copy) NSString *title;//    string    N    标题
@property(nonatomic, copy) NSString *desc;//    string    N    描述
@end

@interface ClassifyHotModel : BaseModel
@property(nonatomic, copy) NSString *sysCateId  ;//  string    N    类目id
@property(nonatomic, copy) NSString *sysCateName ;//   string    N    类目名称
@property(nonatomic, copy) NSString *picUrl  ;//  string    N    类目图片
@property(nonatomic, copy) NSString *hotRef  ;//  string    Y    链接
@end

@interface BanModel : BaseModel
@property(nonatomic, copy) NSString *name  ;
@property(nonatomic, copy) NSArray *ban  ;
@end

@interface RecModel : BaseModel
@property(nonatomic, copy) NSString *name  ;
@property(nonatomic, copy) NSArray *rec  ;
@end

@interface HotModel : BaseModel
@property(nonatomic, copy) NSString *name  ;
@property(nonatomic, copy) NSArray *hot  ;
@end

@interface MarketNavModel : BaseModel
@property(nonatomic, copy) NSString *name  ;
@property(nonatomic, copy) NSString *url  ;
@property(nonatomic, copy) NSArray *marketNav ;
@end

@interface PurClassifyModel : BaseModel
@property(nonatomic, copy) BanModel *banModel;        //banner 广告位
@property(nonatomic, copy) RecModel *recModel;        //专场推荐广告位
@property(nonatomic, copy) HotModel *hotModel;        //热门分类
@property(nonatomic, copy) MarketNavModel *marketNavModel;        //市场导航


@end
