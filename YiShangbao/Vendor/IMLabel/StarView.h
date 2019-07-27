//
//  StarView.h
//  StartForComment
//  Created by STBL－LHY on 16/5/10.
//  Copyright © 2016年 STBL－LHY. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface PaddingButton : UIButton

@property (nonatomic,assign)CGFloat exWidth;

@end

@interface StarView : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, assign) BOOL forSelect;

@property (nonatomic ,copy)void(^onStart)(NSInteger);
- (void)markStar:(NSInteger)star;
- (instancetype)initWithFrame:(CGRect)frame imageWidth:(CGFloat)imageWidth ;
@end
