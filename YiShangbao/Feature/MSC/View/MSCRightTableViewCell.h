//
//  MSCRightTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCTranslationModel.h"

typedef void(^DeleteBlock)(void);
@interface MSCRightTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
@property (weak, nonatomic) IBOutlet UIView *LabelContentView;

@property(nonatomic, strong) MSCTranslationModel* model;

- (CGFloat)getCellHeightWithContentData:(id)data;
@property (nonatomic, copy)DeleteBlock deleteBlock;

@end
