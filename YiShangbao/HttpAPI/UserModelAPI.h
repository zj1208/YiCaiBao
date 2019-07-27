//
//  UserModelHttp.h
//  douniwan
//
//  Created by lin guohua on 15/6/26.
//  Copyright (c) 2015年 . All rights reserved.
//
//  2018.7.2  修改用户信息接口 回调逻辑

#import "BaseHttpAPI.h"
#import "UserModel.h"
#import "WYUserDefaultManager.h"

#pragma mark - USER URL

//注册
static NSString *kUSER_REGISTER_URL = @"mtop.user.register";
//微信绑定手机号
static NSString *kUSER_BIND_URL = @"mtop.user.wechatBindMobile";

//登陆 1.用户名密码登录
static NSString *kUSER_LOGIN_URL = @"mtop.user.login";
//登录 2.手机号快捷登录
static NSString *kFASTUSER_LOGIN_URL = @"mtop.user.fastLogin";
//登录 3.微信快捷登录
static NSString *kWXUSER_LOGIN_URL = @"mtop.user.wechatLogin";
//获取验证码
static NSString *kUSER_VERIFYCODE_URL =@"mtop.app.getVerificationCode";
//800004_验证验证码
static NSString *kUSER_CHECKVERIFYCODE_URL=@"mtop.app.checkVerificationCode";
//重置密码
static NSString *kUSER_UPDATE_URL =@"mtop.user.resetPassword";
//设置密码
static NSString *kUSER_SETPWD_URL =@"mtop.user.setPassword";
//修改密码
static NSString *kUSER_UPDATEPSWD_URL=@"mtop.user.updatePwd";
//修改昵称
static NSString *kNICK_UPDATE_URL = @"mtop.user.updateNickname";
//修改头像
static NSString *kHEADICON_UPDATE_URL =@"mtop.user.updateHeadIcon";
//更改性别
static NSString *kSEX_UPDATE_URL = @"mtop.user.updateSex";


#define kUSER_FIND_PWD_URL              @""
#define kUSER_FIND_CHANGE_PWD_URL       @""
#define kUSER_CHANGE_PWD_URL            @""


//用户登出
static NSString *kUSER_LOGOUT_URL=@"mtop.user.logout";

//修改用户信息
static NSString *kUSER_UPDATE_USER_INFO_URL=@"photo/user/saveUserInfo.do";

//获取国家编码
static NSString *kBase_GetCountryCodes_URL =@"mtop.cat.countryCodes";

//100017_app帐号绑定微信接口
static NSString *kUSER_postAppBindWechat_URL= @"mtop.user.appBindWechat";

//100021_app账号解绑微信
static NSString *kUSER_postAppUnbindWechat_URL= @"mtop.user.appUnbindWechat";

//100022_手机号变更接口
static NSString *kUSER_postupdateUserPhone_URL =@"mtop.user.updateUserPhone";

//100023_更换手机号时获取验证码
static NSString *kUSER_getVeriCodeByUpdatePhone_URL =      @"mtop.user.getVeriCodeByUpdatePhone";

//100024_更换手机号时校验验证码
static NSString *kUSER_checkVeriCodeByUpdatePhone_URL =      @"mtop.user.checkVeriCodeByUpdatePhone";

//100025_app获取用户市场认证情况
static NSString *kUSER_GetMarketQualiInfo_URL =   @"mtop.user.getMarketQualiInfo";

//100015_获取商家用户基本信息接口
static NSString *kUSER_MYUSERINFO_URL = @"mtop.user.getSellerInfo";

//100018_app切换身份接口
static NSString *kUser_changeUserRole = @"mtop.user.changeUserRole";

//100027_获取用户基础信息接口（获取电话号码，国家区号eg：发验证码前获取电话号码）
static NSString *kUser_getUserBaseInfo	 = @"mtop.user.getUserBaseInfo";




static NSString *kROLETYPE_KEY = @"roleType";//角色
static NSString *kCOUNTRYCODE_KEY  = @"countryCode";  //国家区号
static NSString *kUSERNAME_KEY  = @"mobile";  //用户名
static NSString *kPASSWORD_KEY  = @"pwd" ;    //密码
static NSString *kVERIFY_CODE_KEY =  @"verificationCode" ;   //验证码
static NSString *kPhone_KEY = @"phone"; //手机号
static NSString *kInvitationCode_KEY = @"invitationCode";//邀请码
static NSString *kTargetRole_KEY = @"targetRole";//角色
static NSString *kClientId_KEY = @"clientId";//个推id

typedef NS_ENUM(NSInteger, WYCodeModuleType){
    WYCodeModuleTypeForgetPassword = 0,     //忘记密码验证码
    WYCodeModuleTypeWXBind =1,                 //微信登录(绑定号码)
    WYCodeModuleTypeRegister=2,               //注册验证码
    WYCodeModuleTypeSMSLogin=3,              //短信登录验证码
    WYCodeModuleTypePurchasePhoneAuth=4,      //采购端手机认证
};



typedef NS_ENUM(NSInteger, WYTargetRoleSource)
{
    WYTargetRoleSource_AppLanuch = 1, //进入app
    WYTargetRoleSource_userChange = 2, //内部切换
};

@interface UserModelAPI : BaseHttpAPI

- (void)getUserBaseInfosuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 *  @brief 1.1获取手机验证码
 * //800003_获取手机短信验证码接口 
 
 *  @param mobile   手机号
 *  @param success 成功block
 *  @param failure    失败block
 */
- (void)getSendVerifyCodeMobile:(NSString *)mobile countryCode:(NSString *)countryCode type:(NSString *)type success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 V2.0.0 
 800003_获取手机短信验证码 新增 （type改NSInteger方便枚举，原来接口保持不变）
 @param mobile 手机号
 @param countryCode 国家区号
 @param type 验证码类型
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getSendVerifyCodeMobileVTWO:(NSString *)mobile countryCode:(NSString *)countryCode type:(NSInteger)type success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 v1.1 800004_验证手机验证码

 @param phone 手机号
 @param code 验证码
 @param type 验证类型：忘记密码0，微信登录(绑定号码)1，手机号码注册2，短信登录3，采购端认证短信4，更换手机号码5，提现申请6，确认收货7
 @param success 成功block
 @param failure 失败block
 */
- (void)checkVerifyCodephone:(NSString *)phone verificationCode:(NSString *)code countryCode:(NSString *)countryCode type:(NSString *)type success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 V2.0.0
 800004_验证手机验证码  新增 （type改NSInteger方便枚举，原来接口保持不变）
 @param type 验证类型：忘记密码0，微信登录(绑定号码)1，手机号码注册2，短信登录3，采购端认证短信4，更换手机号码5，提现申请6，确认收货7
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)checkVerifyCodephoneVTWO:(NSString *)phone verificationCode:(NSString *)code countryCode:(NSString *)countryCode type:(NSInteger )type success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 *  @brief 2.用户注册
 *
 *  @param userName     用户名
 *  @param password     密码
 *  @param verifyCode   验证码
 *  @param invitationCode 邀请码，可nil
 *  @param success     成功block
 *  @param failure      失败block
 */
- (void)getRegisterWithUserName:(NSString *)userName password:(NSString *)password countryCode:(NSString *)countryCode name:(NSString *)name verifyCode:(NSString *)verifyCode invitationCode:(NSString *)invitationCode success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 *  @brief 3.1用户登录接口
 *
 *  @param userName 用户名
 *  @param password 密码
 *  @param success 成功block
 *  @param failure    失败block
 */
- (void)getLoginWithUserName:(NSString *)userName password:(NSString *)password countryCode:(NSString *)countryCode success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 *  @brief 3.2手机号快捷登录
 *
 *  @param mobile 手机号
 *  @param verifyCode 验证码
 *  @param success 成功block
 *  @param failure    失败block
 */
- (void)getFastLoginWithMobile:(NSString *)mobile verificationCode:(NSString *)verifyCode countryCode:(NSString *)countryCode success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 *  @brief 3.3.1微信快捷登录
 *
 *  @param code 微信返回CODE
 *  @param success 成功block
 *  @param failure    失败block
 */
- (void)geWXLoginWithCODE:(NSString *)code success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 3.3.2微信绑定

 @param mobile 手机号
 @param password 密码
 @param verifyCode 验证码
 @param invitationCode 邀请码
 @param success 成功block
 @param failure 失败block
 */
-(void)bindWXWithMobile:(NSString *)mobile password:(NSString *)password countryCode:(NSString *)countryCode name:(NSString *)name verifyCode:(NSString *)verifyCode invitationCode:(NSString *)invitationCode unionidUUID:(NSString *)unionidUUID success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 4.重置密码

 @param mobile 手机号
 @param code 验证码
 @param newPwd 新密码
 @param success 成功block
 @param failure 失败block
 */
-(void)resetPasswordWithMobile:(NSString *)mobile code:(NSString *)code newPwd:(NSString *)newPwd countryCode:(NSString *)countryCode success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 手机设置密码

 @param mobile 手机号
 @param pwd 密码
 @param success 成功block
 @param failure 失败block
 */
-(void)phoneSetPasswordWithMobile:(NSString *)mobile pwd:(NSString *)pwd success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 5.修改昵称

 @param nickname 昵称
 @param success 成功block
 @param failure 失败block
 */
-(void)editNicknameWith:(NSString *)nickname success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 修改密码

 @param oldpwd 旧密码
 @param newPwd 新密码
 @param success 成功block
 @param failure 失败block
 */
-(void)changePasswordWithOldpswd:(NSString *)oldpwd newPwd:(NSString *)newPwd success:(CompleteBlock)success failure:(ErrorBlock)failure;




/**
 保存头像

 @param headIconNewUrl 头像存放路径
 @param success 成功block
 @param failure 失败block
 */
- (void)updateHeadIcon:(NSString *)headIconNewUrl success:(CompleteBlock)success failure:(ErrorBlock)failure;




/**
 100020_更改性别接口

 @param sex -1:未知 0:女 1:男
 @param success 成功block
 @param failure 失败block
 */
- (void)updateSex:(NSString *)sex success:(CompleteBlock)success failure:(ErrorBlock)failure;




/**
 100008_[商家端，后台]用户退出登录接口

 @param clientId 推送目标ID，后台退出不需要改字段
 @param success 成功block
 @param failure 失败block
 */
-(void)UserLoginOutWithClientId:(NSString *)clientId success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 *  @brief 4.找回密码并修改/ 没有token设计
 *
 *  @param mobile     手机号
 *  @param password   新密码
 *  @param verifyCode 验证码
 *  @param success   成功block
 *  @param failure      失败block
 */
- (void)getRetrieveChangePasswordWithMobile:(NSString *)mobile password:(NSString *)password verifyCode:(NSString *)verifyCode success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 *  @brief 5.找回密码并修改／有token设计
 *
 *  @param password   新密码
 *  @param success   成功block
 *  @param failure      失败block
 */
- (void)getRetrieveChangePassword:(NSString *)password success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 *  @brief 6.修改密码－／有token设计，根据token来修改
 *
 *  @param password1   旧密码
 *  @param password2   新密码
 *  @param success   成功block
 *  @param failure      失败block
 */

- (void)getChangePassword:(NSString *)password1 password2:(NSString *)password2 success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 *  @brief 7.检测token有效性－这个app 暂时没用
 *
 *  @param success   成功block
 *  @param failure      失败block
 */
- (void)getCheckTokenWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 *  @brief 8.获取我的个人信息
 *
 *  @param success 成功block
 *  @param failure    失败block
 */
- (void)getMyInfomationWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 *  @brief 9.上传头像－这个app 暂时没用
 *
 *  @param dataAvatar   头像数据
 *  @param success 成功block
 *  @param failure    失败block
 */

- (void)uploadAvatar:(NSData *)dataAvatar success:(CompleteBlock)success failure:(ErrorBlock)failure;





/**
 *  @brief 10.上传第三发平台（阿里云／七牛）头像url地址到公司服务器
 *
 *  @param urlString   头像的url地址
 *  @param success 成功block
 *  @param failure    失败block
 */

- (void)uploadThirdAvatar:(NSString *)urlString success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 *  @brief  11.获取七牛云的token－这个工程没有使用
 */

- (void)getQiniuTokenWithUserId:(NSString *)userId success:(CompleteBlock)success failure:(ErrorBlock)failure;




/**
 *  @brief 12.保存（提交更改）用户信息
 *
 *  @param user     用户信息
 *  @param success 成功block
 *  @param failure    失败block
 */
//- (void)saveInfo:(UserModel *)user success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 *  @brief  13.我的中心额外显示数据－比如订单量，点赞数等－这个app 暂时没用
 */

- (void)getMyCenterInfoWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;




/**
 *  @brief 问题反馈(修改)
 *
 *  @param content     文本
 *  @param success 成功block
 *  @param failure    失败block
 */

- (void)uploadProblemWithContent:(NSString *)content  success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 *  @brief 关于我们(修改)
 *
 *  @param success 成功block
 *  @param failure    失败block
 */

- (void)getThisAppInformationWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;








#pragma mark - 2.0 新增接口

///**
// 100019_获取用户个人资料接口
//
// @param success 成功block
// @param failure 失败block
// */
//-(void)getUserPersonalDataWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;
//
//

/**
 010203_国家编码

 @param success 成功block
 @param failure 失败block
 */
-(void)getCountryCodesWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 100017_app帐号绑定微信接口

 @param code 微信服务端返回给客户端的CODE
 @param success 成功block
 @param failure 失败block
 */
-(void)postAppBindWechatWithCode:(NSString *)code Success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 100021_app账号解绑微信

 @param success 成功block
 @param failure 失败block
 */
-(void)postAppUnbindWechatWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 100018_app切换身份接口

 @param clientId 推送目标ID
 @param source 调用来源1-进入app 2-切换角色
 @param targetRole 新角色 商家－4，买家－2
 @param success success description
 @param failure failure description
 */
- (void)postChangeUserRoleWithClientId:(NSString *)clientId source:(WYTargetRoleSource)source targetRole:(WYTargetRoleType)targetRole success:( CompleteBlock)success failure:( ErrorBlock)failure;




/**
100022_手机号变更接口

 @param newPhone 更新后的新手机号码
 @param countryCode 国家区号
 @param verificationCode 验证码
 @param success 成功block
 @param failure 失败block
 */
- (void)postupdateUserPhone:(NSString *)newPhone countryCode:(NSString *)countryCode verificationCode:(NSString *)verificationCode success:(CompleteBlock)success failure:(ErrorBlock)failure;




/**
 100023_更换手机号时获取验证码

 @param phone 老手机号码
 @param countryCode 国家区号
 @param success 成功block
 @param failure 失败block
 */
- (void)getVeriCodeByUpdateOldPhone:(NSString *)phone countryCode:(NSString *)countryCode success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 100024_更换手机号时校验验证码

 @param phone 老手机号码
 @param countryCode 国家区号
 @param verificationCode 验证码
 @param success 成功block
 @param failure 失败block
 */
- (void)checkVeriCodeByUpdateOldPhone:(NSString *)phone countryCode:(NSString *)countryCode verificationCode:(NSString *)verificationCode success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 100025_app获取用户市场认证情况

 @param success 成功block
 @param failure 失败block
 */
- (void)getMarketQualiInfoWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/*************************测试接口***************************************************/

//测试
- (void)success:(CompleteBlock)success failure:(ErrorBlock)failure;


@end
