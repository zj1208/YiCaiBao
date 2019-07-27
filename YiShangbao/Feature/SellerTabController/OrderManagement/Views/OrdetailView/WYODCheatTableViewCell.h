//
//  WYODCheatTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYODCheatTableViewCell;
@protocol WYODCheatTableViewCellDelegate <NSObject>

@optional
-(void)jl_WYODCheatTableViewCell:(WYODCheatTableViewCell*)WYODCheatTableViewCell didBtn:(UIButton*)sender text:(NSString*)text;


-(void)jl_WYODCheatTableViewCell:(WYODCheatTableViewCell*)WYODCheatTableViewCell cellTextFieldChange:(UITextField*)textfield text:(NSString*)text;

-(void)jl_WYODCheatTableViewCell:(WYODCheatTableViewCell*)WYODCheatTableViewCell didReturnTextField:(UITextField*)textfield text:(NSString*)text;
@end


@interface WYODCheatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *layerCornView;
@property (weak, nonatomic) IBOutlet UITextField *textfild;
@property (weak, nonatomic) IBOutlet UIButton *wanchenbtn;

@property(nonatomic,weak)id<WYODCheatTableViewCellDelegate>delegate;
-(void)setCellData:(id)data;

@end
