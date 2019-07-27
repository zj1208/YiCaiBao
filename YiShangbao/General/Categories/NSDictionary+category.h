//
//  NSDictionary+category.h
//  96871
//
//  Created by zhangdd on 14-12-25.
//  Copyright (c) 2014年 zhangdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (category)
-(id)safeValueForKey:(NSString*)key;
-(id)validSafeValueForKey:(NSString *)key;

@end
