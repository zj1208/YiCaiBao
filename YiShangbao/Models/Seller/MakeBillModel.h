//
//  MakeBillModel.h
//  YiShangbao
//
//  Created by light on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface MakeBillModel : BaseModel

@end
//单据里商品
@interface MakeBillGoodsModel : BaseModel

@property (nonatomic, strong) NSNumber *goodsId;
@property (nonatomic, copy) NSString *goodsNo;//货号
@property (nonatomic, copy) NSString *goodsName;//品名
@property (nonatomic, copy) NSString *totalNumStr;//总数量
@property (nonatomic, strong) NSNumber *boxNum;//箱数
@property (nonatomic, strong) NSNumber *boxPerNum;//每箱数量
@property (nonatomic, copy) NSString *boxNumStr;//箱数字符串类型
@property (nonatomic, copy) NSString *boxPerNumStr;//每箱数量字符串类型
@property (nonatomic, copy) NSString *minUnit;//每箱数量单位
@property (nonatomic, copy) NSString *minPriceDisplay;//单价
@property (nonatomic, copy) NSString *boxSize;//箱子尺寸

@end

//单据信息
@interface MakeBillInfoModel : BaseModel

@property (nonatomic, strong) NSNumber *BillId;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *billTime;//开单时间
@property (nonatomic, copy) NSString *deliveryTime;//交货时间
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *billNo;//订单号
@property (nonatomic, copy) NSString *planCollectTime;//计划收款时间
@property (nonatomic, copy) NSString *totalOrderStr;//单据金额
@property (nonatomic, copy) NSString *payStatus;//支付状态
@property (nonatomic, copy) NSString *deliveryAddress;//送货地址

@end

@interface MakeBillPicModel : BaseModel

@property (nonatomic, strong) NSNumber *picId;
@property (nonatomic, copy) NSString *picUrl;//图片url

@end
//单据分享
@interface MakeBillShareModel : BaseModel
@property (nonatomic, copy) NSString *title  ;// N    string    分享标题
@property (nonatomic, copy) NSString *content ;//   N    string    分享描述
@property (nonatomic, copy) NSString *pic ;//   N    string    icon
@property (nonatomic, copy) NSString *link ;//   
@end

//上传保存单据信息
@interface MakeBillUploadModel : BaseModel

@property (nonatomic, strong) MakeBillInfoModel *billSale;
@property (nonatomic, strong) NSMutableArray *billGoods;//商品列表
@property (nonatomic, strong) NSMutableArray *billPics;//图片列表

@end

@interface MakeBillHeadTipModel : BaseModel

@property (nonatomic) BOOL show;
@property (nonatomic, copy) NSString *contentLeft;
@property (nonatomic, copy) NSString *contentRight;

@end

@interface MakeBillHomeInfoModel : BaseModel

@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *customerName;//客户名称
@property (nonatomic, copy) NSString *totalNum;
@property (nonatomic, copy) NSString *totalMoney;
@property (nonatomic, copy) NSString *billTime;//开单时间
@property (nonatomic, copy) NSString *payStatus;//收款状态

@end

@interface MakeBillHomeModel : BaseModel

@property (nonatomic, strong) MakeBillHeadTipModel *remark;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) PageModel *page;

@end

//条款展示初始化
@interface MBDisplayClauseModel : BaseModel
@property (nonatomic, assign) BOOL display   ;// Y    boolean    是否展示 true-展示 false-不展示
@property (nonatomic, copy) NSString *content  ;//  Y    string    自定义条例内容
@property (nonatomic, copy) NSString *bankCard ;//银行卡号
@end

#pragma mark - 数据

//数据首页-销售额数据
@interface BillDataSaleAmountModelSub : BaseModel
//日期 10.2
@property (nonatomic, copy) NSString *date1;
@property (nonatomic, copy) NSString *date2;
//销售额
@property (nonatomic, copy) NSString *totalFee;


@property (nonatomic, assign) BOOL maxDay;

@end

//数据首页-商品销售数据
@interface BillDataSaleGoodgraphModelSub : BaseModel

@property (nonatomic, copy) NSString *goodName;
//商品销售额百分比
@property (nonatomic, copy) NSString *percentage;
//商品销售额
@property (nonatomic, copy) NSString *totalFee;

@end

//数据首页-客户成交额数据
@interface BillDataSaleClientgraphModelSub : BaseModel

@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *percentage;
@property (nonatomic, copy) NSString *totalFee;

@end

// 数据首页
@interface BillDataAllDataModel : BaseModel

//销售额月份：10.02
@property (nonatomic, copy) NSString *saleDate;
//月销售额 999.00
@property (nonatomic, copy) NSString *saleFee;
//销售额数据
@property (nonatomic, copy) NSArray *saleAmount;
//商品销售数据
@property (nonatomic, copy) NSArray *saleGoodgraph;

//客户成交额数据
@property (nonatomic, copy) NSArray *saleClientgraph;

@end


// 511002_销售额统计
@interface BillDataSaleAmountModel : BillDataAllDataModel

@end




// 511003_商品销售排行
@interface BillDataSaleGoodsModel : BaseModel

//商品销售数据
@property (nonatomic, copy) NSArray *saleGoodgraph;

@property (nonatomic, copy) NSArray *saleGoods;
@end

//511003_商品销售排行-saleGoods
@interface BillDataSaleGoodsModelWithGoodsSub : BaseModel

@property (nonatomic, copy) NSString *goodName;
@property (nonatomic, strong) NSNumber *unit;
@property (nonatomic, copy) NSString *totalFee;

@end



// 511004_客户成交排行
@interface BillDataSaleClientsModel : BaseModel

//客户成交额图表数据
@property (nonatomic, copy) NSArray *saleClientgraph;

//客户额列表数据
@property (nonatomic, copy) NSArray *saleClients;
@end

@interface BillOpenBillServiceStatusModel : BaseModel

@property (nonatomic, strong) NSNumber *boughtStatus;
@property (nonatomic, strong) NSNumber *trialLeftDay;
@property (nonatomic, copy) NSString *freeTrialJumpUrl;
@property (nonatomic, assign) BOOL needBoughtCheck; //是否需要校验是否开通服务才允许使用

@end
