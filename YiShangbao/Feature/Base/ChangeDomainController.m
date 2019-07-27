//
//  ChangeDomainController.m
//  YiShangbao
//
//  Created by simon on 17/4/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ChangeDomainController.h"

@interface ChangeDomainController ()

@property (weak, nonatomic) IBOutlet UIButton *developBtn;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (weak, nonatomic) IBOutlet UIButton *onlineBtn;

@property(nonatomic)ChangeDomainType domainType;

@property (nonatomic, copy)NSArray *wantTypeArray;

- (IBAction)domainChangeAction:(UIButton *)sender;



@end

@implementation ChangeDomainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.developBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    [self.developBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.developBtn.tag = 200;
    
    [self.testBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    [self.testBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.testBtn.tag = 201;
    
    [self.onlineBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    [self.onlineBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.onlineBtn.tag = 202;
    
    self.wantTypeArray = @[self.developBtn,self.testBtn,self.onlineBtn];
    self.developBtn.selected = YES;
    
    
    [self addObserver:self forKeyPath:@"domainType" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    
    NSString *appURL = [WYUserDefaultManager getkAPP_BaseURL];
    
    if ([appURL isEqualToString:@"http://api.m-internal.s-ant.cn"])
    {
        self.developBtn.selected = YES;
        self.testBtn.selected = NO;
        self.onlineBtn.selected = NO;
    }
    else if ([appURL isEqualToString:@"http://api.m-internal.microants.com.cn"])
    {
        self.developBtn.selected = NO;
        self.testBtn.selected = YES;
        self.onlineBtn.selected = NO;
    }
    else if ([appURL isEqualToString:@"https://api.m.microants.cn"])
    {
        self.developBtn.selected = NO;
        self.testBtn.selected = NO;
        self.onlineBtn.selected = YES;
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:@"domainType"])
    {
        id domain = [self valueForKey:@"domainType"];
//        NSLog(@"%@",domain);
        
        switch ([domain integerValue]) {
            case ChangeDomainType_develop:
                [WYUserDefaultManager  setkAPP_BaseURL:@"http://api.m-internal.s-ant.cn"];
                [WYUserDefaultManager setkAPP_H5URL:@"http://wykj-internal.s-ant.cn"];
                [WYUserDefaultManager setkURL_WXAPPID:@"wxd3bbaab044a4bcb2"];
                [WYUserDefaultManager setkCookieDomain:@".s-ant.cn"];
                break;
            case ChangeDomainType_test:
                [WYUserDefaultManager  setkAPP_BaseURL:@"http://api.m-internal.microants.com.cn"];
                [WYUserDefaultManager setkAPP_H5URL:@"http://wykj-internal.microants.com.cn"];
                [WYUserDefaultManager setkURL_WXAPPID:@"wxd3bbaab044a4bcb2"];
                [WYUserDefaultManager setkCookieDomain:@".com.cn"];

                break;
            case ChangeDomainType_online:
                [WYUserDefaultManager  setkAPP_BaseURL:@"https://api.m.microants.cn"];
                [WYUserDefaultManager setkAPP_H5URL:@"https://wykj.microants.cn"];
                [WYUserDefaultManager setkURL_WXAPPID:@"wxc8edd69b7a7950ee"];
                [WYUserDefaultManager setkCookieDomain:@".microants.cn"];

            default:
                break;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUserChangeDomain object:nil];
        [self.navigationController popViewControllerAnimated:YES];

    }
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(domainType))];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)domainChangeAction:(UIButton *)sender {
    
    [self.wantTypeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        if (btn.tag ==sender.tag)
        {
            btn.selected = YES;
            switch (sender.tag)
            {
                case 200:self.domainType=ChangeDomainType_develop; break;
                case 201:self.domainType=ChangeDomainType_test; break;
                default:self.domainType=ChangeDomainType_online;
                    break;
            }
        }
        else
        {
            btn.selected = NO;
        }
    }];
    
}

@end
