//
//  NTESCustomProductLinkModel.m
//  YiShangbao
//
//  Created by simon on 2018/4/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NTESCustomProductLinkModel.h"

@implementation NTESCustomProductLinkModel

#pragma mark - Getter
- (NSString *)title{
    if (!_title) {
        _title = @"";
    }
    return _title;
}

- (NSString *)recommendation{
    if (!_recommendation) {
        _recommendation = @"";
    }
    return _recommendation;
}

- (NSString *)linkUrl
{
    if (!_linkUrl)
    {
        _linkUrl = @"";
    }
    return _linkUrl;
}
- (NSString *)imageUrl
{
    if (!_imageUrl)
    {
        _imageUrl = @"";
    }
    return _imageUrl;
}

@end
