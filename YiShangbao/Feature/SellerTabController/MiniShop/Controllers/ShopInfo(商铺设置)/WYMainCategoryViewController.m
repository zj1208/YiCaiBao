//
//  WYMainCategoryViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/3/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYMainCategoryViewController.h"
#import "WYTitleTagVIew.h"
#import "IMJIETagView.h"

#import "TMDiskManager.h"

@interface WYMainCategoryViewController ()<IMJIETagViewDelegate>

//类目头部
@property(nonatomic, strong)WYTitleTagVIew *view_title;
//标签选择
@property (nonatomic,strong)IMJIETagView *iMTagView;
//存储返回上级
@property (nonatomic, strong)TMDiskManager *diskManager;
//存放标签字典数组
@property (nonatomic, strong) NSMutableArray *dataDicArr;
//存放标签文字数组
@property (nonatomic,strong)NSMutableArray *dataMArr;
//存放最选中字典数组
@property(nonatomic, strong) NSMutableArray *selectDicArr;
//存放选中文字的数组
@property(nonatomic, strong) NSMutableArray *selectMArr;

@end

@implementation WYMainCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WYUISTYLE.colorBWhite;
    //初始化数组
    self.dataDicArr = [NSMutableArray array];
    self.dataMArr = [NSMutableArray array];
    self.selectDicArr = [NSMutableArray array];
    self.selectMArr = [NSMutableArray array];
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)creatUI{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:WYUISTYLE.colorMTblack forState:UIControlStateNormal];
    rightBtn.titleLabel.font = WYUISTYLE.fontWith28;
    [rightBtn sizeToFit];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    UIBarButtonItem *BtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem  = BtnItem;
    
    self.title = @"主营类目";
    
    [self zx_navigationItem_titleCenter];
    
    //title标题UI
    _view_title = [[WYTitleTagVIew alloc] init];
    [self.view addSubview:self.view_title];
    self.view_title.label_title.text = @"最多选择6个类目";
    self.view_title.image_left.image = [UIImage imageNamed:@"ic_leimu"];
    [self.view_title.image_left mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@13);
        make.height.equalTo(@13);
    }];
    [self.view_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(HEIGHT_NAVBAR);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@36);
    }];
    
    //标签组
    IMJIETagFrame *frame = [[IMJIETagFrame alloc] init];
    frame.tagsMinPadding = 10;
    frame.tagsMargin = 15;
    frame.tagsLineSpacing = 10;
    if (self.dataMArr.count) {
        frame.tagsArray = self.dataMArr;
    }

     self.iMTagView = [[IMJIETagView alloc] initWithFrame:CGRectMake(0, 50+HEIGHT_NAVBAR, SCREEN_WIDTH, 500)];
    self.iMTagView.clickbool = YES;
    self.iMTagView.borderSize = 0.5;
    self.iMTagView.clickborderSize = 0.5;
    self.iMTagView.tagsFrame = frame;
    self.iMTagView.clickBackgroundColor = [UIColor redColor];
    self.iMTagView.clickTitleColor = [UIColor redColor];
    self.iMTagView.clickStart = 1;
    self.iMTagView.numberClick = 6;
    self.iMTagView.delegate = self;
    [self.view addSubview:self.iMTagView];
    [self.iMTagView setClickArray:self.selectMArr];

}

-(void)initData{
    //获取二级类目
    //上级传递过来
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskShopManageInfoKey];
    self.diskManager = manager;
    
    ShopManagerInfoModel *model = (ShopManagerInfoModel *)[self.diskManager getData];
    
    if (model.sysCates.count>0)
    {
        self.selectDicArr = [NSMutableArray arrayWithArray:model.sysCates];
        for (SysCateModel *dic in self.selectDicArr) {
            [self.selectMArr insertObject:dic.n atIndex:0];
        }
    }
    
    [[[AppAPIHelper shareInstance] shopAPI] getSysCatesWithId:nil level:@2 success:^(id data) {
        [self.dataDicArr removeAllObjects];
        [self.dataMArr removeAllObjects];
        [self.dataDicArr addObjectsFromArray:data];
        
        for (SysCateModel *model in self.dataDicArr) {
            [self.dataMArr addObject:model.n];
        }
        [self creatUI];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}
-(void)rightBtnAction{
    [self.diskManager setPropertyImplementationValue:self.selectDicArr forKey:@"sysCates"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark select

-(void)IMJIETagView:(NSArray *)tagArray tag:(NSInteger)tag{
    [self.selectDicArr removeAllObjects];
    if (tagArray.count==6)
    {
        self.iMTagView.clickbool = NO;
        if (tag) {
            [self zhHUD_showErrorWithStatus:@"最多选择6个二级类目哦"];
        }
    }
    
    for(NSString *str in tagArray){
        for (SysCateModel *model in self.dataDicArr) {
            if ([model.n isEqualToString:self.dataMArr[str.intValue]]) {
                [self.selectDicArr addObject:model];
            }
        }
    }
    NSLog(@"%@",self.selectDicArr);
}
@end
