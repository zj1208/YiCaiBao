//
//  NSString+ccTool.h
//  SortOut
//
//  Created by light on 2018/2/27.
//  Copyright © 2018年 light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ccTool)

/**
 keepTwoDecimal 不足补0

 @return 有两位小数字符串 XX.XX
 */
- (NSString *)cc_stringKeepTwoDecimal;

/**
 keepDecimal 不足补0

 @param count 需要保留位数
 @return 有N位小数字符串 XX.XXX
 */
- (NSString *)cc_stringKeepDecimalOrderOfUnits:(NSInteger)count;

@end
