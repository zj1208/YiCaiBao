//
//  MyCustomerAddEditController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/5/7.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLTextView.h"

@interface MyCustomerAddEditController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UITextField *nameTextFild;
@property (weak, nonatomic) IBOutlet UITextField *mobieTextFild;

@property (weak, nonatomic) IBOutlet JLTextView *addressTextView;
@property (weak, nonatomic) IBOutlet JLTextView *descTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeightLayout;


//必传项:  采购商id,
@property(nonatomic,strong)NSString *buyerBizId  ;
//新增必传，编辑不传:  来源-1未知(默认)0-粉丝 1-访客 2-IM消息 3-订单
@property(nonatomic,assign)AddOnlineCustomerSourceType source;

//新增还是编辑:默认新增
@property(nonatomic,assign)BOOL isEditCustomer;

@end
