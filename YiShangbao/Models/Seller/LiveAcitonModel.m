//
//  LiveAcitonModel.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "LiveAcitonModel.h"

@implementation LiveAcitonModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"shopId"              :   @"id",
             @"left"                :   @"left",
             @"center"              :   @"center",
             @"right"               :   @"right",
             @"others"              :   @"others"
             };
}
@end
