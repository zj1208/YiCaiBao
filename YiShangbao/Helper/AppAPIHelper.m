//
//  AppAPIHelper.m
//  SiChunTang
//
//  Created by 朱新明 on 15/6/7.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import "AppAPIHelper.h"


@interface AppAPIHelper ()
@end


@implementation AppAPIHelper


+ (instancetype)shareInstance
{
    static id sharedHelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}


- (instancetype)init {
    self = [super init];
    if (self)
    {
        _userModelAPI           = [[UserModelAPI alloc] init];

        _tradeMainAPI           = [[TradeMainAPI alloc] init];
        
        _messageAPI             = [[MessageAPI alloc] init];
        
        _SurveyMainAPI          = [[SurveyMainAPI alloc] init];
        
        _ServiceMainAPI         = [[ServiceMainAPI alloc] init];
        
         _creatQRAPI            = [[CreatQRAPI alloc] init];
        
         _liveActionAPI         = [[LiveActionAPI alloc] init];
        
        _shopAPI                = [[ShopAPI alloc] init];

        _nimAccountAPI             = [[NiMAccountAPI alloc] init];
        
        _extendProductAPI       = [[ExtendProductAPI alloc] init];
        
        _purchaserAPI           = [[PurchaserAPI alloc] init];
        
        
        _searchAPI           = [[SearchAPI alloc] init];
       
        _hsOrderManagementApi           = [[HSOrderManagementApi alloc] init];

        _placeOrderAPI = [[WYPlaceOrderAPI alloc] init];
        
        _publicAPI = [[WYPublicAPI alloc]init];
        
        _accountAPI = [[AccountApi alloc] init];

        
        _shopCartAPI = [[WYShopCartAPI alloc]init];
        
        _makeBillAPI = [[MakeBillAPI alloc]init];
        
        _userModelExtendAPI = [[UserModelExtendAPI alloc] init];
        
        _attentionAPI = [[WYAttentionAPI alloc]init];

    }
    return self;
}


- (UserModelAPI *)getUserModelAPI {
    return _userModelAPI;
}

- (UserModelExtendAPI *)getUserModelExtendAPI
{
    return _userModelExtendAPI;
}

- (TradeMainAPI *)getTradeMainAPI
{
    return _tradeMainAPI;
}

-(MessageAPI *)getMessageAPI
{
    return _messageAPI;
}

-(SurveyMainAPI *)getSurveyMainAPI
{
    return _SurveyMainAPI;
}

- (ServiceMainAPI *)getServiceMainAPI{
    return _ServiceMainAPI;
}

- (CreatQRAPI *)getCreatQRAPI{
    return _creatQRAPI;
}

- (LiveActionAPI *)getLiveActionAPI{
    return _liveActionAPI;
}

- (ShopAPI *)getShopAPI{
    return _shopAPI;
}

- (NiMAccountAPI *)getNimAccountAPI
{
    return _nimAccountAPI;
}

-(ExtendProductAPI*)getExtendProductAPI
{
    return _extendProductAPI;
}

-(PurchaserAPI *)getPurchaserAPI
{
    return _purchaserAPI;
}

-(SearchAPI *)getSearchAPI
{
    return _searchAPI;
}
 
-(HSOrderManagementApi *)gethsOrderManagementApi
{
    return _hsOrderManagementApi;

}
-(AccountApi *)getAccountAPI
{
    return _accountAPI;
}

- (MakeBillAPI *)getMakeBillAPI{
    return _makeBillAPI;
}

- (WYAttentionAPI *)getAttentionAPI{
    return _attentionAPI;
}
//
//
//- (OderModelAPI *)getoderModelAPI
//{
//    return _oderModelAPI;
//}
//
//
//- (MakeAlbumModelAPI *)getMakeAlbumModelAPI
//{
//    return _makeAlbumModelAPI;
//}
//
//- (MessageModelAPI *)getMessageModelAPI
//{
//    return _messageModelAPI;
//}

//- (GrowthModelAPI *)getGrowthModelAPI
//{
//    return _growthModelAPI;
//}
//
//
//- (ThemeModelAPI *)getThemeModelAPI
//{
//    return _themeModelAPI;
//}
@end
