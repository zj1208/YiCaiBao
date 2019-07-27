//
//  SurveyModel.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"


@interface DetectSearchModel : BaseModel

@property(nonatomic, copy) NSNumber *jzID;
@property(nonatomic, copy) NSString *companyname;
@property(nonatomic, copy) NSString *companyaddress;
@property(nonatomic, copy) NSString *type;


//hasReadReported  新增数据

@end

@interface PersonModel : BaseModel
@property(nonatomic, copy) NSString *name;              //业主姓名
@property(nonatomic, copy) NSString *country;           //国籍
@property(nonatomic, copy) NSString *passport;              //证件
@property(nonatomic, copy) NSString *picpath;               //证件图片
@property(nonatomic, copy) NSString *position;              //职务
@end


@interface CircularDetailModel : BaseModel

@property(nonatomic, copy) NSString *updatetime;            //时间
@property(nonatomic, copy) NSString *companyname;           //公司／个人
@property(nonatomic, copy) NSString *companyaddress;        //地址
@property(nonatomic, copy) NSNumber *entitytype;            //经营主体类型：1公司2个人
@property(nonatomic, copy) NSNumber *amount;                //涉及金额
@property(nonatomic, copy) NSNumber *victims;               //受害人数
@property(nonatomic, copy) NSString *noticecontent;         //事件概述
@property(nonatomic, strong)NSArray *person;
@end

@interface FeedbacksModel : BaseModel

@property(nonatomic, copy) NSString *feedbacktime;          //反馈时间
@property(nonatomic, copy) NSString *content;               //内容

@end

@interface ComplainsModel : BaseModel

@property(nonatomic, copy) NSString *signtime;              //填报信息
@property(nonatomic, copy) NSString *content;               //内容

@end

@interface ReportedDetailModel : BaseModel

@property(nonatomic, copy) NSString *companyname;           //公司／个人
@property(nonatomic, copy) NSString *comaddr;               //地址
@property(nonatomic, copy) NSString *buyman;                //采购人
@property(nonatomic, copy) NSString *buymantel;             //采购人电话
@property(nonatomic, copy) NSArray *feedbacks;              //反馈信息Json数组
@property(nonatomic, copy) NSArray *complains;              //填报信息Json数组

@end


@interface CircularListModel : BaseModel

@property(nonatomic, copy) NSNumber *detectionID;           //通报标识
@property(nonatomic, copy) NSString *companyname;           //名字
@property(nonatomic, copy) NSString *escapedateVO;          //时间
@property(nonatomic, copy) NSString *flag;

@end


//@interface DetecSearchHistoryModel : BaseModel
//
//@end





@interface SurveyModel : BaseModel

@property(nonatomic, copy) NSNumber *detectionID;   //诈骗id
@property(nonatomic, copy) NSString *title;         //诈骗案例标题
@property(nonatomic, copy) NSString *createTime;    //案例发布时间
@property(nonatomic, copy) NSString *imageUrl;      //案例列表图片
@property(nonatomic, copy) NSString *contentUrl;    //案例h5链接


@end

@interface MarketAnnouncementModel : BaseModel
@property(nonatomic, assign) int type;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *abbr;
@property(nonatomic, copy) NSString *url;

@end
