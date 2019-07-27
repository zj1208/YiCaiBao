//
//  WYShareCollectionViewCell.h
//  YiShangbao
//
//  Created by light on 2018/4/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYShareViewController;

extern NSString *const WYShareCollectionViewCellID;

@interface WYShareCollectionViewCell : UICollectionViewCell

//@property (nonatomic) WYShareType shareType;
- (void)updaDataShareType:(NSInteger)shareType;

@end
