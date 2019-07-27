//
//  ProductContentCell.m
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ProductContentCell.h"

@implementation ProductContentCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSMutableAttributedString *)titleLabelAttributedString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF5434"] range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    return attributedString;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.promptGoodsBtn setTitle:NSLocalizedString(@"现货", nil) forState:UIControlStateNormal];
    [self.noPromptGoodsBtn setTitle:NSLocalizedString(@"订做", nil) forState:UIControlStateNormal];

    self.productSourceLab.attributedText = [self titleLabelAttributedString: NSLocalizedString(@"*货源类型:", nil)];

    
    UIImage *selectImage =[UIImage imageNamed:@"ic_xuanzhong"];
    UIImage *noSelectImage = [UIImage imageNamed:@"ic_weixuanzhong"];
    NSArray *subviews = @[self.noPromptGoodsBtn,self.promptGoodsBtn];
    [subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)obj;
            [btn setImage:noSelectImage forState:UIControlStateNormal];
            [btn setImage:selectImage forState:UIControlStateSelected];
            [btn setTitleColor:WYUISTYLE.colorMred forState:UIControlStateSelected];
        }
    }];
    self.noPromptGoodsBtn.tag = 100;
    self.goodsSelectBtn = self.noPromptGoodsBtn;
    self.goodsSelectBtn.selected = YES;
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    
//    [self.actualPriceBtn setImage:noSelectImage forState:UIControlStateNormal];
//    [self.actualPriceBtn setImage:selectImage forState:UIControlStateSelected];
//    [self.actualPriceBtn setTitleColor:WYUISTYLE.colorMred forState:UIControlStateSelected];
//
//    [self.priceNegotiableBtn setImage:noSelectImage forState:UIControlStateNormal];
//    [self.priceNegotiableBtn setImage:selectImage forState:UIControlStateSelected];
//    [self.priceNegotiableBtn setTitleColor:WYUISTYLE.colorMred forState:UIControlStateSelected];
//
//
//
//    self.priceSelectBtn = self.priceNegotiableBtn;
//    self.priceNegotiableBtn.tag =200;
//    self.priceSelectBtn.selected = YES;
//
//
//    self.customPriceField.userInteractionEnabled = self.actualPriceBtn.selected;

//    self.orderCountField.delegate = self;
//    self.unitField.delegate = self;
//    self.customPriceField.delegate =self;
//
//    if (IS_IPHONE_6P)
//    {
//        self.priceRightLayout.constant =47;
//        self.goodsRightLayout.constant = 94;
//    }
//    else
//    {
//        self.priceRightLayout.constant =17;
//        self.goodsRightLayout.constant = 64;
//    }
}

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:self.unitField];
//}

//- (void)inputUnitField:(NSNotification *)notification
//{
//    UITextField *textField = notification.object;
//    if ([textField isEqual:self.unitField])
//    {
//        self.unitLab.text = textField.text;
//    }
//}

- (void)setPromptGoodsWithButton:(UIButton *)sender
{
    if (sender != self.goodsSelectBtn)
    {
        self.goodsSelectBtn.selected = NO;
        self.goodsSelectBtn = sender;
    }
    self.goodsSelectBtn.selected = YES;
}

- (IBAction)getPromptGoodsAction:(UIButton *)sender{
    
    if (sender != self.goodsSelectBtn)
    {
        self.goodsSelectBtn.selected = NO;
        self.goodsSelectBtn = sender;
    }
    self.goodsSelectBtn.selected = YES;
    
    if ([self.goodsSelectBtn isEqual:self.promptGoodsBtn])
    {
        [self.diskManager setPropertyImplementationValue:@(1) forKey:@"sourceType"];
    }
    else
    {
        [self.diskManager setPropertyImplementationValue:@(2) forKey:@"sourceType"];
    }
}


//- (IBAction)getGoodsPriceAction:(UIButton *)sender {
//
//    if (sender != self.priceSelectBtn)
//    {
//        self.priceSelectBtn.selected = NO;
//        self.priceSelectBtn = sender;
//    }
//    self.priceSelectBtn.selected = YES;
//    self.customPriceField.userInteractionEnabled = self.actualPriceBtn.selected;
////    self.yuanLab.hidden = !self.actualPriceBtn.selected;
//    if (self.actualPriceBtn.selected)
//    {
//        self.customPriceField.textColor = WYUISTYLE.colorMred;
//    }
//    else
//    {
//        self.customPriceField.textColor = WYUISTYLE.colorLTgrey;
//    }
//
//}

- (NSInteger)getGoodsPromptType
{
    WYPromptGoodsType promptType = WYPromptGoodsType_NO;
    
    switch (self.goodsSelectBtn.tag)
    {
        case 100:promptType =WYPromptGoodsType_NO;  break;
            
        default:promptType =WYPromptGoodsType_YES;
            break;
    }
    return promptType;
}


//- (NSString *)getSelectedTradePrice
//{
//    NSString *price = @"-1";
//
//    switch (self.priceSelectBtn.tag)
//    {
//        case 200:price =@"-1";  break;
//
//        default:
//            price = self.customPriceField.text;
//
//            break;
//    }
//    return price;
//
//}


//#define MAXLENGTH 9
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == self.customPriceField)
//    {
//        return [UITextField xm_limitPayMoneyDot:textField shouldChangeCharactersInRange:range replacementString:string dotPreBits:8 dotAfterBits:2];
//    }
//    else if (textField ==self.orderCountField)
//    {
//        if (range.location>= MAXLENGTH)         {
//            textField.text = [textField.text substringToIndex:MAXLENGTH];
//            return NO;
//        }
//        return YES;
//
//    }
//
//    return YES;
//}


@end
