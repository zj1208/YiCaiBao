//
//  ProductClassSecondSectionCollectionViewCell.h
//  YiShangbao
//
//  Created by 海狮 on 17/5/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell类型枚举
 */
typedef NS_ENUM(NSInteger, WYClassCellType){

    WYClassCellTypeDafault          = 0,

    WYClassCellTypeSelected         = 1,
    
    WYClassCellTypeCannotSelected   = 2 //
};

@interface ProductClassSecondSectionCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabelWY;
@property(nonatomic,assign)WYClassCellType curryState;

@end
