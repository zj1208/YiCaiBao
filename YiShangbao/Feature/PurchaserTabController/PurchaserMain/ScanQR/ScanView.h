//
//  ScanView.h
//  ScanTest
//
//  Created by QBL on 2017/3/21.
//  Copyright © 2017年 team.com All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ScanView : UIView
@property(nonatomic,strong)UIButton *lightButton;
- (instancetype)initWithFrame:(CGRect)frame leftEdge:(CGFloat)edge;
- (void)lineStartAnimation;
- (void)lineStopAnimation;
@end
