//
//  MessageSoundSetViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MessageSoundSetViewController.h"
#import "MessageModel.h"

@interface MessageSoundSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * mainTableview;

//data
@property (nonatomic, strong) SoundModel *model;
@end

@implementation MessageSoundSetViewController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI
- (void)creatUI{
    self.title =@"消息设置";
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    
    //tableview
    _mainTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_mainTableview];
    [_mainTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.height.equalTo(@(228));
        } else {
            make.top.equalTo(self.view.mas_top);
            make.height.equalTo(@(228.f+HEIGHT_NAVBAR));
        }
    }];
    
    UIView *line = [[UIView alloc] init];
    [self.view addSubview:line];
    line.backgroundColor = WYUISTYLE.colorLinegrey;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainTableview.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@0.5);
    }];
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    label.text = @"温馨提示：关闭语音提示后，则使用系统默认的提示音。";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1.0];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(13);
        make.left.equalTo(@15);
        make.width.equalTo(@(SCREEN_WIDTH-30));
    }];
    _mainTableview.bounces= NO;
    _mainTableview.dataSource = self;
    _mainTableview.delegate = self;
    _mainTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_mainTableview setSeparatorColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0]];
    [_mainTableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section == 1) {
        view.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"SwitchSetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"生意语音提示";
        UISwitch *sw=[[UISwitch alloc]init];
        sw.on = self.model.enableSubject.boolValue;
        [[NSUserDefaults standardUserDefaults] setObject:self.model.enableSubject forKey:EnableSubject];
        [[NSUserDefaults standardUserDefaults] synchronize];

        sw.onTintColor = [UIColor colorWithRed:1.0 green:0.43 blue:0.24 alpha:1.0];
        [sw addTarget:self action:@selector(switchBusinessChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=sw;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"粉丝语音提示";
        UISwitch *sw=[[UISwitch alloc]init];
        sw.on = self.model.enableFan.boolValue;
        [[NSUserDefaults standardUserDefaults] setObject:self.model.enableFan forKey:EnableFan];
        [[NSUserDefaults standardUserDefaults] synchronize];

        sw.onTintColor = [UIColor colorWithRed:1.0 green:0.43 blue:0.24 alpha:1.0];
        [sw addTarget:self action:@selector(switchFanChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=sw;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"访客语音提示";
        UISwitch *sw=[[UISwitch alloc]init];
        sw.on = self.model.enableVisitor.boolValue;
        [[NSUserDefaults standardUserDefaults] setObject:self.model.enableVisitor forKey:EnableVisitor];
        [[NSUserDefaults standardUserDefaults] synchronize];

        sw.onTintColor = [UIColor colorWithRed:1.0 green:0.43 blue:0.24 alpha:1.0];
        [sw addTarget:self action:@selector(switchVisitorChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=sw;
    }
    return cell;
}

#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark 切换开关转化事件
-(void)switchBusinessChange:(UISwitch *)sw{
    [self soundPushWithType:@"bussiness" switch:sw];
}
-(void)switchFanChange:(UISwitch *)sw{
    [self soundPushWithType:@"fan" switch:sw];
}
-(void)switchVisitorChange:(UISwitch *)sw{
    [self soundPushWithType:@"visitor" switch:sw];
}



-(void)soundPushWithType:(NSString *)type switch:(UISwitch *)sw{
    if ([type isEqualToString:@"bussiness"]) {
        _model.enableSubject = [NSNumber numberWithBool:sw.isOn];
    }
    if ([type isEqualToString:@"fan"]) {
        _model.enableFan = [NSNumber numberWithBool:sw.isOn];
    }
    if ([type isEqualToString:@"visitor"]) {
        _model.enableVisitor = [NSNumber numberWithBool:sw.isOn];
    }
    WS(weakSelf);
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    [[[AppAPIHelper shareInstance] getMessageAPI] updateSoundSettingWithSubject:[NSString stringWithFormat:@"%@",_model.enableSubject] fan:[NSString stringWithFormat:@"%@",_model.enableFan] visitor:[NSString stringWithFormat:@"%@",_model.enableVisitor] success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
    } failure:^(NSError *error) {
        [sw setOn:!sw.isOn];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}



-(void)initData{
    self.model = [[SoundModel alloc] init];
    [[[AppAPIHelper shareInstance] getMessageAPI] querySoundSettingWithSuccess:^(id data) {
        self.model = (SoundModel *)data;
        [self.mainTableview reloadData];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
    
    
}
@end
