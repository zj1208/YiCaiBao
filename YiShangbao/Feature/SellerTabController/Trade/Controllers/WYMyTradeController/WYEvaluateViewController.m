//
//  WYEvaluateViewController.m
//  YiShangbao
//
//  Created by Lance on 16/12/6.
//  Copyright © 2016年 com.Microants. All rights reserved.
//
//MARK: ------ 废弃类

#import "WYEvaluateViewController.h"
#import "IMJIETagView.h"
#import "StarView.h"
#import "ZXTitleView.h"
#import "BRPlaceholderTextView.h"
#import "WYStarWithScoreView.h"
#import "WYStarCommentView.h"

#import "WYTradeModel.h"
@interface WYEvaluateViewController ()<IMJIETagViewDelegate,FMLStarViewDelegate>

@property (nonatomic,strong)IMJIETagView *iMTagView;
@property (nonatomic, strong) BRPlaceholderTextView *textView;

@property(nonatomic, strong)MyEvaluateModel *model;
@property(nonatomic, strong)NSString *tags;
@property(nonatomic, strong)NSMutableArray *strarr;
@end

@implementation WYEvaluateViewController

#pragma mark lift cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self initData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


-(void)initData{
//    if (![UserInfoUDManager isLogin])
//    {
//        return;
//    }
//    [[[AppAPIHelper shareInstance] getTradeMainAPI] getTradeInitEvaluateInfoWithIdentityType:@4 success:^(id data) {
//        self.model = data;
//        self.tags = @"";
//        [self creatUI];
//    } failure:^(NSError *error) {
//
//        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
//
//    }];
}

- (void)creatUI{
    //tab
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    self.title = NSLocalizedString(@"评价", nil);
    //五星
    UIView *starBg =[UIView new];
    starBg.backgroundColor = WYUISTYLE.colorBWhite;
    [self.view addSubview:starBg];
    
    WYStarCommentView * starcommentView = [[WYStarCommentView alloc] initWithFrame:CGRectZero
                                                                           title:@"整体评价"
                                                                   numberOfStars:5
                                                                     isTouchable:YES
                                                                    currentScore:self.model.score.integerValue/2
                                                                      totalScore:5
                                                               isFullStarLimited:YES
                                                                           index:100
                                                                        delegate:self];
    [starBg addSubview:starcommentView];

    __weak __typeof(&*self)weakSelf = self;

    [starBg mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(weakSelf.view.mas_top).offset(76);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.equalTo(@50);
    }];

    [starcommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(starBg.mas_top).offset(12);
        make.left.equalTo(starBg.mas_left).offset(12);
        make.height.equalTo(@25);
        make.width.equalTo(@230);
    }];
    
    //选择标签title
    ZXTitleView *titleLab = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] firstObject];
    titleLab.titleLab.text =@"选择标签";
    [self.view addSubview:titleLab];
    
    UILabel * mostLab =[UILabel new];
    mostLab.font =[UIFont systemFontOfSize:12];
    mostLab.textColor = WYUISTYLE.colorSTgrey;
    mostLab.text =@"(最多三个)";
    [self.view addSubview:mostLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker * make){
        make.top.equalTo (starBg.mas_bottom).offset(12);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(81, 14));
    }];
    [mostLab mas_makeConstraints:^(MASConstraintMaker * make){
        make.left.equalTo(titleLab.mas_right);
        make.top.equalTo(starBg.mas_bottom).offset(13);
        make.size.mas_equalTo(CGSizeMake(74, 14));
    }];
    
    //标签背景
    UIView * bottleBg =[[UIView alloc]initWithFrame:CGRectMake(0, 98+64, SCREEN_WIDTH, 270)];
    [self.view addSubview:bottleBg];
    bottleBg.backgroundColor =WYUISTYLE.colorBWhite;
    _strarr = [NSMutableArray new];
    EvatipModel *obj =[[EvatipModel alloc] init];
    //标签
    
    for(obj in self.model.labels){
        [_strarr addObject:obj.name];
    }

    IMJIETagFrame *frame = [[IMJIETagFrame alloc] init];
    frame.tagsMinPadding = 4;
    frame.tagsMargin = 10;
    frame.tagsLineSpacing = 10;
    frame.tagsArray = _strarr;
    
    IMJIETagView *tagView = [[IMJIETagView alloc] initWithFrame:CGRectMake(0, 98+64, SCREEN_WIDTH, frame.tagsHeight)];
    tagView.clickbool = YES;
    tagView.borderSize = 0.5;
    tagView.clickborderSize = 0.5;
    tagView.tagsFrame = frame;
    tagView.clickBackgroundColor = [UIColor lightGrayColor];
    tagView.clickTitleColor = [UIColor redColor];
    tagView.clickStart = 1;
    tagView.numberClick = 3;
    tagView.delegate = self;
    [self.view addSubview:tagView];
    self.iMTagView = tagView;
    
    
    BRPlaceholderTextView *view=[[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(12, tagView.frame.size.height+tagView.frame.origin.y, SCREEN_WIDTH -12*2, 130)];
    if(self.model.descrptiontext){
        view.placeholder = self.model.descrptiontext;
    }else{
        view.placeholder=@"请留下您的其他意见、建议或反馈(内容不展示，可放心填写)";
    }
    view.font=[UIFont boldSystemFontOfSize:12];
    view.layer.borderColor=[UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 0.5;
    view.layer.masksToBounds= YES;
    view.layer.cornerRadius = 5.0;
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowColor =WYUISTYLE.colorSTgrey.CGColor;
    
    [self.textView removeFromSuperview];
    self.textView = view;
    [self.view addSubview:view];
    
    [view setPlaceholderColor:WYUISTYLE.colorSTgrey];
    [view setPlaceholderOpacity:0.6];
    [view addMaxTextLengthWithMaxLength:100 andEvent:^(BRPlaceholderTextView *text) {
        self.model.descrptiontext = text.text;
        NSLog(@"----------");
    }];
    [view addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"begin");
    }];
    [view addTextViewEndEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"end");
    }];

    
    UIButton * submitBtn =[UIButton new];
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:CGSizeMake(200, 36) startColor:UIColorFromRGB(255.f, 67.f, 82.f) endColor:UIColorFromRGB(243.f, 19.f, 37.f)];
    [submitBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
//    [submitBtn addTarget:self action:@selector(submitTip) forControlEvents:UIControlEventTouchUpInside];
//    submitBtn.backgroundColor = WYUISTYLE.colorMred;
    [submitBtn setTitle:NSLocalizedString(@"提交评价", nil)   forState:UIControlStateNormal];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius =18.0;
    [self.view addSubview:submitBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker * make){
        make.top.mas_equalTo(bottleBg.mas_bottom).offset(52);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 36));
    }];

}

#pragma mark - FMLStarViewDelegate

- (void)fml_didClickStarViewByScore:(CGFloat)score atIndex:(NSInteger)index {
    self.model.score = [NSNumber numberWithFloat:score*2];
    NSLog(@"score: %f  index：%zd", score, index);
}


#pragma mark select

-(void)IMJIETagView:(NSArray *)tagArray tag:(NSInteger)tag{
    self.tags = @"";
    if (tagArray.count==3)
    {
        self.iMTagView.clickbool = NO;
    }
    for(NSString *str in tagArray){
        NSLog(@"%@",str);
        NSLog(@"%@",tagArray);
        
        for (EvatipModel *Emodel in self.model.labels) {
            if ([Emodel.name isEqualToString:_strarr[str.intValue]]) {
                if([self.tags length] !=0) {
                    self.tags = [self.tags stringByAppendingString:@","];
                }
                self.tags = [self.tags stringByAppendingString:Emodel.value];
            }
        }
    }
        
        
        
//        if([self.tags length] !=0) {
//            self.tags = [self.tags stringByAppendingString:@","];
//        }
//        self.tags = [self.tags stringByAppendingString:_strarr[str.intValue]];
//    }
    NSLog(@"%@",self.tags);
}


//-(void)submitTip{
////    if (self.model.score.integerValue == 0) {
////        [self zhHUD_showErrorWithStatus:@"请先评星级哦～"];
////        return;
////    }
//    if (!self.tags.length) {
//        [self zhHUD_showErrorWithStatus:@"请选择标签"];
//        return;
//    }
//    [[[AppAPIHelper shareInstance] getTradeMainAPI] postTradeCommentWithPostId:self.postId content:self.model.descrptiontext starNum:self.model.score tag:self.tags identityType:@4 success:^(id data) {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Trade_evaluating object:nil userInfo:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//    } failure:^(NSError *error) {
//        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
//    }];
//    
//}

@end
