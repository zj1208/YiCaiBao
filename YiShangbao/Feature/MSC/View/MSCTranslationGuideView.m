//
//  MSCTranslationGuideView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/31.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MSCTranslationGuideView.h"

@implementation MSCTranslationGuideView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.bottomLayoutC.constant = HEIGHT_TABBAR_SAFE;
}
- (IBAction)clickBtn:(UIButton *)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
