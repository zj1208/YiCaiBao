//
//  ManageMainProController.m
//  YiShangbao
//
//  Created by simon on 17/2/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ManageMainProController.h"
#import "TMDiskManager.h"


@interface ManageMainProController ()

@property (nonatomic, strong)TMDiskManager *diskManager;

@property (weak, nonatomic) IBOutlet UILabel *remainLab;


@end

@implementation ManageMainProController

static NSString *editTagsCell = @"editTagsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
//    

    
    [self xm_navigationItem_titleCenter];
    
    self.textView.text = nil;
    _remainLab.text =@"还可输入300字";
    self.textView.placeholder = @"多个主营产品用“逗号”隔开，请勿输入其他符号;";
    WS(weakSelf);
    [self.textView setMaxCharacters:300 textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
        
        //        NSLog(@"%ld",remainCount);
        weakSelf.remainLab.text = [NSString stringWithFormat:@"还可输入%ld字",remainCount];
    }];

    [self setData];


}

- (void)setData
{

    //获取本地数据表管理器
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskShopManageInfoKey];
    self.diskManager = manager;
    ShopManagerInfoModel *model = (ShopManagerInfoModel *)[self.diskManager getData];
    if (![NSString zhIsBlankString:model.mainSell])
    {
        self.textView.text = model.mainSell;
    }

   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveBarItemAction:(UIBarButtonItem *)sender {
    
    if (![NSString zhIsBlankString:self.textView.text])
    {
        [self.diskManager setPropertyImplementationValue:self.textView.text forKey:@"mainSell"];
    }
    else
    {
        [self zhHUD_showErrorWithStatus:@"请填写主营产品"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
