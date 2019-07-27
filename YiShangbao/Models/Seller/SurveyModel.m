//
//  SurveyModel.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SurveyModel.h"

@implementation DetectSearchModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"jzID":@"id",
             @"companyname":@"companyname",
             @"companyaddress":@"companyaddress",
             @"type":@"type"
             };
}

@end


@implementation PersonModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name"            :   @"name",
             @"country"         :   @"country",
             @"passport"        :   @"passport",
             @"picpath"         :   @"picpath",
             @"position"        :   @"position"
             };
}
@end


@implementation CircularDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"updatetime"      :   @"updatetimeVO",
             @"entitytype"      :   @"entitytype",
             @"companyname"     :   @"companyname",
             @"companyaddress"  :   @"companyaddress",
             @"amount"          :   @"amount",
             @"victims"         :   @"victims",
             @"noticecontent"   :   @"noticecontent",
             @"person"          :   @"person"
             };
}

+ (NSValueTransformer *)personJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PersonModel class]];
}

@end


@implementation FeedbacksModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"feedbacktime"     :   @"feedbacktimeVO",
             @"content"          :   @"content"
             };
}
@end

@implementation ComplainsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"signtime"        :   @"signtimeVO",
             @"content"         :   @"content"
             };
}
@end


@implementation ReportedDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"companyname"     :   @"companyname",
             @"comaddr"         :   @"comaddr",
             @"buyman"          :   @"buyman",
             @"buymantel"       :   @"buymantel",
             @"feedbacks"       :   @"feedbacks",
             @"complains"       :   @"complains"
             };
}

+ (NSValueTransformer *)feedbacksJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[FeedbacksModel class]];
}

+ (NSValueTransformer *)complainsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ComplainsModel class]];
}

@end

@implementation CircularListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"detectionID"     :   @"id",
             @"companyname"     :   @"companyname",
             @"escapedateVO"    :   @"escapedateVO",
             @"flag"            :   @"flag"
             };
}

@end


//@implementation DetecSearchHistoryModel
//
//@end

@implementation SurveyModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"detectionID"     :   @"id",
             @"title"           :   @"title",
             @"createTime"      :   @"createTimeVO" ,
             @"imageUrl"        :   @"imageUrl",
             @"contentUrl"      :   @"contentUrl",
             };
}

@end

@implementation MarketAnnouncementModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"type" : @"type",
             @"title":@"title",
             @"image":@"image",
             @"abbr":@"abbr",
             @"date":@"date",
             @"url":@"url",
             };
}
@end
