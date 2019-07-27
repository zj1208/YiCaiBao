//
//  WYServiceTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceModel.h"
#import "ZXHorizontalPageCollectionView.h"

extern NSString *const WYServiceTableViewCellID;

@interface WYServiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (nonatomic, strong) ZXHorizontalPageCollectionView *itemPageView;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;//搜索按钮

/**

 @param menuModel 菜单
 @param notiArray 市场公告
 */
-(void)setMenuDic:(ServiceMenuModel*)menuModel notiArray:(NSArray*)notiArray;
@end
