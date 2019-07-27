//
//  MyCustomerViewController.m
//  YiShangbao
//
//  Created by light on 2018/4/13.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MyCustomerViewController.h"
#import "MyCustomerTableViewCell.h"
#import "CCSelectedControl.h"
#import "LookMyCustomerController.h"

@interface MyCustomerViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger totalPage;

@property (weak, nonatomic) IBOutlet UIView *blankView;
@property (weak, nonatomic) IBOutlet UIButton *addByFansButton;
@property (weak, nonatomic) IBOutlet UIButton *addByVisitorButton;
@property (weak, nonatomic) IBOutlet UIButton *addByMessageButton;

@property (nonatomic, strong) CCSelectedControl *selectedControl;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation MyCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的客户";
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------buttonAction------
- (void)add{
    self.selectedControl.hidden = NO;
}

- (IBAction)addByFansAction:(id)sender {
    [[WYUtility dataUtil] routerWithName:@"microants://latentVisitor" withSoureController:self];
}

- (IBAction)addByVisitorAction:(id)sender {
    [[WYUtility dataUtil] routerWithName:@"microants://visitorList" withSoureController:self];
}

- (IBAction)addByMessageAction:(id)sender {
    [[WYUtility dataUtil] routerWithName:@"microants://messageCategory" withSoureController:self];
}

#pragma mark ------CCSelectedControlStateChange------
- (void)selectedControl:(CCSelectedControl *)control{
    if (control.selectedControlIndex == 0){
        [self addByFansAction:nil];
    }else if (control.selectedControlIndex == 1){
        [self addByVisitorAction:nil];
    }else if (control.selectedControlIndex == 2){
        [self addByMessageAction:nil];
    }
}

#pragma mark ------Request------
- (void)requestData{
    
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] userModelExtendAPI] getOnlineCustomerListWithPageNo:1 pageSize:10 success:^(id data, PageModel *pageModel) {
        weakSelf.array = [NSMutableArray array];
        [weakSelf.array addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.page = 1;
        weakSelf.totalPage = [pageModel.totalPage integerValue];
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }else{
            weakSelf.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(requestMoreData)];
        }
        if (weakSelf.array.count == 0){
            weakSelf.blankView.hidden = NO;
            weakSelf.addButton.hidden = YES;
        }else{
            weakSelf.blankView.hidden = YES;
            weakSelf.addButton.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.array = [NSMutableArray array];
        [weakSelf.tableView reloadData];
        weakSelf.blankView.hidden = NO;
        weakSelf.addButton.hidden = YES;
    }];
}

- (void)requestMoreData{
    WS(weakSelf)
    
    [[[AppAPIHelper shareInstance] userModelExtendAPI] getOnlineCustomerListWithPageNo:self.page + 1 pageSize:10 success:^(id data, PageModel *pageModel) {
        [weakSelf.array addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.page ++;
        weakSelf.totalPage = [pageModel.totalPage integerValue];
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}


#pragma mark ------UITableviewDatasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCustomerTableViewCell *cell = (MyCustomerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyCustomerTableViewCellID forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell updateData:self.array[indexPath.row]];
    return cell;
}

#pragma mark ------UITableViewDelegate------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  65.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OnlineCustomerListModel *model = self.array[indexPath.row];

    LookMyCustomerController *vc = [[LookMyCustomerController alloc] init];
    vc.buyerBizId = [NSString stringWithFormat:@"%@",model.bizUid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    [MobClick event:kUM_b_myclientele_onclick];

}

#pragma mark- 点击滑动
//点击手势判断
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return NO;
        
    }
    return YES;
}

- (void)handleTapGesture:( UITapGestureRecognizer *)tapRecognizer{
    self.selectedControl.hidden = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.selectedControl.hidden = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.selectedControl.hidden = YES;
}

#pragma mark ------Private------
- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    sigleTapRecognizer.delegate = self;
    sigleTapRecognizer.numberOfTapsRequired = 1;
    [_tableView addGestureRecognizer:sigleTapRecognizer];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    [button setImage:[UIImage imageNamed:@"ic_add people"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.addButton = button;
    self.addButton.hidden = YES;
    
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5247].CGColor, nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, 215 , 45);
    gradientLayer.colors = colors;
    [self.addByFansButton.layer insertSublayer:gradientLayer atIndex:0];
    self.addByFansButton.layer.cornerRadius = 22.5;
    self.addByFansButton.layer.masksToBounds = YES;
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1, 0);
    gradientLayer2.frame = CGRectMake(0, 0, 215 , 45);
    gradientLayer2.colors = colors;
    [self.addByMessageButton.layer insertSublayer:gradientLayer2 atIndex:0];
    self.addByMessageButton.layer.cornerRadius = 22.5;
    self.addByMessageButton.layer.masksToBounds = YES;
    
    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
    gradientLayer3.startPoint = CGPointMake(0, 0);
    gradientLayer3.endPoint = CGPointMake(1, 0);
    gradientLayer3.frame = CGRectMake(0, 0, 215 , 45);
    gradientLayer3.colors = colors;
    [self.addByVisitorButton.layer insertSublayer:gradientLayer3 atIndex:0];
    self.addByVisitorButton.layer.cornerRadius = 22.5;
    self.addByVisitorButton.layer.masksToBounds = YES;
    
    self.blankView.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.selectedControl.hidden = YES;
}


#pragma mark- GetterAndSetter
- (CCSelectedControl *)selectedControl{
    if (!_selectedControl) {
        _selectedControl = [[CCSelectedControl alloc]init];
        _selectedControl.titles = @[@"从粉丝添加",@"从访客添加",@"从消息添加"];
        [self.view addSubview:_selectedControl];
        [_selectedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.right.equalTo(self.view);
            make.width.equalTo(@150);
            make.height.equalTo(@300);
        }];
        [_selectedControl addTarget:self action:@selector(selectedControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _selectedControl;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
