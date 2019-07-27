//
//  MakeBillAPI.h
//  YiShangbao
//
//  Created by light on 2018/1/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "MakeBillModel.h"

#pragma mark - USER URL

//510003_获取单据列表
static NSString *kBill_Get_BillSaleList_URL = @"mtop.bill.getBillSaleList";
//510004_获取单据详情
static NSString *kBill_Get_BillSaleInfo_URL = @"mtop.bill.getBillSaleInfo";
//510005_增修开单
static NSString *kBill_Get_Billing_URL = @"mtop.bill.upsertBilling";
//510006_获取历史品名列表
static NSString *kBill_Get_HistoryGoodsNameList_URL = @"mtop.bill.getHistoryGoodsNameList";
//510007_获取历史品名详情
static NSString *kBill_Get_HistoryGoodsName_URL = @"mtop.bill.getHistoryGoodsNameInfo";
//510008_确认添加商品
static NSString *kBill_Post_ConfirmAddGoods_URL = @"mtop.bill.confirmAddGoods";
//510009_生成默认单据号
static NSString *kBill_Get_GenerateBillNo_URL = @"mtop.bill.generateBillNo";
//510010_单据详情查看
static NSString *kBill_bill_previewView_URL = @"mtop.bill.pdfView";
//510011_删除单据
static NSString *kBill_bill_deleteBillSale_URL = @"mtop.bill.deleteBillSale";
//510012_单据分享
static NSString *kBill_billShare_URL = @"mtop.bill.billShare";
//510013_单据搜索历史
static NSString *kBill_bill_searchWords_URL = @"mtop.bill.getSearchWordsOpenBill";
//510014_删除搜索历史记录
static NSString *kBill_bill_deleteSearchWords_URL = @"mtop.bill.deleteSearchWordsOpenBill";
//510016_条款展示初始化
static NSString *kBill_bill_getDisplayClause_URL = @"mtop.bill.getDisplayClause";
//510017_保存条款内容
static NSString *kBill_bill_saveClauseContent_URL = @"mtop.bill.saveClauseContent";

//510100_新增/修改客户资料
static NSString *kBill_Post_NewCustomerInfo_URL = @"mtop.bill.newCustomerInfo";
//510101_通讯录导入客户
static NSString *kBill_Post_BatchNewCustomerInfo_URL = @"mtop.bill.batchNewCustomerInfo";
//510101_批量查询客户
static NSString *kBill_Get_QueryContacts_URL = @"mtop.bill.queryContacts";
//510102_查询客户
static NSString *kBill_Get_GetContact_URL = @"mtop.bill.getContact";



//511001_数据首页
static NSString *kBill_data_getDataAll_URL = @"mtop.bill.data.getDataAll";
//511002_销售额统计
static NSString *kBill_data_getSaleAmount_URL = @"mtop.bill.data.getSaleAmount";
//511003_商品销售排行
static NSString *kBill_data_getSaleGoods_URL = @"mtop.bill.data.getSaleGoods";
//511004_客户成交排行
static NSString *kBill_data_getSaleClients_URL = @"mtop.bill.data.getSaleClients";

//512003_获取开单弹窗信息
static NSString *kBill_getOpenBillStatusInfo_URL = @"mtop.bill.getOpenBillStatusInfo";


//开单单据收款状态
typedef NS_ENUM(NSInteger, WYBillPayStatusType){
    WYBillPayStatusTypeNot = 1,       //未付款
    WYBillPayStatusTypePart = 2,      //部分收款
    WYBillPayStatusTypeAll = 3,       //全部收款
};

@interface MakeBillAPI : BaseHttpAPI


/**
 510003_获取单据列表

 @param searchWord 搜索关键字
 @param payStatus 单据支付状态
 @param pageNo pageNO description
 @param pageSize pageSize description
 @param success success description
 @param failure failure description
 */
- (void)getBillListBySearchWord:(NSString *)searchWord payStatus:(NSNumber *)payStatus pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 //510004_获取单据详情

 @param billId 单据ID
 @param success success description
 @param failure failure description
 */
- (void)getBillInfoByBillId:(NSString *)billId success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 //510005_增修开单

 @param model 开单model
 @param success success description
 @param failure failure description
 */
- (void)postMakeBill:(MakeBillUploadModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**

 510100_新增/修改客户资料

 @param parm parm description
 */
- (void)postkBillNewCustomerInfo:(NSDictionary *)parm success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 510006_获取历史品名列表

 @param success success description
 @param failure failure description
 */
- (void)getkBillHistoryGoodsNameListWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
  510007_获取历史品名详情

 @param goodsName 品名关键字
 @param success success description
 @param failure failure description
 */
- (void)getkBillHistoryGoodsNameInfoByGoodsname:(NSString *)goodsName success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 510008_确认添加商品

 @param goodsModel 商品Model
 @param success success description
 @param failure failure descriptionz
 */
- (void)postBillConfirmAddGoodsWithModel:(MakeBillGoodsModel *)goodsModel success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 //510009_生成默认单据号

 @param success success description
 @param failure failure description
 */
- (void)getBillGenerateBillNoWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 510010_单据详情预览

 @param billId 单据ID
 @param success success description
 @param failure failure description
 */
- (void)getBillPreviewInfoByBillId:(NSString *)billId  success:(CompleteBlock)success failure:(ErrorBlock)failure;
/**
 510011_删除单据

 @param billId 单据ID
 @param success success description
 @param failure failure description
 */
- (void)postBillDeleteByBillId:(NSString *)billId success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 510012_单据分享
 @param billId 单据ID
 @param success success description
 @param failure failure description
 */
- (void)getBillShareByBillId:(NSString *)billId  success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 510013_单据搜索历史

 @param success success description
 @param failure failure description
 */
- (void)getBillSearchWordsSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 510014_删除搜索历史记录

 @param success success description
 @param failure failure description
 */
- (void)postBillDeleteSearchWordsSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 510016_条款展示初始化

 @param success success description
 @param failure failure description
 */
- (void)getBillDisplayClauseSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 510017_保存条款内容

 @param display 是否展示 on-展示 off-不展示
 @param content 自定义条例内容
 @param success success description
 @param failure failure description
 */
- (void)postBillSaveClauseDisplay:(NSString *)display content:(NSString *)content bankCard:(NSString *)bankCard success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 510101_通讯录导入客户

 @param contacts JSON Array
 */
- (void)postkBillBatchNewCustomerInfoArr:(NSString *)contacts success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 510101_批量查询客户
 @param keyword 公司名称，联系人，手机号码
 @param pageNum pageNum description
 @param pageSize pageSize description
 */
- (void)getkBillQueryContacts:(NSString *)keyword pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize Success:(CompletePageBlock)success failure:(ErrorBlock)failure;


/**
 510102_查询客户

 @param contactId 批量查询客户结果中的id
 */
- (void)getkBillGetContact:(NSString *)contactId success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 511001_数据首页

 */
- (void)getBillDataWithAllDataWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 511002_销售额统计

 */
- (void)getBillDataWithGetSaleAmountWithYear:(NSString *)year month:(NSString *)month success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 511003_商品销售排行

 */
- (void)getBillDataWithGetSaleGoodsYear:(NSString *)year month:(NSString *)month success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 511004_客户成交排行

 */

- (void)getBillDataWithGetSaleClientsWithYear:(NSString *)year month:(NSString *)month success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 512003_获取开单弹窗信息
 @param funcName 开单点击功能点,newBill:新建开单,chart:报表,customer:客户
 @param success success description
 @param failure failure description
 */
- (void)getBillOpenBillStatusInfoWithFuncName:(NSString *)funcName Success:(CompleteBlock)success failure:(ErrorBlock)failure;

@end
