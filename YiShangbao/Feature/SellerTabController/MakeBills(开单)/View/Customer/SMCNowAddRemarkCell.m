//
//  SMCNowAddRemarkCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/2/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SMCNowAddRemarkCell.h"

@implementation SMCNowAddRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textView.placeholder = @"请输入备注";
    [self.textView setMaxCharacters:50 textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
        
        //        NSLog(@"%ld",remainCount);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
