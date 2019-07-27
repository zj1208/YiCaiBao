//
//  BillPreviewLoadView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/3/2.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BillPreviewLoadView.h"

@implementation BillPreviewLoadView
-(instancetype)initWithXib
{
    BillPreviewLoadView* view = [[[NSBundle mainBundle] loadNibNamed:@"BillPreviewLoadView" owner:self options:nil] firstObject];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    view.loadCView.layer.masksToBounds = YES;
    view.loadCView.layer.cornerRadius = 5;
    return view;
}

@end
