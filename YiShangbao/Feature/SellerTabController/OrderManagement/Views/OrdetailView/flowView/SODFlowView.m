//
//  SODFlowView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
// -----买家下单-《卖家确认》-买家付款-卖家发货-买家收货-----


#define LINE_W_NOR        88.f/2*LCDW/375.f  //选中状态左右线宽度
#define LINE_W_SEL_LEFT_Right 78.f/2*LCDW/375.f

#define IMG_NOR_W_H 30.f/2  //未选中图宽度
#define IMG_SEl_W_H 50.f/2  //选中图宽度

#define LABEL_W 50.f   //文字label宽度
#define LABEL_H 20.f


#import "SODFlowView.h"

#import "OrderManagementDetailModel.h"

@implementation SODFlowView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

/**
:for循环一个个加过去，每一个imageView.x为上一个imageView.MaxX加间隙，最后调整View宽度

 @param array 数据源
 @param statusSta 对应array中seq
 */
-(void)addflowviewsWithArray:(NSArray*)array statusSta:(NSNumber *)statusSta;
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (array.count<=0 || !array) {
        return;
    }
    NSInteger curryselected = 0;
    for (int i=0; i<array.count; ++i) {
        OMDStatusHubModel* model = array[i];
        if ([model.seq isEqualToNumber:statusSta]) {
            curryselected = i;
        }
    }
    
    UIImage* image_yiwancheng ;
    UIImage* image_xuanzhong ;
    UIImage* image_weixuanzhong ;
    
    UIImage* image_line_yiwancheng ;
    UIImage* image_line_jinxingzhong;
    UIImage* image_line_weiwancheng ;
    UIImage* image_line_shijianzhou  ;
    
    UIColor* titleSelectedColor ;
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) { //2买家图片 4卖家图片
        image_yiwancheng = [UIImage imageNamed:@"timeline_vis"];
        image_xuanzhong = [UIImage imageNamed:@"timeline_nor"];
        image_weixuanzhong = [UIImage imageNamed:@"timeline_dis"];
        
        image_line_yiwancheng = [UIImage imageNamed:@"pic_loading_or"];
        image_line_jinxingzhong = [UIImage imageNamed:@"pic_loading_or"];
        image_line_weiwancheng = [UIImage imageNamed:@"ic_weiwancheng"];
        image_line_shijianzhou = [UIImage imageNamed:@"pic_loading_half"];

        titleSelectedColor =  [WYUISTYLE colorWithHexString:@"F58F23"];
    }else{
        image_yiwancheng = [UIImage imageNamed:@"ic_shijianzhou_yiwancheng"];
        image_xuanzhong = [UIImage imageNamed:@"ic_shiianzhou_xuanzhong"];
        image_weixuanzhong = [UIImage imageNamed:@"ic_shiajianzhou_weixuanzhong"];

        image_line_yiwancheng = [UIImage imageNamed:@"icon_yiwancheng"];
        image_line_jinxingzhong = [UIImage imageNamed:@"icon_jinxingzhong"];
        image_line_weiwancheng = [UIImage imageNamed:@"ic_weiwancheng"];
        image_line_shijianzhou = [UIImage imageNamed:@"line_shijianzhou"];
        
        titleSelectedColor =  [WYUISTYLE colorWithHexString:@"FF5434"];

    }
    
    if (self.superview) {
        [self.superview layoutIfNeeded];
    }
    UIView *View = [[UIView alloc] initWithFrame:self.bounds];
    //    View.backgroundColor = [UIColor blueColor];
    [self addSubview:View];
    
    CGFloat Last_MaxX = -5.f;
    for (int i =0; i<array.count; ++i) {
        
        OMDStatusHubModel* model = array[i];
        NSString* title = model.value;
        
        if (i < curryselected) //已完成
        {
            UIImageView* imvHead = [[UIImageView alloc] initWithFrame:CGRectMake(Last_MaxX+5.f,IMG_SEl_W_H/2-IMG_NOR_W_H/2, IMG_NOR_W_H, IMG_NOR_W_H)];
            imvHead.image = image_yiwancheng;
            [View addSubview:imvHead];
            
            Last_MaxX = CGRectGetMaxX(imvHead.frame);
            
            CGFloat Line_W ;
            if (i+1==curryselected) {
                Line_W = LINE_W_SEL_LEFT_Right;
            }else{
                Line_W = LINE_W_NOR;
            }
            UIImageView* imvLine = [[UIImageView alloc] initWithFrame:CGRectMake(Last_MaxX+5.f,IMG_SEl_W_H/2, Line_W, 2.f)];
            if (i+1==curryselected) {
                imvLine.image = image_line_jinxingzhong;
            }else{
                imvLine.image = image_line_yiwancheng;
            }
            [View addSubview:imvLine];
            
            Last_MaxX = CGRectGetMaxX(imvLine.frame);
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0,IMG_SEl_W_H+8, LABEL_W, LABEL_H)];
            
//            label.text = [NSString stringWithFormat:@"%@",array[i]];
            label.text = title;
            
            label.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(11.f)];
            label.textColor = titleSelectedColor;
            CGPoint labelP = label.center;
            labelP.x = imvHead.center.x;
            label.center = labelP;
            [View addSubview:label];
            
        }else if (i == curryselected)  //选中
        {
            UIImageView* imvHead = [[UIImageView alloc] initWithFrame:CGRectMake(Last_MaxX+5.f,0, IMG_SEl_W_H, IMG_SEl_W_H)];
            imvHead.image = image_xuanzhong;
            [View addSubview:imvHead];
            
            Last_MaxX = CGRectGetMaxX(imvHead.frame);
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, IMG_SEl_W_H+8, LABEL_W, LABEL_H)];
//            label.text = [NSString stringWithFormat:@"%@",array[i]];
            label.text = title;
            
            label.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(11.f)];
            label.textColor = titleSelectedColor;
            CGPoint labelP = label.center;
            labelP.x = imvHead.center.x;
            label.center = labelP;
            [View addSubview:label];
            
            if (i == array.count-1) {
                break;//
            }
            UIImageView* imvLine = [[UIImageView alloc] initWithFrame:CGRectMake(Last_MaxX+5.f, IMG_SEl_W_H/2, LINE_W_SEL_LEFT_Right, 2.f)];
            imvLine.image = image_line_shijianzhou;
            [View addSubview:imvLine];
            
            Last_MaxX = CGRectGetMaxX(imvLine.frame);
            
        }else //未完成
        {
            UIImageView* imvHead = [[UIImageView alloc] initWithFrame:CGRectMake(Last_MaxX+5.f,IMG_SEl_W_H/2-IMG_NOR_W_H/2, IMG_NOR_W_H, IMG_NOR_W_H)];
            imvHead.image = image_weixuanzhong;
            [View addSubview:imvHead];
            
            Last_MaxX = CGRectGetMaxX(imvHead.frame);
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, IMG_SEl_W_H+8, LABEL_W, LABEL_H)];
//            label.text = [NSString stringWithFormat:@"%@",array[i]];
            label.text = title;

            label.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(11.f)];
            label.textColor = [WYUISTYLE colorWithHexString:@"535353"];
            CGPoint labelP = label.center;
            labelP.x = imvHead.center.x;
            label.center = labelP;
            [View addSubview:label];
            
            if (i == array.count-1) {
                break; //
            }
            UIImageView* imvLine = [[UIImageView alloc] initWithFrame:CGRectMake(Last_MaxX+5.f, IMG_SEl_W_H/2, LINE_W_NOR, 2.f)];
            imvLine.image = image_line_weiwancheng;
            [View addSubview:imvLine];
            
            Last_MaxX = CGRectGetMaxX(imvLine.frame);
            
        }
    }
    
    CGRect frameV = View.frame;
    frameV.size.width = Last_MaxX;
    View.frame = frameV;
    
    CGPoint center = View.center;
    center.x = LCDW/2;
    View.center = center;//调整位置居中
    
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
