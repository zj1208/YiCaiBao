//
//  WYCollectionView.h
//  YiShangbao
//
//  Created by light on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HeightChangeBlock)(CGFloat height);

@interface WYCollectionView : UICollectionView

@property (nonatomic, copy) HeightChangeBlock heightChangeBlock;

@end
