//
//  ShopHomeAdvView.h
//  YiShangbao
//
//  Created by light on 2018/8/7.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopHomeAdvViewDelegate <NSObject>
@optional

- (void)shopHomeAdvUrl:(NSString *)url;

@end

@interface ShopHomeAdvView : UIView

@property (nonatomic, weak) id<ShopHomeAdvViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *advButton;
@property (nonatomic, strong) UIButton *closeButton;

- (void)updateAdvModel:(id)model;

@end
