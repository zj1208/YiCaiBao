//
//  ExtendProductAlertController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)(void);
typedef void(^CertificationNowBlock)(void);
@interface ExtendProductAlertController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *alertContentView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *CertificationImmediatelyBtn;

@property(nonatomic,copy)NSString *alertMessage;
@property(nonatomic,copy)CancelBlock cancelBlock;
@property(nonatomic,copy)CertificationNowBlock certificationNowBlock;

+(void)showWithMessage:(NSString *)message presenting:(UIViewController *)presentingVC cancelTitle:(NSString *)canTitle cancelBlock:(CancelBlock)cancelBlock cerTitle:(NSString *)cerTitle certificationNowBlock:(CertificationNowBlock)certificationNowBlock  ;
@end
