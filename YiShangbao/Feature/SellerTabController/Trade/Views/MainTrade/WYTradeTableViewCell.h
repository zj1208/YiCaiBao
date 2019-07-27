//
//  WYTradeTableViewCell.m
//  YiShangbao
//
//  Created by simon on 17/1/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "ZXPhotosView.h"
#import "WYTradeModel.h"
#import "ZXImgIconsCollectionView.h"

@class WYTradeTableViewCell;
@protocol WYTradeListDelegate <NSObject>

- (void)haveTrade:(WYTradeTableViewCell *)cell;

@end


@interface WYTradeTableViewCell : BaseTableViewCell

// 用户头像
@property (weak, nonatomic) IBOutlet UIButton *headBtn;

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;

// 公司名字
@property (weak, nonatomic) IBOutlet UILabel *companyLab;

@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;
/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

//类型标识
@property (weak, nonatomic) IBOutlet UILabel *titleTypeLab;
//小圆点
@property (weak, nonatomic) IBOutlet UIImageView *dotImageView;

/**
 内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLab;


/**
 动态图的容器
 */
@property (weak, nonatomic) IBOutlet UIView *photoContainerView;

@property (nonatomic, weak) ZXPhotosView *photosView;

@property (weak, nonatomic) IBOutlet UILabel *leftTimeLab;//发布时间
@property (weak, nonatomic) IBOutlet UIButton *goTrade;    //交易按钮

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic,weak) id<WYTradeListDelegate>delegate;

//@property (nonatomic,strong) WYTradeModel *model;

@property (nonatomic,copy) void(^tradeBtnAction)(UITableViewCell *cell);
@end
