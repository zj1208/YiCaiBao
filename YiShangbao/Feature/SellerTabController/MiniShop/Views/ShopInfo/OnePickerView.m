//
//  OnePickerView.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "OnePickerView.h"
#import "ShopModel.h"

@interface OnePickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIView *_BJView;       //背景view
    UIPickerView *_pickView; //最主要的选择器
    NSInteger _oneIndex;    //记录选中的索引
}
@property(nonatomic, copy) void (^select)(NSDictionary *OneStr);
@end
@implementation OnePickerView

-(instancetype)initWithOnePickFrame:(CGRect)rect selectTitle:(NSString *)title{
    if (self = [super initWithFrame:rect]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];

        //显示pickview和按钮最底下的view
        _BJView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
        [self addSubview:_BJView];
        
        UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        toolbar.backgroundColor = [UIColor colorWithRed:237/255.0 green:236/255.0 blue:234/255.0 alpha:1];
        [_BJView addSubview:toolbar];
        
        //按钮+中间可以显示标题的UILabel
        UIButton *left =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        left.frame = CGRectMake(0, 0, 60, 40);
        [left setTitle:@"取消" forState:UIControlStateNormal];
        [left addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:left];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(left.frame.size.width, 0, SCREEN_WIDTH-(left.frame.size.width*2), 40)];
        titleLB.text = title;
        titleLB.textAlignment = NSTextAlignmentCenter;
        [toolbar addSubview:titleLB];
        
        UIButton *right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        right.frame = CGRectMake(SCREEN_WIDTH-60, 0, 60, 40);
        [right setTitle:@"确定" forState:UIControlStateNormal];
        [right addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:right];
        
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, _BJView.frame.size.height-40)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        [_BJView addSubview:_pickView];
        
    }
    return self;
}

#pragma mark - deleg
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _oneIndex = row;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
//        return [_allarr objectAtIndex:row];
        marketModel *model = [marketModel new];
        model = [_allarr objectAtIndex:row];
        return model.name;
    }
    return nil;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return _allarr.count;
    }
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

/**
 *  左边的取消按钮
 */
-(void)leftBtn{
    __weak typeof(UIView*)blockview = _BJView;
    __weak typeof(self)blockself = self;
    __block int blockH = SCREEN_HEIGHT;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        blockself.alpha = 0.1;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
    
}

/**
 *  右边的确认按钮
 */
-(void)rightBtn{
    __weak typeof(UIView*)blockview = _BJView;
    __weak typeof(self)blockself = self;
    __block int blockH = SCREEN_HEIGHT;
    
    if (self.select) {
        self.select(_allarr[_oneIndex]);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        blockself.alpha = 0.1;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
}

-(void)showOnePickView:(void(^)(NSDictionary *marketStr))selectStr{
    
    self.select = selectStr;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    __weak typeof(UIView*)blockview = _BJView;
    __block int blockH = SCREEN_HEIGHT;
    __block int bjH = 260;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH-bjH;
        blockview.frame = bjf;
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_BJView.frame, point)) {
        [self leftBtn];
    }
    
}

@end
