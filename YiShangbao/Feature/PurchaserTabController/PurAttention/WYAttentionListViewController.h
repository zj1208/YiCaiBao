//
//  WYAttentionListViewController.h
//  YiShangbao
//
//  Created by light on 2018/5/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WYAttentionType) {
    WYAttentionTypeAll = 0,//所有关注
    WYAttentionTypeNew = 1,//上新
    WYAttentionTypeHot = 2,//热销
    WYAttentionTypeStock = 3,//库存
};

@interface WYAttentionListViewController : UIViewController

@property (nonatomic) WYAttentionType attentionType;
@property (nonatomic) BOOL isNeedReload;

- (void)reloadData;

@end
