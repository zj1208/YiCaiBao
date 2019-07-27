//
//  AddSpecsViewController.m
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AddSpecsViewController.h"

#import "TMDiskManager.h"
#import "AddProductModel.h"

//需要优化－textView
@interface AddSpecsViewController ()
@property (nonatomic, strong)TMDiskManager *diskManager;
@property (weak, nonatomic) IBOutlet UILabel *remainLab;

@end

@implementation AddSpecsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"规格尺寸", nil);
 
    [self setData];
    
}
- (void)dealloc
{
    
}

- (void)setData
{
    self.textView.text = nil;
    _remainLab.text =@"还可输入200字";
    self.textView.placeholder = @"请输入规格尺寸，多个尺寸用“逗号”分隔；";
    
    WS(weakSelf);
    [self.textView setMaxCharacters:200 textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
        
        //        NSLog(@"%ld",remainCount);
        weakSelf.remainLab.text = [NSString stringWithFormat:@"还可输入%ld字",(long)remainCount];
    }];
       
    //获取本地数据表管理器
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    
    if (![NSString zhIsBlankString:model.spec])
    {
        self.textView.text = model.spec;
    }
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

- (IBAction)savaBarItemAction:(UIBarButtonItem *)sender {
    
    [self.diskManager setPropertyImplementationValue:self.textView.text forKey:@"spec"];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
