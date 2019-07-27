//
//  ServiceModel.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"



@interface MenuListModel : BaseModel
@property(nonatomic, strong) NSNumber *index;               //排序
@property(nonatomic, copy) NSString *name;                  //名称
@property(nonatomic, copy) NSString *alias;                 //别名
@property(nonatomic, copy) NSString *icon;                  //图标
@property(nonatomic, copy) NSString *url;                   //链接
@property(nonatomic, strong) NSNumber *login1st;            //是否需要登录；T-需要，F-不需要
@property(nonatomic, strong) NSNumber *forceShop2nd;        //强制开店；T-需要，F-不需要
@property(nonatomic, strong) NSNumber *idtf3rd;             //是否需要认证；T-需要，F-不需要

@property(nonatomic, copy) NSString *sideOfPic;             //表示右上角小图标链接

@end


@interface ServiceMenuModel : BaseModel
@property(nonatomic, strong)NSNumber *row;                  //每行列数
@property(nonatomic, strong)NSArray *menuList;              //菜单列表
@end




@interface ServiceModel : BaseModel

@property(nonatomic, copy) NSString *zrzzID;                //转租转让ID，如："841"
@property(nonatomic, copy) NSString *picOne;                //商位主图1，如果用户上传的图片为空，则会下发对应市场的默认图片
@property(nonatomic, copy) NSString *boothno;               //商位号，如："45761"
@property(nonatomic, copy) NSString *submarket;             //所在市场，如："1006"
@property(nonatomic, assign) int subfloor;                  //所在楼层，如：4
@property(nonatomic, copy) NSString *subindustry;           //行业，如："131"
@property(nonatomic, copy) NSString *type;                  //类型（转租，转让），如："1"
@property(nonatomic, copy) NSString *boothmodel;            //全摊半摊，如："/"

@property(nonatomic, copy) NSString *subindustryValue;      //行业名，如："饰品"
@property(nonatomic, copy) NSString *typeValue;             //类型（转租，转让）
@property(nonatomic, copy) NSString *submarketValue;        //所在市场，如："篁园市场"
@property(nonatomic, copy) NSString *createTimeValue;       //发布时间，如：2017-01-13
@property(nonatomic, copy) NSString *boothmodelValue;       //全摊半摊，如："全摊"
@property(nonatomic, copy) NSString *titleValue;            //完整的标题，如："篁园市场 5楼 45761"

@property(nonatomic, copy) NSString *updateTimeValue;  //更新时间

@property(nonatomic, strong) NSNumber *isRecommend;         //是否推荐0-否，1-是
@end

@interface SubletListModel : BaseModel

@property (nonatomic, strong) NSArray *records;
@property (nonatomic, copy) NSString *subletDetailUrl;//完整url，参数占位符由客户端替换
@property (nonatomic, copy) NSString *subletListUrl;

@end
