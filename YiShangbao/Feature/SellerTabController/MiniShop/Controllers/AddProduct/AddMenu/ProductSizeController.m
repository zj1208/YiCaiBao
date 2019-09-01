//
//  ProductSizeController.m
//  YiShangbao
//
//  Created by simon on 17/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
// 箱规

#import "ProductSizeController.h"
#import "TMDiskManager.h"
#import "AddProductModel.h"

@interface ProductSizeController ()<UITextFieldDelegate>

@property (nonatomic, strong)TMDiskManager *diskManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *volumnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitWidth;

@end

@implementation ProductSizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"箱规", nil);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.separatorColor = UIColorFromRGB(224.f, 224.f, 224.f);
    
    
    self.volumnWidth.constant = LCDScale_5Equal6_To6plus(120.f);
    self.weightWidth.constant = LCDScale_5Equal6_To6plus(120.f);
    self.numberWidth.constant = LCDScale_5Equal6_To6plus(75.f);
    self.unitWidth.constant = LCDScale_5Equal6_To6plus(75.f);
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    
    
    if (model.volumn)
    {
        if (![NSString zhIsBlankString:[model.volumn stringValue]])
        {
            self.volumnField.text =[model.volumn stringValue];
        }
    }
    if (model.weight)
    {
        if (![NSString zhIsBlankString:[model.weight stringValue]])
        {
            self.weightField.text =[model.weight stringValue];
        }
    }
    if (model.number && ![NSString zhIsBlankString:[model.number stringValue]])
    {
        self.numberField.text = [model.number stringValue];
    }
    if (![NSString zhIsBlankString:model.unitInBox])
    {
        self.unitInBoxField.text = model.unitInBox;
    }
    
}

- (void)dealloc
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LCDScale_5Equal6_To6plus(50.f);
}


#define MAXLENGTH 9
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField ==self.numberField)
    {
        return [UITextField zx_limitPayMoneyDot:textField shouldChangeCharactersInRange:range replacementString:string dotPreBits:9 dotAfterBits:2];
    }
//    else if (textField ==self.unitInBoxField)
//    {
//        if (range.location>= 5) //输入文字/删除文字后,但还没有改变textField时候的改变;
//        {
//            textField.text = [textField.text substringToIndex:5];
//            return NO;
//        }
//    }
    else if (textField == self.volumnField ||textField ==self.weightField)
    {
        return [UITextField zx_limitPayMoneyDot:textField shouldChangeCharactersInRange:range replacementString:string dotPreBits:5 dotAfterBits:3];
    }
    return YES;
}

- (IBAction)savaBarItemAction:(UIBarButtonItem *)sender {
    
    NSNumber *volumn = [NSString zhIsBlankString:self.volumnField.text]?nil:@([self.volumnField.text floatValue]);
    [self.diskManager setPropertyImplementationValue:volumn forKey:@"volumn"];

    NSNumber *weight = [NSString zhIsBlankString:self.weightField.text]?nil:@([self.weightField.text floatValue]);
    [self.diskManager setPropertyImplementationValue:weight forKey:@"weight"];


    NSNumber *number =[NSString zhIsBlankString:self.numberField.text]?nil:@([self.numberField.text doubleValue]);
    [self.diskManager setPropertyImplementationValue:number forKey:@"number"];

    NSString *unitInBox =[NSString zhIsBlankString:self.unitInBoxField.text]?nil:self.unitInBoxField.text;
    [self.diskManager setPropertyImplementationValue:unitInBox forKey:@"unitInBox"];
    
    [self.navigationController popViewControllerAnimated:YES];

}
@end
