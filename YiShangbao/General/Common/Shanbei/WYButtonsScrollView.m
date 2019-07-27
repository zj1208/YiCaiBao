//
//  WYButtonsScrollView.m
//  YiShangbao
//
//  Created by light on 2017/10/31.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYButtonsScrollView.h"

@interface WYButtonsScrollView ()

@property (nonatomic ,strong) UIView *selectionBarView;
@property (nonatomic ,strong) UIView *backgroundView;
@property (nonatomic ,strong) NSMutableArray *Array;

@property (nonatomic) NSInteger index;
@end

@implementation WYButtonsScrollView

- (id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    
    self.backgroundView = [[UIView alloc]init];
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    self.selectionBarView = [[UIView alloc]init];
    self.selectionBarView.layer.cornerRadius = 1.5;
    self.selectionBarView.layer.masksToBounds = YES;
    [self.selectionBarView setBackgroundColor:[UIColor colorWithHex:0xFF5434]];
    
    [self buttonsWithArray:@[@"请选择"]];
    [self selectButtonIndex:0];
    
    return self;
}

- (void)selectButtonIndex:(NSInteger)index{
    self.index = index;
    
    UIButton *selectedButton;
    NSArray *array = self.backgroundView.subviews;
    for (UIButton *button in array) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor colorWithHex:0x2F2F2F] forState:UIControlStateNormal];
            if (button.tag == (self.index + 100)) {
                selectedButton = button;
            }
        }
    }
    [selectedButton setTitleColor:[UIColor colorWithHex:0xFF5434] forState:UIControlStateNormal];
    
    [self.selectionBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectedButton.mas_left).offset(10);
        make.right.equalTo(selectedButton.mas_right).offset(-10);
        make.bottom.equalTo(self.backgroundView);
        make.height.equalTo(@3);
    }];
}

- (void)buttonsWithArray:(NSArray *)array{
    if (!array || array.count == 0) {
        return;
    }
    
    [self.backgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.backgroundView addSubview:self.selectionBarView];
    
    UIButton *firstButton = [[UIButton alloc]init];
    [self.backgroundView addSubview:firstButton];
    [firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView);
        make.left.equalTo(self.backgroundView);
        make.bottom.equalTo(self.backgroundView).offset(-3);
        make.width.equalTo(@10);
    }];
    
    for (int i = 0; i < array.count ; i++ ) {
        NSString *buttonTitle = array[i];
        UIButton *button = [[UIButton alloc]init];
        [self.backgroundView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundView);
            make.left.equalTo(firstButton.mas_right);
            make.bottom.equalTo(self.backgroundView).offset(-3);
        }];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"    %@    ",buttonTitle] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [button setTitleColor:[UIColor colorWithHex:0x2F2F2F] forState:UIControlStateNormal];
        button.tag = i + 100;
        firstButton = button;
    }
    
    UIButton *lastButton = [[UIButton alloc]init];
    [self.backgroundView addSubview:lastButton];
    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView);
        make.left.equalTo(firstButton.mas_right);
        make.bottom.equalTo(self.backgroundView).offset(-3);
        make.right.equalTo(self.backgroundView);
        make.width.equalTo(@10);
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    [self selectButtonIndex:sender.tag - 100];
    if (self.delegateObj && [self.delegateObj respondsToSelector:@selector(selectedButtonIndex:)]) {
        [self.delegateObj selectedButtonIndex:sender.tag - 100];
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
