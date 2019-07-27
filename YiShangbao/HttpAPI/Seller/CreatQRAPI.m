//
//  CreatQRAPI.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CreatQRAPI.h"
#import "QRModel.h"

@implementation CreatQRAPI


-(void)getQRCodeWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Info_getQRCode_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            QRModel *model = [MTLJSONAdapter modelOfClass:[QRModel class] fromJSONDictionary:data error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
