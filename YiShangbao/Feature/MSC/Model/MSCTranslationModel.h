//
//  MSCTranslationModel.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

typedef NS_ENUM(NSInteger,MSCTranslationModelLanguageType){
    
    MSCTranslationModelChineseLanguage         = 0, //按住说中文
    
    MSCTranslationModelEnglishLanguage         = 1, //按住说英文
};

@interface MSCTranslationModel : NSObject<NSCoding>
- (instancetype)initWithSet:(FMResultSet *)set;

@property (nonatomic, assign) MSCTranslationModelLanguageType languageType; 
@property (nonatomic, strong) NSString *chinese;
@property (nonatomic, strong) NSString *english;
@property (nonatomic, strong) NSString *TranslationFailure;


@property (nonatomic, assign) int iid;
@property (nonatomic, strong) NSString *time;

@end
