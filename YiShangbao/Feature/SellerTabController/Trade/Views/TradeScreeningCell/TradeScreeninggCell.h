//
//  TradeScreeninggCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/10/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TopSelTypeTableViewCellType){
    
    TopSelTypeTableViewCellDafault          = 0,
    
    TopSelTypeTableViewCellSelected         = 1,
    
    //    TopSelTypeTableViewCellNoSelected       = 2  //
};
@interface TradeScreeninggCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imV;
@property (weak, nonatomic) IBOutlet UILabel *selLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;

@property(nonatomic,assign)TopSelTypeTableViewCellType curryStyle;

@end
