//
//  WYCollectionView.m
//  YiShangbao
//
//  Created by light on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYCollectionView.h"

@implementation WYCollectionView

- (void)setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    if (self.heightChangeBlock) {
        self.heightChangeBlock(contentSize.height);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
