//
//  LiveAcitonModel.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface LiveAcitonModel : BaseModel

@property(nonatomic, copy) NSString *shopId;                //商铺实景id标识
@property(nonatomic, copy) NSString *left;                  //商铺左视图
@property(nonatomic, copy) NSString *center;                 //商铺正门
@property(nonatomic, copy) NSString *right;                 //商铺右视图
@property(nonatomic, copy) NSString *others;                //附加图片","分割，最多3张

@end
