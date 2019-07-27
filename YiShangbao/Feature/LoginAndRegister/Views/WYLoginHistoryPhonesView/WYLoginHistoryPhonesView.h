//
//  WYLoginHistoryPhonesView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/6/1.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectHistory)(NSString *countryCode, NSString *phone);
typedef void (^HistoryPhonesViewWillRemove)(void);
@interface WYLoginHistoryPhonesView : UIView

-(void)setTopFollowingWithView:(UIView *)topView;
@property(nonatomic, strong) NSArray *arrayTitles;

@property (nonatomic,copy) SelectHistory phoneBlock;
@property (nonatomic,copy) HistoryPhonesViewWillRemove hvWillRemove;

@end
