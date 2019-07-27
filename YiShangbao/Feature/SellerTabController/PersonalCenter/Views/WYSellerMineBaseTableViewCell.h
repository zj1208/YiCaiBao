//
//  WYSellerMineBaseTableViewCell.h
//  YiShangbao
//
//  Created by light on 2017/10/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const WYSellerMineBaseTableViewCellID;

@interface WYSellerMineBaseTableViewCell : UITableViewCell

- (void)updateImageName:(NSString *)iconName name:(NSString *)name content:(NSString *)content showArrow:(BOOL)isShow;

- (void)updateImageName:(NSString *)iconName name:(NSString *)name content:(NSString *)content showArrow:(BOOL)isShow contentLeftImageName:(NSString *)imageName;

- (void)updateImageName:(NSString *)iconName name:(NSString *)name content:(NSString *)content showArrow:(BOOL)isShow contentRightImageName:(NSString *)imageName;

@end
