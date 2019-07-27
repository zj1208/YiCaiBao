//
//  ExtendProductFirstTableViewCell.h
//  YiShangbao
//
//  Created by 海狮 on 17/5/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"

@class ExtendProductFirstTableViewCell;
@protocol ExtendProductFirstTableViewCellDelegate <NSObject>

/**
 点击选择类目按钮时候的回调；
  */
-(void)jl_clcikExtendProductFirstTableViewCellChoseClassbtn:(ExtendProductFirstTableViewCell*)cell classLabel:(UILabel*)classlabel;


@end


@interface ExtendProductFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;

@property (weak, nonatomic) IBOutlet UIView *textBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (nonatomic, weak) id<ExtendProductFirstTableViewCellDelegate>delegate;
//最多可输入文字个数
@property(nonatomic,assign)NSInteger numWordsOfcountLabel;
@end
