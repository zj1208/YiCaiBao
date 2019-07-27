//
//  WYODAddressAndMessageTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
// 收货地址+留言

#import "WYODAddressAndMessageTableViewCell.h"
#import "OrderManagementDetailModel.h"

@implementation WYODAddressAndMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) { //2买家 4卖家
        self.liuyanLabel.textColor = [WYUISTYLE colorWithHexString:@"#FF5434"];
    }
    
    //地址长按复制
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 0.5;
    [self.addressContentview addGestureRecognizer:longPressGr];
}
-(CGFloat)getCellHeightWithContentData:(id)data
{
    OrderManagementDetailModel* model = data;

    CGFloat addressHeight = [self sizeHeightBystr:[NSString stringWithFormat:@"收货地址：%@",model.address]];
    CGFloat buyerWordsHeight = [self sizeHeightBystr:[NSString stringWithFormat:@"买家留言：%@",model.buyerWords]];
    
    if ([NSString zhIsBlankString:model.buyerWords]) {
        return 155.f-70.f+(-37+addressHeight);  //无留言-70.f,
    }else{
        return 155.f+(-37+addressHeight)+(-37+buyerWordsHeight);
    }
    
}
-(CGFloat)sizeHeightBystr:(NSString*)str
{
    NSMutableParagraphStyle *paraStyl = [[NSMutableParagraphStyle alloc] init];
    paraStyl.lineBreakMode = _addressLabel.lineBreakMode; //字符换行模式
    paraStyl.minimumLineHeight = 18.5f; //把设置行高也要计算

    CGRect addressRect = [str boundingRectWithSize:CGSizeMake(LCDW-48.f-23.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f],NSParagraphStyleAttributeName:paraStyl} context:nil];
    return  addressRect.size.height;
}


-(void)setCellData:(id)data
{
    OrderManagementDetailModel* model = data;

    CGFloat addressHeight = [self sizeHeightBystr:[NSString stringWithFormat:@"收货地址：%@",model.address]];
    
    [self.addressContentview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(85+(-37+addressHeight));
    }];
    
    self.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",model.consignee];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",model.consigneePhone];
    self.addressLabel.text =[NSString stringWithFormat:@"收货地址：%@",model.address];
    self.liuyanLabel.text = [NSString stringWithFormat:@"买家留言：%@",model.buyerWords];
    
    //设置行高
    [self.addressLabel jl_setAttributedText:nil withMinimumLineHeight:18.5];
    [self.liuyanLabel jl_setAttributedText:nil withMinimumLineHeight:18.5];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem,nil]];
    [menuController setTargetRect:CGRectMake(self.center.x,self.addressContentview.zx_height/2.0, 0, 0) inView:self.contentView];
    [menuController setMenuVisible:YES animated: YES];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)resignFirstResponder
{
    //重置下，UIMenuController是手机全局通用的，eg不然跳到云信那边使用粘贴板多个复制,点击崩溃
    [[UIMenuController sharedMenuController] setMenuItems:nil];
    return [super resignFirstResponder];
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}
- (void)copyAction:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];

    NSString* str = [NSString stringWithFormat:@"%@\n电话：%@\n%@",self.nameLabel.text,self.phoneLabel.text,self.addressLabel.text];
    [pboard setString:str];
    
    NSLog(@"%@",pboard.string);
}



@end
