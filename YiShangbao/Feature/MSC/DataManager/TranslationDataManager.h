//
//  TranslationDataManager.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSCTranslationModel.h"

@interface TranslationDataManager : NSObject
+ (TranslationDataManager *)shareTranslationDataManager;

/**
 3.4.0开始废弃，归档数据迁移至数据库，下三个方法废弃
 */
//-(void)saveTranslationDataWithModel:(MSCTranslationModel*)model;
//-(void)replaceLastModelWithModel:(MSCTranslationModel*)model;
//-(NSArray*)getTranslationData;

//从数据库初始化数据，若无数据，从历史归档数据中做迁移，迁移数据库后暂时不删除本地归档数据
-(NSArray<__kindof MSCTranslationModel *> *)getAllMSCTModelData;

-(long)insertDataWithModel:(MSCTranslationModel *)model;
-(void)updateDataWithModel:(MSCTranslationModel *)model;
-(void)deleteDataWithModel:(MSCTranslationModel *)model;
-(NSArray<__kindof MSCTranslationModel *> *)queryAllData;
@end
