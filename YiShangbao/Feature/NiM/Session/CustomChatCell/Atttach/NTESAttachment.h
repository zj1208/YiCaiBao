//
//  NTESAttachment.h
//  YiShangbao
//
//  Created by simon on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESCustomProductLinkModel.h"
#import "NTESCustomAttachmentDefines.h"


@interface NTESAttachment : NSObject<NIMCustomAttachment>

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NTESCustomProductLinkModel *model;


@end
