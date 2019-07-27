//
//  WYEditCategoryView.m
//  YiShangbao
//
//  Created by light on 2017/12/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYEditCategoryView.h"

@interface WYEditCategoryView ()

@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UIButton *reNameButton;
@property (nonatomic ,strong) UIButton *deleteButton;

@end

@implementation WYEditCategoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    UIImage *image = [UIImage imageNamed:@"bg_btn"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(9, 45, 5, 5);
    image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    [self.imageView setImage:image];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-6);
    }];
    
    self.reNameButton = [[UIButton alloc]init];
    [self addSubview:self.reNameButton];
    [self.reNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reNameButton.mas_bottom);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@0.5);
    }];
    
    self.deleteButton = [[UIButton alloc]init];
    [self addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reNameButton.mas_bottom).offset(0.5);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-6);
        make.height.equalTo(self.reNameButton);
    }];
    
    [line setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.16]];
    [self.reNameButton setTitle:@"分类重命名" forState:UIControlStateNormal];
    [self.reNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.reNameButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.deleteButton setTitle:@"删除此分类" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    [self.reNameButton addTarget:self action:@selector(renameButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    UIImage *image = [UIImage imageNamed:@"bg_btn"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(9, 45, 5, 5);
    if (frame.origin.y > SCREEN_HEIGHT - 200){
        image = [UIImage imageNamed:@"bg_btn_down"];
        edgeInsets = UIEdgeInsetsMake(5, 45, 9, 5);
        frame.origin.y -= 150;
        
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(6);
            make.bottom.equalTo(self);
        }];
    }else{
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-6);
        }];
    }
    image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    [self.imageView setImage:image];
    
    [super setFrame:frame];
}

#pragma mark- ButtonAction
- (void)renameButtonAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(renameCategory)]) {
        [self.delegate renameCategory];
        self.hidden = YES;
    }
}

- (void)deleteButtonAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCategory)]) {
        [self.delegate deleteCategory];
        self.hidden = YES;
    }
}

@end
