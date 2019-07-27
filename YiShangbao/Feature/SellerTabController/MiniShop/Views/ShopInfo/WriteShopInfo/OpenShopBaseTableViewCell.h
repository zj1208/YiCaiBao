//
//  OpenShopBaseTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const OpenShopBaseTableViewCellID;

@interface OpenShopBaseTableViewCell : UITableViewCell

- (void)updateTitle:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder;

- (void)updateImageWithUrl:(NSString *)url;

@end
