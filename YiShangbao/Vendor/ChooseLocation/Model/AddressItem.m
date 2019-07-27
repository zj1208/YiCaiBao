//
//  AddressItem.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "AddressItem.h"

@implementation AddressItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"cateId" : @"v",
             @"level" : @"l",
             @"name" :@"n",
             };
}


- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end
