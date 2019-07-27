//
//  WYSelectedTableViewCell.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  cell类型枚举
 */

typedef NS_ENUM(NSInteger,WYSelectedTableViewCellStyle){
    WYSelectedTableViewCellStyleDefault         = 0,
    
    WYSelectedTableViewCellStyleSelected        = 1,
};
@interface WYSelectedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myimageView;
@property(nonatomic,assign)WYSelectedTableViewCellStyle currtTepe;
@end
