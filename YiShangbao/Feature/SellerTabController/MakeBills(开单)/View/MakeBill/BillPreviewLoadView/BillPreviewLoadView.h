//
//  BillPreviewLoadView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/3/2.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLProgressView.h"

@interface BillPreviewLoadView : UIView
@property (weak, nonatomic) IBOutlet JLProgressView *jlProgressView;
@property (weak, nonatomic) IBOutlet UIView *loadCView;

-(instancetype)initWithXib;

@end
