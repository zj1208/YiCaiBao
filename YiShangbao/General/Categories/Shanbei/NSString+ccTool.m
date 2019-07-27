//
//  NSString+ccTool.m
//  SortOut
//
//  Created by light on 2018/2/27.
//  Copyright © 2018年 light. All rights reserved.
//

#import "NSString+ccTool.h"

@implementation NSString (ccTool)

- (NSString *)cc_stringKeepTwoDecimal{
    return [self cc_stringKeepDecimalOrderOfUnits:2];
}


- (NSString *)cc_stringKeepDecimalOrderOfUnits:(NSInteger)count{
    if (self.length == 0) {
        return self;
    }
    NSString *newString = [NSString stringWithFormat:@"%@", self];
    NSRange range = [newString rangeOfString:@"."];
    if (range.length == 0) {
        newString = [newString stringByAppendingString:@".00"];
    }else{
        if (newString.length < range.location + 1 + count){
            newString = [newString stringByAppendingString:@"0"];
            newString = [newString cc_stringKeepDecimalOrderOfUnits:count];
        }else if (newString.length == range.location + 1 + count) {
            
        }else{
            
        }
        
    }
    return newString;
}

@end
