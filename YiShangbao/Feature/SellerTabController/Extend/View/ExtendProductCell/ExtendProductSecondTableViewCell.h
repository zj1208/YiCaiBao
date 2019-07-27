//
//  ExtendProductSecondTableViewCell.h
//  YiShangbao
//
//  Created by 海狮 on 17/5/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXAddPicCollectionView.h"
@interface ExtendProductSecondTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) ZXAddPicCollectionView *picsCollectionView;

@end
