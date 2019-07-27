//
//  MSCTranslationModel.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MSCTranslationModel.h"

@implementation MSCTranslationModel
- (instancetype)initWithSet:(FMResultSet *)set
{
    if (self = [super init]) {
        
        self.iid = [set intForColumnIndex:0];
        self.languageType = [set intForColumn:@"languageType"];
        self.chinese = [set stringForColumn:@"chinese"] ;
        self.english = [set stringForColumn:@"english"] ;
        self.TranslationFailure = [set stringForColumn:@"TranslationFailure"] ;
        self.time = [set stringForColumn:@"time"];
    }
    return self;
}

#pragma mark - 在对象归档的时候调用
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.languageType] forKey:@"LANGUAGETYPE"];
    [aCoder encodeObject:self.chinese forKey:@"CHINESE"];
    [aCoder encodeObject:self.english forKey:@"ENGLISH"];
    [aCoder encodeObject:self.TranslationFailure forKey:@"TranslationFailure"];
   
    [aCoder encodeObject:[NSNumber numberWithInt:self.iid] forKey:@"iid"];
    [aCoder encodeObject:self.time forKey:@"time"];

}
#pragma mark - 解档方法调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.languageType = [[aDecoder decodeObjectForKey:@"LANGUAGETYPE"] integerValue];
        self.chinese = [aDecoder decodeObjectForKey:@"CHINESE"];
        self.english = [aDecoder decodeObjectForKey:@"ENGLISH"];
        self.TranslationFailure = [aDecoder decodeObjectForKey:@"TranslationFailure"];

        self.iid = [[aDecoder decodeObjectForKey:@"iid"] intValue];
        self.time = [aDecoder decodeObjectForKey:@"time"];

    }
    return self;
}
@end
