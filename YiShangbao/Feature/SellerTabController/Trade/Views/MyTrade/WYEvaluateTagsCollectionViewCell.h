//
//  WYEvaluateTagsCollectionViewCell.h
//  YiShangbao
//
//  Created by light on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const WYEvaluateTagsCollectionViewCellID;

@interface WYEvaluateTagsCollectionViewCell : UICollectionViewCell

@property (nonatomic) BOOL isSelected;

- (void)setData:(id)name;

@end
