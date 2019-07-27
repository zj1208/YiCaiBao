//
//  AddProductModel.h
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,ProductEditStatus) {
    
    ProductEditStatus_SoldOut = 0,//下架
    ProductEditStatus_PublicPro = 1,//公开上架
    ProductEditStatus_PrivacyPro = 2,//私密
};


@interface AddProductModel : BaseModel
//图片数组[{"p":"原图url",h:12,w:123}]
@property (nonatomic,strong)NSArray *pics;

//产品名称
@property (nonatomic,copy) NSString *name;
//产品标签,逗号分割-"纯铜","不锈钢","加长","加厚"
@property (nonatomic,copy) NSString *labels;
//规格尺寸，逗号分割-
@property (nonatomic,copy) NSString *spec;
//型号
@property (nonatomic,copy) NSString *model;
//介绍
@property (nonatomic,copy) NSString *desc;


//货源类型－1-现货，2-定制
@property (nonatomic, strong) NSNumber *sourceType;
//起订量-v2.0版本，3.26  开始不用这个字段，用阶梯价格字段；
@property (nonatomic, strong) NSNumber *minQuantity;   //这2个字段类型不一样
//计价单位-3.26开始重新使用；
@property (nonatomic, copy) NSString *priceUnit;
//批发价格-v2.0版本，3.26开始弃用，改用阶梯价格字段；
@property (nonatomic, copy) NSString *price;


//iOS11 不能用小数点的NSNumber，要改为NSString
//箱规-4个参数
//整箱体积，带单位 1.5 m^3
@property (nonatomic, strong) NSNumber *volumn;
//整箱重量
@property (nonatomic, strong) NSNumber *weight;
//装箱数量
@property (nonatomic, strong) NSNumber *number;
//装箱数量的单位
@property (nonatomic, copy) NSString *unitInBox;

//是否设为主营产品
@property (nonatomic, assign) BOOL isMain;

//设置编辑产品的时候，获取是否是主营产品； 用于编辑时候业务处理
@property (nonatomic, assign) BOOL getEditOrinalIsMainPro;
//所属类目id
@property (nonatomic,strong) NSNumber *sysCateId;
//类目名称-用于本地业务处理，不用于json解析
@property (nonatomic, copy) NSString *sysCateName;
//用于更新产品－上传id
@property (nonatomic, strong) NSNumber *productId;

// 商铺分类
@property (nonatomic, copy) NSArray *shopCatgs;

//上架/保存为私密产品-true-上架 false-保存为私密产品,编辑的时候没有
@property (nonatomic, assign) BOOL isOnshelve;
//产品状态 0-下架状态 1-上架状态 2-私密状态，编辑的时候才有
@property (nonatomic, strong) NSNumber *status;

//产品视频
@property (nonatomic, copy) NSString *video;

//价格梯度-“1,-1:10,5:20,4”，如果是面议，则传“1，-1”
@property (nonatomic, copy) NSString *priceGrads;

//运费模板：-1-到付 0-免邮 其他-模板id 2018.4.26
@property (nonatomic, strong) NSNumber *freightId;
//运费模板名
@property (nonatomic, copy) NSString *freightName;

@end

//----------------------------------
//----------设置价格（阶梯价格）--------
//----------------------------------
@interface AddProductSetPriceModel : BaseModel
//起订量
@property (nonatomic, copy) NSString *minimumQuantity;
//该区间价格
@property (nonatomic, copy) NSString *price;
//校验阶梯价格是否合法，若不合法，则该组组尾高度不为0，并展示该文案
@property (nonatomic, copy) NSString *markedWords;
//起订量输入框输入异常、阶梯比较异常，边框，文字红色
@property (nonatomic, assign) BOOL minQuaTextFildRed;
//价格输入框输入异常、阶梯比较异常，边框，文字红色
@property (nonatomic, assign) BOOL priceTextFildRed;

@end



