//
//  ProMScreeningView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ProMScreeningView.h"

@implementation ProMScreeningView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self buildUI];
    }
    return self;
}
-(void)buildUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 90, 45)];
    [self.timeBtn setTitle:@"上传时间" forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[WYUISTYLE colorWithHexString:@"#868686"] forState:UIControlStateNormal];
    [self.timeBtn setImage:[UIImage imageNamed:@"ic_jiantou1"] forState:UIControlStateNormal];
    [self.timeBtn setImage:[UIImage imageNamed:@"ic_jiantou2"] forState:UIControlStateSelected];
    self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.timeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 75, 0, 0)];
    [self.timeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0,0)];
    self.timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.timeBtn.adjustsImageWhenHighlighted = NO;
    [self.timeBtn addTarget:self action:@selector(ClickButtonDidChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.timeBtn];

    
    self.mainSelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-90-15, 0, 90, 45)];
    [self.mainSelBtn setTitle:@"只看主营" forState:UIControlStateNormal];
    [self.mainSelBtn setTitleColor:[WYUISTYLE colorWithHexString:@"#868686"] forState:UIControlStateNormal];
    [self.mainSelBtn setImage:[UIImage imageNamed:@"produce_unchosed"] forState:UIControlStateNormal];
    [self.mainSelBtn setImage:[UIImage imageNamed:@"produce_chosed"] forState:UIControlStateSelected];
    self.mainSelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.mainSelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 70)];
    [self.mainSelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0,0)];
    self.mainSelBtn.adjustsImageWhenHighlighted = NO;
    [self.mainSelBtn addTarget:self action:@selector(ClickButtonDidChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.mainSelBtn];
    
}
-(void)ClickButtonDidChange:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(wy_proMScreeningView:shouldChangeSelected:)]) {
        BOOL bo = [self.delegate wy_proMScreeningView:self shouldChangeSelected:sender];
        if (bo) {
            sender.selected = !sender.selected;
            if (self.delegate && [self.delegate respondsToSelector:@selector(wy_proMScreeningView:didChangeTimeBtnSelected:mainSelBtnSelected:changeTime:)]) {
              
                BOOL ischangeTime = sender==self.timeBtn?YES:NO;
                [self.delegate wy_proMScreeningView:self didChangeTimeBtnSelected:self.timeBtn.selected mainSelBtnSelected:self.mainSelBtn.selected changeTime:ischangeTime];
            }
        }
    }else{
        sender.selected = !sender.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(wy_proMScreeningView:didChangeTimeBtnSelected:mainSelBtnSelected:changeTime:)]) {
            
            BOOL ischangeTime = sender==self.timeBtn?YES:NO;
            [self.delegate wy_proMScreeningView:self didChangeTimeBtnSelected:self.timeBtn.selected mainSelBtnSelected:self.mainSelBtn.selected changeTime:ischangeTime];
        }
    }
    
}
@end
