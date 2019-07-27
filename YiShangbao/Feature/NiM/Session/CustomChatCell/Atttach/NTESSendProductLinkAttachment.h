//
//  NTESSendProductLinkAttachment.h
//  YiShangbao
//
//  Created by simon on 2018/5/17.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESSendProductLinkModel.h"
#import "NTESCustomAttachmentDefines.h"


@interface NTESSendProductLinkAttachment : NSObject<NIMCustomAttachment>


@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NTESSendProductLinkModel *model;


@end
