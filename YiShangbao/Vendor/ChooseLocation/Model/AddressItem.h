//
//  AddressItem.h
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressItem : BaseModel
//@property (nonatomic,copy) NSString * code;
//@property (nonatomic,copy) NSString * sheng;
//@property (nonatomic,copy) NSString * di;
//@property (nonatomic,copy) NSString * xian;
//@property (nonatomic,copy) NSString * name;
//@property (nonatomic,copy) NSString * level;
@property (nonatomic,assign) BOOL  isSelected;


//类目id
@property (nonatomic, strong) NSNumber *cateId;
//等级
@property (nonatomic, strong) NSNumber *level;
//类目名称
@property (nonatomic, copy) NSString *name;


- (instancetype)initWithDict:(NSDictionary *)dict;


@end
