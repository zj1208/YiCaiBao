//
//  TradeOrderContentCell.m
//  YiShangbao
//
//  Created by simon on 17/1/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeOrderContentCell.h"

@implementation TradeOrderContentCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    

    UIImage *selectImage =[UIImage imageNamed:@"ic_xuanzhong"];
    UIImage *noSelectImage = [UIImage imageNamed:@"ic_weixuanzhong"];
//    NSArray *btnArray = @[self.noPromptGoodsBtn,self.promptGoodsBtn,self.priceNegotiableBtn,self.actualPriceBtn];
    NSArray *btnArray = @[self.noPromptGoodsBtn,self.promptGoodsBtn];

    
    [btnArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *btn = (UIButton *)obj;
        [btn zh_setImage:noSelectImage selectImage:selectImage titleColor:UIColorFromRGB_HexValue(0x666666) selectTitleColor:UIColorFromRGB_HexValue(0x666666)];
//        if (btn !=self.actualPriceBtn)
//        {
            [btn zh_centerHorizontalImageAndTitleWithTheirSpace:LCDScale_5Equal6_To6plus(10.f)];
 
//        }
    }];
    //定做，现货
    self.promptGoodsBtn.tag  =100;
    self.noPromptGoodsBtn.tag = 101;
    
//    产品单价
//    self.priceNegotiableBtn.tag =200;
//    self.actualPriceBtn.tag = 201;
    
    //定做
    [self.promptGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.width.mas_equalTo(LCDScale_5Equal6_To6plus(60.f));
 
    }];
//    //面议
//    [self.priceNegotiableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.width.mas_equalTo(LCDScale_5Equal6_To6plus(60.f));
//
//    }];
//

    _remaindLab.text = @"(0/150)";
    self.textView.text = nil;
    self.textView.textColor = UIColorFromRGB_HexValue(0x333333);
    self.textView.placeholderColor = UIColorFromRGB_HexValue(0x999999);
    self.textView.placeholder = NSLocalizedString(@"生意回复：如产品优势，生产优势，服务优势等。为了提高您的接单成功率，请您回复5个字以上内容噢～", nil);//描述详情，获取采购商信任。（接单内容只有对方可见)
    WS(weakSelf);
    [self.textView setMaxCharacters:150 textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
        
        NSUInteger curryCount = 150-remainCount;
        NSString *curryStr = [NSString stringWithFormat:@"%lu",(unsigned long)curryCount];
        NSString *descStr = [NSString stringWithFormat:@"(%@/150)",curryStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:descStr];

        if (curryCount>0) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#EC1E11"] range:NSMakeRange(1, curryStr.length)];
            
            weakSelf.remaindLab.attributedText = attributedString;
        }else{
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#CCCCCC"] range:NSMakeRange(0, descStr.length)];
            
            weakSelf.remaindLab.attributedText = attributedString;
        }
    }];
    
    [self.containerTextView setCornerRadius:4.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0x9D9D9D)];
    
    [self.containerTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(140.f));
        make.top.mas_equalTo(self.mas_top).offset(LCDScale_5Equal6_To6plus(5.f));
        
    }];
    //外商直采描述在小屏幕缩小字体
    if (LCDW<375.f) {
        self.foreignDescLabel.font = [UIFont systemFontOfSize:12.f];
    }
    
    
    [self.promptContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(45.f));
    make.top.mas_equalTo(self.containerTextView.mas_bottom).offset(LCDScale_5Equal6_To6plus(0.f));
    }];
    [self.priceContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(45.f));
        
    }];
    [self.orderContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(45.f));
        
    }];




//    self.textView.contentInset = UIEdgeInsetsMake(10, 15, 10, 15);
    
//    NSLog(@"%@",NSStringFromUIEdgeInsets(self.textView.contentInset));
 
    self.customPriceField.enableTextRectInset = NO;
    self.customPriceField.font = [UIFont systemFontOfSize:15];
    self.customPriceField.delegate = self;
//    self.customPriceField.userInteractionEnabled = self.actualPriceBtn.selected;
//    [self.customPriceField setCornerRadius:1.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    self.customPriceField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入价格，不填则展示为面议", nil) attributes:@{NSForegroundColorAttributeName:UIColorFromRGB_HexValue(0xCCCCCC),NSFontAttributeName:[UIFont systemFontOfSize:14]}];

    self.orderCountField.enableTextRectInset = NO;
    self.orderCountField.delegate = self;
    self.orderCountField.tintColor = [UIColor colorWithHexString:@"EC1E11"];
    self.orderCountField.font = [UIFont systemFontOfSize:15];
    self.orderCountField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入起订量及单位", nil) attributes:@{NSForegroundColorAttributeName:UIColorFromRGB_HexValue(0xCCCCCC),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
//    [self.orderCountField setCornerRadius:1.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];

}



- (IBAction)getPromptGoodsAction:(UIButton *)sender{
    
    if (sender != self.goodsSelectBtn)
    {
        self.goodsSelectBtn.selected = NO;
        self.goodsSelectBtn = sender;
    }
    self.goodsSelectBtn.selected = YES;
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
//}

- (NSInteger)getGoodsPromptType
{
    WYPromptGoodsType promptType = WYPromptGoodsType_NOSelect;
    
    switch (self.goodsSelectBtn.tag)
    {
        case 100:promptType =WYPromptGoodsType_NO;  break;
        case 101:promptType =WYPromptGoodsType_YES;break;
        default:promptType =WYPromptGoodsType_NOSelect;
            break;
    }
    return promptType;
}


- (NSString *)getSelectedTradePrice
{
    NSString *price = nil;
    if (![NSString zhIsBlankString:self.customPriceField.text])
    {
        price = self.customPriceField.text;
    }
    else
    {
       price =@"-1";
    }
//    switch (self.priceSelectBtn.tag)
//    {
//        case 200:price =@"-1";  break;
//        case 201: price = self.customPriceField.text;
//            break;
//        default:
//            price = nil;
//
//            break;
//    }
    return price;
}


#define MAXLENGTH 12
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField ==_orderCountField)
    {
        if (range.location>= MAXLENGTH)         {
            textField.text = [textField.text substringToIndex:MAXLENGTH];
            return NO;
        }
        return YES;
    }
    return [UITextField xm_limitPayMoneyDot:textField shouldChangeCharactersInRange:range replacementString:string dotPreBits:9 dotAfterBits:2];
}


@end
