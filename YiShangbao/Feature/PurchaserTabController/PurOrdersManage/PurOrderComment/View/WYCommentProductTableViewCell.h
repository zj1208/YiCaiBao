//
//  WYCommentProductTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"
#import "JLStartView.h"

typedef NS_ENUM(NSInteger, WYCommentCellType) //
{
    WYCommentCellType_Purchasr = 0,//采购段cell类型
    WYCommentCellType_Seller = 1,//商户段cell类型
    
};
@class WYCommentProductTableViewCell;
@protocol WYCommentProductTableViewCellDelegate <NSObject>

-(void)jl_WYCommentProductTableViewCell:(WYCommentProductTableViewCell*)wycommentProductTableViewCell commitInfoChangeStart:(NSString*)start textfildText:(NSString*)text;

@end
@interface WYCommentProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *IMV;
@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;
@property (weak, nonatomic) IBOutlet JLStartView *jlstartview;
@property (weak, nonatomic) IBOutlet UILabel *startDescLabel;

@property(nonatomic,weak)id<WYCommentProductTableViewCellDelegate>delegate;

@property (strong, nonatomic)NSArray *startTitleList;

@end
