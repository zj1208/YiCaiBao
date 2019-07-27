//
//  MainBusinessCell.h
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  设置主营

#import "BaseTableViewCell.h"
#import "ProductModel.h"
#import "TMDiskManager.h"

typedef NS_ENUM(NSInteger ,DoingType) {
    
    DoingType_AddProduct = 0,
    DoingType_EditProduct = 1
    
};


@interface MainBusinessCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *mainBusinessBtn;

@property (weak, nonatomic) IBOutlet UILabel *chanceNumLab;

@property (nonatomic, strong)TMDiskManager *diskManager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMagin;


- (void)setData:(id)data doingType:(DoingType)doingType;

- (BOOL)isMainBussiness;
@end
