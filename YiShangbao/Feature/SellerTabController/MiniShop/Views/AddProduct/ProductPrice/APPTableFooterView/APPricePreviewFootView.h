//
//  APPricePreviewFootView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/3/21.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPricePreviewFootView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *minQuaLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabe;

-(void)setPriceData:(NSArray *)array unit:(NSString *)unit show:(BOOL)show;
@end
