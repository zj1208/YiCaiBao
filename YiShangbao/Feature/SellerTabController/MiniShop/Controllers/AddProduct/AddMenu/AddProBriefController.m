//
//  AddProBriefController.m
//  YiShangbao
//
//  Created by simon on 17/2/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AddProBriefController.h"
#import "TMDiskManager.h"
#import "AddProductModel.h"

//需要优化－textView
@interface AddProBriefController ()
@property (nonatomic, strong)TMDiskManager *diskManager;

@property (weak, nonatomic) IBOutlet UILabel *remainLab;
@end

@implementation AddProBriefController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"产品描述", nil);

    self.textView.text = nil;
    _remainLab.text = @"还可输入200字";
    self.textView.placeholder = @"可描述如产地、品牌、风格、尺寸、材质、出口国家、公司实力、产品优势等";
    WS(weakSelf);
    [self.textView setMaxCharacters:200 textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
       
//        NSLog(@"%ld",remainCount);
        weakSelf.remainLab.text = [NSString stringWithFormat:@"还可输入%ld字",remainCount];
    }];
    
//    self.textView.backgroundColor = [UIColor orangeColor];
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    
    if (![NSString zhIsBlankString:model.desc])
    {
        self.textView.text = model.desc;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
    

    [self.diskManager setPropertyImplementationValue:self.textView.text forKey:@"desc"];
    [self.navigationController popViewControllerAnimated:YES];

}
@end
