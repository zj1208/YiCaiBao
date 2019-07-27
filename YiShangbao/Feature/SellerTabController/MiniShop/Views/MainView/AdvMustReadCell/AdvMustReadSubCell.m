//
//  AdvMustReadSubCell.m
//  YiShangbao
//
//  Created by simon on 2017/12/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AdvMustReadSubCell.h"

@implementation AdvMustReadSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.numberOfLines = 2;
    self.titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(14)];
    self.detialLab.font =  [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12)];
}

-(void)setJLCycSrollCellData:(id)data
{
    ShopMustReadAdvModel* model = (ShopMustReadAdvModel *)data;
//    self.titleLab.text = model.title;
    self.detialLab.text = model.desc;
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LCDScale_iPhone6_Width(14)]}];
    self.titleLab.attributedText = attributed;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:AppPlaceholderShopImage];
    
    CGFloat picWidth = LCDScale_iPhone6_Width(60.f)*17.f/14;
    
    CGFloat contentWidth = LCDW -32-15-15-15-picWidth;
    NSRange range = NSMakeRange(0, self.titleLab.attributedText.length);
    NSDictionary *dic = [self.titleLab.attributedText attributesAtIndex:0 effectiveRange:&range];
    CGFloat textH = [self.titleLab.attributedText.string  boundingRectWithSize:CGSizeMake(contentWidth, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    UIFont *font = [dic objectForKey:NSFontAttributeName];
    NSInteger  lineCount = textH / font.lineHeight;
    self.detialLab.hidden = lineCount >1?YES:NO;
    if (lineCount>1)
    {
        [self.titleLab jl_setAttributedText:model.title withLineSpacing:LCDScale_iPhone6_Width(5)];
    }
}
@end
