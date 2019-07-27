//
//  MSCRightTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#define  ContentWidth  LCDW-15-30.f*LCDW/375.f-20-30-9.f*2

#import "MSCRightTableViewCell.h"
#import "MSCTranslationModel.h"

@implementation MSCRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.LabelContentView.layer.masksToBounds = YES;
    self.LabelContentView.layer.cornerRadius = 3.f;

    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 0.5;
    [self.contentView addGestureRecognizer:longPressGr];

}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.contentView];
        [self addMenuControllerWith:point];
    }
}
#pragma mark 菜单选项
-(void)addMenuControllerWith:(CGPoint)point
{
    [self becomeFirstResponder];
    
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
    UIMenuItem *deleteMenuItem = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteAction:)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuItems:[NSArray arrayWithObjects:deleteMenuItem,copyMenuItem,nil]];
    [menuController setTargetRect:CGRectMake(self.center.x, _LabelContentView.frame.origin.y+5, 0, 0) inView:self.contentView];
    [menuController setMenuVisible:YES animated: YES];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    NSLog(@"%@",NSStringFromSelector(action));
    if (action == @selector(copyAction:)) {
        return YES;
    }
    if (action == @selector(deleteAction:)) {
        return YES;
    }
    return NO;
}
- (void)copyAction:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    NSString* str = [NSString stringWithFormat:@"%@\n%@",self.englishLabel.text,self.chineseLabel.text];
    [pboard setString:str];
    
    NSLog(@"%@",pboard.string);
}
- (void)deleteAction:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}


-(void)setModel:(MSCTranslationModel *)model
{
    _model = model;
    
    self.englishLabel.text = [NSString stringWithFormat:@"%@",model.english];
    
    if (model.TranslationFailure) {
        self.chineseLabel.text = [NSString stringWithFormat:@"%@",model.TranslationFailure];
        self.chineseLabel.textColor = [WYUISTYLE colorWithHexString:@"45a4e8"];
    }else{
        self.chineseLabel.text = [NSString stringWithFormat:@"%@",model.chinese];
        self.chineseLabel.textColor = [WYUISTYLE colorWithHexString:@"2f2f2f"];
    }
    
}


- (CGFloat)getCellHeightWithContentData:(id)data
{    
    
    MSCTranslationModel* model = (MSCTranslationModel*)data;
    
    self.chineseLabel.text = [NSString stringWithFormat:@"%@",model.chinese];
    self.englishLabel.text = [NSString stringWithFormat:@"%@",model.english];
    
    CGRect rect_C = [model.chinese boundingRectWithSize:CGSizeMake(ContentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5f]} context:nil];
    
    CGRect rect_E = [model.english boundingRectWithSize:CGSizeMake(ContentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5f]} context:nil];
    
    CGFloat h = 7.f*2 +rect_C.size.height+rect_E.size.height+10.f +1.f;
    
    [self.LabelContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h).priority(1000);
    }];
    return 95.f-64.f+h;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
