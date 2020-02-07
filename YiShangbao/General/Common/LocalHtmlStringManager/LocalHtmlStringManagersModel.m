//
//  LocalHtmlStringManagersModel.m
//  YiShangbao
//
//  Created by 朱新明 on 2020/2/5.
//  Copyright © 2020 com.Microants. All rights reserved.
//

#import "LocalHtmlStringManagersModel.h"

@implementation LocalHtmlStringManagersModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"ycbPurchaseForm"      :@"ycbPurchaseForm",
             @"ycbPurchaseOrder"     :@"ycbPurchaseOrder",
             @"ycbPersonalConcernedShop" :@"ycbPersonalConcernedShop",
             @"ycbPersonalConcernedGoods" :@"ycbPersonalConcernedGoods",
         @"ycbPersonalRealAuthenticationSuccess":@"ycbPersonalRealAuthenticationSuccess",
             @"ycbCompanyAuthenticationSuccess": @"ycbCompanyAuthenticationSuccess",
             @"ycbIdentityVerify" :@"ycbIdentityVerify",
             @"unverify"   :@"unverify",
             @"wallet"     :@"wallet",
             @"myOrderedService" :@"myOrderedService",
             @"registerProtocol" :@"registerProtocol",
             @"disputeHandleRules" : @"disputeHandleRules",
             @"pcUploadIntro" :@"pcUploadIntro",
//             P1
             @"suggestFeedBack":@"suggestFeedBack",
             @"ycbSuggestFeedBack" :@"ycbSuggestFeedBack",
             @"ycbHelpCenter" :@"ycbHelpCenter",
             @"helpCenter" :@"helpCenter",
             @"aboutUs" :@"aboutUs",
             };
}

@end

