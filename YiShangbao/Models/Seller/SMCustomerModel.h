//
//  SMCustomerModel.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface SMCustomerAddModel : BaseModel
@property(nonatomic,strong)NSNumber *iid;
@property(nonatomic,strong)NSString *companyName  ;//  string    N    公司名
@property(nonatomic,strong)NSString *contact   ;// string    Y    联系人
@property(nonatomic,strong)NSString *mobile   ;// string    Y    手机号
@property(nonatomic,strong)NSString *fax   ;// string    Y    传真
@property(nonatomic,strong)NSString *email  ;//  string    Y    邮箱
@property(nonatomic,strong)NSString *address ;//   string    Y    地址
@property(nonatomic,strong)NSString *wechat  ;//  string    Y    微信
@property(nonatomic,strong)NSString *remark  ;//  string    Y    备注 2018.3.2

@end

@interface SMCusArrdessBookModel : BaseModel
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *pinyin;
@end


@interface SMCustomerSubModel : BaseModel
@property(nonatomic,strong)NSNumber *iid;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *contact;
@property(nonatomic,strong)NSString *companyName;
@end

@interface SMCustomerModel : BaseModel
@property(nonatomic,strong)NSString *group;
@property(nonatomic,strong)NSArray *list;
@end



