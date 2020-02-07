//
//  LocalHtmlStringManager.h
//  YiShangbao
//
//  Created by simon on 2018/8/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLKeyMarco.h"
#import "LocalHtmlStringManagersModel.h"

@interface LocalHtmlStringManager : NSObject

@property (nonatomic, strong) LocalHtmlStringManagersModel *LocalHtmlStringManagerModel;

+ (instancetype)shareInstance;

- (void)registerLocalHtmlStringManagers;

- (void)loadHtml:(NSString *)htmlUrl forKey:(NSString *)key withSoureController:(UIViewController *)vc;

// 获取发布求购链接-用于3DTouch，需要本地保存
//获取求购链接
- (void)setYcbPurchaseFormURL:(NSString *)purchaseForm;

- (NSString *)getYcbPurchaseFormURL;
@end

