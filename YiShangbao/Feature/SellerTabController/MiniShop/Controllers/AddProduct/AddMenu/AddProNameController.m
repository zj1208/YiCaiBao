//
//  AddProNameController.m
//  YiShangbao
//
//  Created by simon on 17/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  产品名称

#import "AddProNameController.h"
#import "TMDiskManager.h"
#import "AddProductModel.h"
#import "WYLoginViewController.h"

static NSInteger MAXLENGTH =60;

//敏感词过滤 没有写


@interface AddProNameController ()

@property (nonatomic, strong) TMDiskManager *diskManager;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation AddProNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"产品名称", nil);

    self.textView.text = nil;
    self.textView.placeholder = @"请输入产品名称";
    WS(weakSelf);
//    [self.textView setMaxCharacters:MAXLENGTH textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
//
//        weakSelf.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",(long)remainCount];
//
//    }];
    self.textView.maxLength = MAXLENGTH;
    self.textView.sizeToFitHight = YES;
    [self.textView addTextDidChangeHandler:^(JLTextView * _Nonnull view, NSUInteger curryLength) {
        NSInteger reminder = (NSInteger) MAXLENGTH-(NSInteger)curryLength;
        reminder<0?reminder =0 :reminder;
        weakSelf.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%ld字符",reminder];
    }];
    [self.textView addTextHeightDidChangeHandler:^(JLTextView * _Nonnull view, CGFloat textHeight) {
        weakSelf.heightLayout.constant = textHeight+1.f;
    }];
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
   
    NSString *str = [NSString zhFilterInputTextWithWittespaceAndLine:model.name];
    if (![NSString zhIsBlankString:str])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = str; //在8、10系统小手机上发现输入@“2018新款希望9449499。。”类似，然后换行第三行对其“望”字系统计算反而是恰好两行，单独写个demo算的是三行、而这里很奇怪，TMDiskManager？
        });
    }
//   self.heightLayout.constant = LCDScale_iPhone6_Width(44.f);
//    self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",(long)(MAXLENGTH-str.length)];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
//    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];

}

- (void)dealloc
{
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.height.equalTo(@(LCDScale_iPhone6_Width(44.f)));
//        
//    }];
//    NSLog(@"%@,%@",NSStringFromUIEdgeInsets(self.textView.textContainerInset) ,NSStringFromCGSize(self.textView.contentSize));

}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    WS(weakSelf);
//   return [UITextField zx_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:MAXLENGTH remainTextNum:^(NSInteger remainLength) {
//         weakSelf.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",remainLength];
//
//      }];
//}




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

- (IBAction)saveBarItemAction:(UIBarButtonItem *)sender {
    
    
    if ([NSString zhIsBlankString:self.textView.text])
    {
        [MBProgressHUD zx_showError:@"请填写产品名称" toView:self.view];
        return;
    }
    else if ([NSString zhFilterSpecialCharactersInString:self.textView.text].length<5)
    {
        [MBProgressHUD zx_showError:@"产品名称不能少于5个字噢～" toView:self.view];
        return;
    }
    NSString *str = [NSString zhFilterInputTextWithWittespaceAndLine:self.textView.text];
    [self.diskManager setPropertyImplementationValue:str forKey:@"name"];
    [self.navigationController popViewControllerAnimated:YES];

}


@end
