//
//  AddProductPicsController.h
//  YiShangbao
//
//  Created by simon on 17/3/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  用collectionView，超过5张的时候使用

#import <UIKit/UIKit.h>

@interface AddProductPicsController : UICollectionViewController

- (IBAction)saveBarItemAction:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarItem;

@end
