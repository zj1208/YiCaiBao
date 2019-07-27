//
//  ZXADBannerModel.m
//  baohuai_iPhone
//
//  Created by 朱新明 on 14/5/2.
//  Copyright (c) 2014年 朱新明. All rights reserved.
//

#import "ZXADBannerModel.h"


@interface ZXADBannerModel ()

@end

@implementation ZXADBannerModel


- (instancetype)initWithDesc:(nullable NSString *)desc picString:(nullable NSString *)picString url:(nullable NSString *)url advId:(nullable NSNumber *)aId
{
    self = [super init];
    if (self)
    {
        self.desc = desc;
        self.pic =picString;
        self.url =url;
        self.advId = aId;
    }
    return self;
    
}


@end




