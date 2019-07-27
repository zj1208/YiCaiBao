//
//  ShopNoticeView.m
//  YiShangbao
//
//  Created by 何可 on 2017/3/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopNoticeView.h"
#import "UITextView+PlaceHolder.h"
#define MAX_LIMIT_NUMS     35
@implementation ShopNoticeView


- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.viewBg = [[UIView alloc] init];
    [self addSubview:self.viewBg];
    self.viewBg.backgroundColor = WYUISTYLE.colorBWhite;
    
    self.textContent = [[UITextView alloc] init];
    [self addSubview:self.textContent];
    self.textContent.font = WYUISTYLE.fontWith28;
    self.textContent.textColor = WYUISTYLE.colorMTblack;
    self.textContent.layer.cornerRadius = 5.0f;
    self.textContent.layer.borderColor = WYUISTYLE.colorLinegrey.CGColor;
    self.textContent.layer.borderWidth = 0.5;
    self.textContent.delegate = self;
    [self.textContent addPlaceHolder:@"有什么最新的消息，第一时间告诉采购商～"];
    
    self.lblChart = [[UILabel alloc] init];
    [self addSubview:self.lblChart];
    self.lblChart.font = WYUISTYLE.fontWith24;
    self.lblChart.textColor = WYUISTYLE.colorMred;
    self.lblChart.text = @"还可输入35字";

    self.btn_confirm = [[UIButton alloc] init];
    [self addSubview:self.btn_confirm];
    self.btn_confirm.backgroundColor = WYUISTYLE.colorMred;
    [self.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
    [self.btn_confirm setTitle:@"发布公告" forState:UIControlStateNormal];
    [self.btn_confirm.titleLabel setFont:WYUISTYLE.fontWith36];
    [self.btn_confirm.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.btn_confirm.layer.cornerRadius = 18.f;
    
    [self.viewBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@(HEIGHT_NAVBAR));
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@170);
    }];
    
    [self.textContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(self.viewBg.mas_top).offset(14);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@130);
    }];
    
    [self.lblChart mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.top.equalTo(self.textContent.mas_bottom).offset(6);
    }];
    
    [self.btn_confirm mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewBg.mas_bottom).offset(50);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@200);
        make.height.equalTo(@36);
    }];
    
    return self;
}




- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.lblChart.text = [NSString stringWithFormat:@"还可输入0字"];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
    self.lblChart.text = [NSString stringWithFormat:@"还可输入%ld字",MAX(0,MAX_LIMIT_NUMS - existTextNum)];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.textContent hiddenplaceHolderTextView];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text && [textView.text isEqualToString:@""]) {
        [self.textContent appearplaceHolderTextView];
    }
}


#pragma mark - 初始化
-(void)initUI:(id)data{
    NSString *content = [data objectForKey:@"content"];
    if (content.length) {
        self.textContent.text = content;
        self.lblChart.text = [NSString stringWithFormat:@"还可输入%ld字",((long)MAX_LIMIT_NUMS-content.length)];
        [self.textContent hiddenplaceHolderTextView];
    }
}

@end
