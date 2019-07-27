//
//  TradeDetailTranslationCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/6/6.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JLCopyLabel.h"
@class TradeDetailTranslationCell;
@protocol TradeDetailTranslationCellDelegate <NSObject>
@optional
-(void)jl_reloadTranslationWithCell:(TradeDetailTranslationCell *)cell;
@end
@interface TradeDetailTranslationCell : BaseTableViewCell<UITextViewDelegate>
//外商直采容器
@property (weak, nonatomic) IBOutlet UIView *tranContentView;
//翻译标题
@property (weak, nonatomic) IBOutlet JLCopyLabel *tranTitleLabel;
//翻译内容
@property (weak, nonatomic) IBOutlet JLCopyLabel *tranContentLabel;
//用于翻译失败 超链接重新翻译
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) id<TradeDetailTranslationCellDelegate> delegate;

@end
