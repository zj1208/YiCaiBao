//
//  ServiceHeadView.h
//  YiShangbao
//
//  Created by 何可 on 2017/5/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceHeadView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, strong) UIView *line;

-(void)headViewUITitle:(NSString *)title;

@end
