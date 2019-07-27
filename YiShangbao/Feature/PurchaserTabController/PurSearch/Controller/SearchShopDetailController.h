//
//  SearchShopDetailController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/9/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewMoveUpDownProtocol.h"

@interface SearchShopDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *shangpushaixuanBackView;//商铺筛选容器
@property (weak, nonatomic) IBOutlet UIButton *shangpuAuthStatusBtn;//商铺认证状态《已认证》
@property (weak, nonatomic) IBOutlet UIButton *maoyileixingBtn;//贸易类型
@property (weak, nonatomic) IBOutlet UIButton *shichangquyuLookBtn;//按市场区域查看

@property (weak, nonatomic) IBOutlet UICollectionView *shopCollectionView;
@property (nonatomic,weak) id<ScrollViewMoveUpDownProtocol>delegate;

//****跳转需要传入参数*******
@property(nonatomic,strong)NSString*searchKeyword;//搜索关键词，类目搜索的情况设置为类目名称
@property(nonatomic,assign)NSInteger keywordType;//关键词类型 0-搜索 1-类目 2-产品（猜你想找）
@property(nonatomic,strong)NSNumber*catId;//类目id（只有在类目搜索的情况下才需要设置，其他情况为空）

-(void)removeWYSelectedTableViewIfNeed;
@end
