//
//  ProMListTableView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/10.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectBlock)(NSInteger index , NSString *title);
@interface ProMListTableView : UIView
@property(nonatomic,copy)DidSelectBlock didSelectBlock;

- (instancetype)initWithTitles:(NSArray *)titles;


+(void)dissmiss;
+(void)show:(ProMListTableView *)popListView touchBtn:(UIView *)sender offSet:(CGPoint)offSet didSelectBlock:(DidSelectBlock)didSelectBlock;

@end
