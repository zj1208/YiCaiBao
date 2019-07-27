//
//  LocalHtmlStringManager.m
//  YiShangbao
//
//  Created by simon on 2018/8/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "LocalHtmlStringManager.h"

//发布求购的链接
static NSString * const ud_PurchaseForm_URL = @"ud_PurchaseForm_URL";


@implementation LocalHtmlStringManager

+ (instancetype)shareInstance
{
    static id sharedHelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (void)registerLocalHtmlStringManagers
{
    [[[AppAPIHelper shareInstance]publicAPI]getHtmlStringsWithSuccess:^(id data) {
        if (data)
        {
            self.LocalHtmlStringManagerModel = data;
            [[LocalHtmlStringManager shareInstance] setYcbPurchaseFormURL:self.LocalHtmlStringManagerModel.ycbPurchaseForm];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)resetRequestLocalHtmlStringManagersWithSoureController:(UIViewController *)vc forKey:(NSString *)key success:(CompleteBlock)success
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]publicAPI]getHtmlStringsWithSuccess:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:nil];
        if (success)
        {
            success (data);
        }
   
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_hideHUDForView:nil];
        [UIAlertController zx_presentGeneralAlertInViewController:vc withTitle:NSLocalizedString(@"哎呀呀，服务器开小差，链接获取失败啦～哭唧唧～", nil) message:nil cancelButtonTitle:NSLocalizedString(@"关闭", nil) cancleHandler:nil doButtonTitle:NSLocalizedString(@"重试一下", nil) doHandler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf loadHtml:nil forKey:key withSoureController:vc];
        }];
    }];
}

- (void)loadHtml:(NSString *)htmlUrl forKey:(NSString *)key withSoureController:(UIViewController *)vc
{
    if ([NSString zhIsBlankString:htmlUrl])
    {
        [self resetRequestLocalHtmlStringManagersWithSoureController:vc forKey:key success:^(id data) {
            
            if (data)
            {
                self.LocalHtmlStringManagerModel = data;
                [[LocalHtmlStringManager shareInstance]setYcbPurchaseFormURL:self.LocalHtmlStringManagerModel.ycbPurchaseForm];
                NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:self.LocalHtmlStringManagerModel error:nil];
                NSString *htmlUrl = [dic objectForKey:key];
                [[WYUtility dataUtil] routerWithName:htmlUrl withSoureController:vc];
            }
        }];
    }
    else
    {
        [[WYUtility dataUtil] routerWithName:htmlUrl withSoureController:vc];
    }
}


- (void)setYcbPurchaseFormURL:(NSString *)purchaseForm
{
    [UserDefault setObject:purchaseForm forKey:ud_PurchaseForm_URL];
    [UserDefault synchronize];
}

- (NSString *)getYcbPurchaseFormURL
{
   return  [UserDefault objectForKey:ud_PurchaseForm_URL];
}

@end
