//
//  CreatQRAPI.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
//301026 获取二维码信息
#define Info_getQRCode_URL        @"mtop.shop.store.getShopQrInfo"

@interface CreatQRAPI : BaseHttpAPI


/**
 获取二维码信息

 @param success success block
 @param failure failure block
 */
-(void)getQRCodeWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


@end
