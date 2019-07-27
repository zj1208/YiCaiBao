//
//  MakeBillGoodsHeaderView.h
//  YiShangbao
//
//  Created by light on 2018/1/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MakeBillGoodsHeaderViewID;

@interface MakeBillGoodsHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *tapButton;

- (void)imageIsHideImage:(BOOL)isHide;

@end
