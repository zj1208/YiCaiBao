//
//  UIButton+WYMoreClickZone.m
//  YiShangbao
//
//  Created by light on 2017/9/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIButton+WYMoreClickZone.h"

static const void *objectKey = &objectKey;

@implementation UIButton (WYMoreClickZone)

- (void)setIsMoreClickZone:(Boolean)isMoreClickZone{
    objc_setAssociatedObject(self, objectKey, [NSNumber numberWithBool:isMoreClickZone], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (Boolean)isMoreClickZone{
    return [objc_getAssociatedObject(self, objectKey) boolValue];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds;
    if (self.isMoreClickZone) {
        bounds =CGRectMake(-15, -15, self.bounds.size.width + 30, self.bounds.size.height + 30);
    }else{
        bounds =CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }
    return CGRectContainsPoint(bounds, point);
}

@end
