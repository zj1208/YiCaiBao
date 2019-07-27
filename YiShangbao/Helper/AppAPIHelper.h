//
//  AppAPIHelper.h
//  SiChunTang
//
//  Created by 朱新明 on 15/6/7.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModelAPI.h"
#import "TradeMainAPI.h"
#import "MessageAPI.h"
#import "SurveyMainAPI.h"
#import "ServiceMainAPI.h"
#import "CreatQRAPI.h"
#import "LiveActionAPI.h"
#import "ShopAPI.h"
#import "ProductMdoleAPI.h"
#import "NiMAccountAPI.h"
#import "ExtendProductAPI.h"
#import "PurchaserAPI.h"
#import "SearchAPI.h"
#import "HSOrderManagementApi.h"
#import "WYPlaceOrderAPI.h"
#import "WYPublicAPI.h"
#import "AccountApi.h"
#import "WYShopCartAPI.h"
#import "MakeBillAPI.h"
#import "UserModelExtendAPI.h"
#import "WYAttentionAPI.h"

@interface AppAPIHelper : NSObject

@property (nonatomic, strong) UserModelAPI *userModelAPI;

@property (nonatomic, strong) TradeMainAPI *tradeMainAPI;

@property (nonatomic, strong) MessageAPI *messageAPI;

@property (nonatomic, strong) SurveyMainAPI *SurveyMainAPI;

@property (nonatomic, strong) ServiceMainAPI *ServiceMainAPI;

@property (nonatomic, strong) CreatQRAPI *creatQRAPI;

@property (nonatomic, strong) LiveActionAPI *liveActionAPI;

@property (nonatomic, strong) ShopAPI *shopAPI;

@property (nonatomic, strong) NiMAccountAPI *nimAccountAPI;

@property(nonatomic,strong)ExtendProductAPI* extendProductAPI;

@property (nonatomic, strong) PurchaserAPI *purchaserAPI;

@property (nonatomic, strong) SearchAPI *searchAPI;

@property (nonatomic, strong) HSOrderManagementApi *hsOrderManagementApi;

@property (nonatomic, strong) WYPlaceOrderAPI *placeOrderAPI;

@property (nonatomic, strong) WYPublicAPI *publicAPI;

@property (nonatomic, strong) AccountApi *accountAPI;


@property (nonatomic, strong) WYShopCartAPI *shopCartAPI;

@property (nonatomic, strong) MakeBillAPI *makeBillAPI;

@property (nonatomic, strong) UserModelExtendAPI *userModelExtendAPI;

@property (nonatomic, strong) WYAttentionAPI *attentionAPI;
//
//@property (nonatomic, strong) OderModelAPI * oderModelAPI;
//
//@property (nonatomic, strong) MakeAlbumModelAPI *makeAlbumModelAPI;
//
//@property (nonatomic, strong) MessageModelAPI * messageModelAPI;

//@property (nonatomic, strong) GrowthModelAPI * growthModelAPI;
//@property (nonatomic,strong) ThemeModelAPI *themeModelAPI;


+ (instancetype)shareInstance;


- (UserModelAPI *)getUserModelAPI;

- (UserModelExtendAPI *)getUserModelExtendAPI;

- (TradeMainAPI *)getTradeMainAPI;

- (MessageAPI *)getMessageAPI;

- (SurveyMainAPI *)getSurveyMainAPI;

- (ServiceMainAPI *)getServiceMainAPI;

- (CreatQRAPI *)getCreatQRAPI;

- (LiveActionAPI *)getLiveActionAPI;

- (ShopAPI *)getShopAPI;

- (NiMAccountAPI *)getNimAccountAPI;

-(ExtendProductAPI*)getExtendProductAPI;

- (PurchaserAPI *)getPurchaserAPI;

- (SearchAPI *)getSearchAPI;

-(HSOrderManagementApi *)gethsOrderManagementApi;

-(AccountApi*)getAccountAPI;

- (MakeBillAPI *)getMakeBillAPI;

- (WYAttentionAPI *)getAttentionAPI;

//- (OderModelAPI *)getoderModelAPI;
//
//- (MakeAlbumModelAPI *)getMakeAlbumModelAPI;
//
//- (MessageModelAPI *)getMessageModelAPI;

//- (GrowthModelAPI *)getGrowthModelAPI;
//
//- (ThemeModelAPI *)getThemeModelAPI;
@end
