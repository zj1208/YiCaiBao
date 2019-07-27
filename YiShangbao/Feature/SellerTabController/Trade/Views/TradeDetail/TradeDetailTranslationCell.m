//
//  TradeDetailTranslationCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/6/6.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "TradeDetailTranslationCell.h"
#import "JLTextView.h"
@implementation TradeDetailTranslationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tranTitleLabel.text = @"";
    self.tranContentLabel.text = @"";
    
    [ self.tranContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tranTitleLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(self.tranContentLabel.superview.mas_left);
        make.right.mas_equalTo(self.tranContentLabel.superview.mas_right);
        make.bottom.mas_equalTo(self.tranContentLabel.superview.mas_bottom);
        make.height.mas_equalTo(0.f);
    }];
    
    //长按复制功能
//    self.tranTitleLabel.isNeedCopy = YES;
//    self.tranContentLabel.isNeedCopy = YES;
//    WS(weakSelf);//此处复制标题+内容拼接到粘贴板
//    self.tranTitleLabel.textDidCopyHandler = ^(UILabel * _Nonnull label) {
//        NSMutableString *str = [NSMutableString stringWithFormat:@"%@\n%@", weakSelf.tranTitleLabel.text,weakSelf.tranContentLabel.text];
//        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//        [pboard setString:str];
//    };
//    self.tranContentLabel.textDidCopyHandler = ^(UILabel * _Nonnull label) {
//        NSMutableString *str = [NSMutableString stringWithFormat:@"%@\n%@", weakSelf.tranTitleLabel.text,weakSelf.tranContentLabel.text];
//        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//        [pboard setString:str];
//    };
    
    self.textView.delegate = self;
    self.textView.hidden = YES;
    self.textView.editable = NO;
    self.textView.scrollEnabled = NO;
    [self setTextViewAttributedText];
    

}
-(void)setData:(id)data
{
    TradeDetailModel *model = (TradeDetailModel *)data;
    if (model.translation ) {
        if (model.translation.count==2) {
            self.tranTitleLabel.text = model.translation.firstObject;
            self.tranContentLabel.text = model.translation.lastObject;
            
            [ self.tranContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.tranTitleLabel.mas_bottom).offset(10);
                make.left.mas_equalTo(self.tranContentLabel.superview.mas_left);
                make.right.mas_equalTo(self.tranContentLabel.superview.mas_right);
                make.bottom.mas_equalTo(self.tranContentLabel.superview.mas_bottom);
            }];
            self.textView.hidden = YES;
        }else{
            self.textView.hidden = NO;

            [ self.tranContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.tranTitleLabel.mas_bottom).offset(0);
                make.left.mas_equalTo(self.tranContentLabel.superview.mas_left);
                make.right.mas_equalTo(self.tranContentLabel.superview.mas_right);
                make.bottom.mas_equalTo(self.tranContentLabel.superview.mas_bottom);
                make.height.mas_equalTo(0.f);
            }];
        }
    }
}
-(void)setTextViewAttributedText
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"翻译好像出了点儿问题，点此重新翻译>>"];
    NSRange rangeAll = NSMakeRange(0, [attributedString string].length);
    NSRange range = [[attributedString string] rangeOfString:@"点此重新翻译>>"];
    UIFont *font = [UIFont systemFontOfSize:15.f];

    [attributedString addAttribute:NSFontAttributeName value:font range:rangeAll];

    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:rangeAll];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#42B5FF"] range:range];//对于超链接这样设置无效
    
    [attributedString addAttribute:NSLinkAttributeName value:@"microants://" range:range];
    
//    NSNumber *attOffset = @((21-font.lineHeight)/2.f);//居中该行
//    [attributedString addAttribute:NSBaselineOffsetAttributeName value:attOffset range:rangeAll];

    // 修改超链接文字的颜色
    self.textView.linkTextAttributes = @{
                                         NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#42B5FF"],
                                         };

    self.textView.attributedText = attributedString;
}
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:@"microants"]){
        NSLog(@"microants---------------点此重新翻译>>");
        if (self.delegate && [self.delegate respondsToSelector:@selector(jl_reloadTranslationWithCell:)]) {
            [self.delegate jl_reloadTranslationWithCell:self];
        }
         return NO;
     }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
