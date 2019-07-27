//
//  NSDictionary+category.m
//  96871
//
//  Created by zhangdd on 14-12-25.
//  Copyright (c) 2014年 zhangdd. All rights reserved.
//

#import "NSDictionary+category.h"

@implementation NSDictionary (category)
-(id)safeValueForKey:(NSString *)key
{
    if([self valueForKey:key] && [NSNull null] != [self valueForKey:key]){
        return [self valueForKey:key];
    }
    
    return nil;
}


-(id)validSafeValueForKey:(NSString *)key
{
    NSString* orignStr;
    if([self valueForKey:key] && [NSNull null] != [self valueForKey:key]){
        orignStr = [self valueForKey:key];
    }else{
        return nil;
    }
    
    NSString* newStr = [orignStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([newStr isEqualToString:@""]){
        return nil;
    }
    
    return orignStr;
}

@end
