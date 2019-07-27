//
//  SearchCollectionViewCell.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SearchCollectionViewCellType){
    
    SearchCollectionViewCellTypeDafault          = 0,
    
    SearchCollectionViewCellTypeSelected         = 1,
    
};

@interface SearchCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *traling;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

@property(nonatomic,assign)SearchCollectionViewCellType curryState;

@end
