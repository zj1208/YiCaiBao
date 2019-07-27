//
//  ShopGuideCell.h
//  YiShangbao
//
//  Created by simon on 17/3/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopGuideCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)setTitle:(NSString *)title;

@end
