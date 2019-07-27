//
//  NicknameEditView.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "NicknameEditView.h"

@implementation NicknameEditView

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    self.edit = [[UITextField alloc] initWithFrame:CGRectMake(0, 76, SCREEN_WIDTH, 44)];
    [self addSubview:self.edit];
    [self.edit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(12);
        } else {
            make.top.equalTo(self.mas_top).offset(12+HEIGHT_NAVBAR);
        }
        make.height.equalTo(@(44));
    }];
    self.edit.backgroundColor = WYUISTYLE.colorBWhite;
    self.edit.placeholder = @"请输入商铺名称或昵称";
//    [self.edit setValue:WYUISTYLE.colorBTgrey forKeyPath:@"_placeholderLabel.textColor"];
//    [self.edit setValue:WYUISTYLE.fontWith28 forKeyPath:@"_placeholderLabel.font"];
    [self.edit setValue:[NSNumber numberWithInt:14] forKey:@"paddingLeft"];
    self.edit.font = WYUISTYLE.fontWith30;
    self.edit.leftViewMode = UITextFieldViewModeAlways;
    self.edit.returnKeyType = UIReturnKeyNext;
    self.edit.textColor = WYUISTYLE.colorMTblack;
    self.edit.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return self;
}

@end
