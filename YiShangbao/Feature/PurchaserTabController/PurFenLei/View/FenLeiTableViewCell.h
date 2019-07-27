//
//  FenLeiTableViewCell.h
//  YiShangbao
//
//  Created by 海狮 on 17/7/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FenLeiTableViewCellType){
    
    FenLeiTableViewCellDefaultStyle        = 0,
    
    FenLeiTableViewCellSelectedStyle          = 1,

};
@interface FenLeiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myimageView;
@property (weak, nonatomic) IBOutlet UILabel *myTitlelabel;
@property(nonatomic,assign)FenLeiTableViewCellType curryType;
@end
