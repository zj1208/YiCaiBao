//
//  PurAStoreCollectionViewCell.h
//  YiShangbao
//
//  Created by light on 2018/5/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const PurAStoreCollectionViewCellID;

@interface PurAStoreCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

- (void)updateData:(id)model;

@end
