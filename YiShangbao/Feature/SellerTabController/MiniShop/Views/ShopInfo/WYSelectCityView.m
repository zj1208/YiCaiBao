//
//  WYSelectCityView.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYSelectCityView.h"



@interface WYSelectCityView()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIView *_BJView;                    //背景view;
    NSArray *_AllAry;                   //取出所有数据(json类型，在plist里面)
    NSMutableArray *_proviceAry;        //只装省份的数组
    NSMutableArray *_cityAry;           //只装城市的数组
    NSMutableArray *_districtAry;       //只装区的数组
    UIPickerView *_pickView;            //最主要的选择器
    
    NSInteger _proIndex;                //用于记录选中哪个省的索引
    NSInteger _cityIndex;               //用于记录选中哪个市的索引
    NSInteger _districtIndex;           //用于记录选中哪个区的索引
}

@property(nonatomic, strong) void (^select)(NSDictionary *provice, NSDictionary *city, NSDictionary *dis);

@end

@implementation WYSelectCityView

-(instancetype)initSelectFrame:(CGRect)rect WithTitle:(NSString *)title{
    if (self = [super initWithFrame:rect]) {
        _proviceAry = [NSMutableArray array];
        _cityAry = [NSMutableArray array];
        _districtAry = [NSMutableArray array];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
        
        //显示pickView和按钮下面的View
        _BJView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
        [self addSubview:_BJView];
        
        UIView *tool = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        tool.backgroundColor = [UIColor colorWithRed:237/255.0 green:236/255.0 blue:234/255.0 alpha:1];
        [_BJView addSubview:tool];
        
        /**
         按钮+中间可以显示标题的UILabel
         */
        UIButton *left = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        left.frame = CGRectMake(0, 0, 60, 40);
        [left setTitle:@"取消" forState:UIControlStateNormal];
        [left addTarget:self action:@selector(leftBTN) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:left];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(left.frame.size.width, 0, SCREEN_WIDTH-(left.frame.size.width*2), 40)];
        titleLB.text = title;
        titleLB.textAlignment = NSTextAlignmentCenter;
        [tool addSubview:titleLB];
        
        UIButton *right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        right.frame = CGRectMake(SCREEN_WIDTH-60 ,0,60, 40);
        [right setTitle:@"确定" forState:UIControlStateNormal];
        [right addTarget:self action:@selector(rightBTN) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:right];
        
        
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40, SCREEN_WIDTH, _BJView.frame.size.height-40)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        [_BJView addSubview:_pickView];
        
//从json中取出数据
        NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
        NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
        NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        _proviceAry = [jsonDic objectForKey:@"provice"];                //省的数组
        
        _cityAry = [NSMutableArray arrayWithArray:[_proviceAry[_proIndex] objectForKey:@"city"]];  //城市的数组
        [_pickView reloadComponent:1];
        [_pickView selectRow:0 inComponent:1 animated:YES];

        _districtAry =[NSMutableArray arrayWithArray:[[_proviceAry[_proIndex] objectForKey:@"city"][0] objectForKey:@"town"]];                                             //区的数组
        [_pickView reloadComponent:2];
        [_pickView selectRow:0 inComponent:2 animated:YES];
    }
    return self;
}


#pragma mark -PickerView的数据源方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) return _proviceAry.count;
    if (component == 1) return _cityAry.count;
    if (component == 2) return _districtAry.count;
    return 0;
}



#pragma mark -PickerView的代理方法
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0){
        return [_proviceAry[row] objectForKey:@"name"];
    }
    if (component==1){
        NSDictionary *province = _proviceAry[_proIndex];
        return [[province objectForKey:@"city"][row] objectForKey:@"name"];
    }
    if (component==2) {
        NSDictionary *province = _proviceAry[_proIndex];
        NSDictionary *city = [province objectForKey:@"city"][_cityIndex];
        return [[city objectForKey:@"town"][row] objectForKey:@"name"];
    }
    return nil;
}


//自定义每个pickview的label 设置对应的字体大小
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = [UILabel new];
    pickerLabel.numberOfLines = 0;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:12]];
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _proIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        
        _cityAry = [NSMutableArray arrayWithArray:[_proviceAry[_proIndex] objectForKey:@"city"]];  //城市的数组
        [_pickView selectRow:0 inComponent:1 animated:YES];
        //区的数组
        if (_cityAry.count > 0) {
            _districtAry =[NSMutableArray arrayWithArray:[_cityAry[0] objectForKey:@"town"]];
            [_pickView selectRow:0 inComponent:2 animated:YES];
        }else{
            _districtAry = [NSMutableArray array];
        }
        [_pickView reloadComponent:1];
        [_pickView reloadComponent:2];
    }
    
    if (component == 1) {
        _cityIndex = row;
        _districtIndex = 0;
        if (_cityAry.count > 0) {
            _districtAry =[[_proviceAry[_proIndex] objectForKey:@"city"][_cityIndex] objectForKey:@"town"];
        }else{
            _districtAry = [NSMutableArray array];
        }
        [_pickView reloadComponent:2];
        [_pickView selectRow:0 inComponent:2 animated:YES];
    }
    
    if (component == 2) {
        _districtIndex = row;
    }
}


/**
 *  左边的取消按钮
 */
-(void)leftBTN{
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
-(void)rightBTN{
    __weak typeof(UIView*)blockview = _BJView;
    __weak typeof(self)blockself = self;
    __block int blockH = SCREEN_HEIGHT;
    
    if (self.select) {
        NSDictionary *pro = _proviceAry.count ? _proviceAry[_proIndex] : nil ;
        NSDictionary *city = _cityAry.count ? _cityAry[_cityIndex] : nil ;
        NSDictionary *district = _districtAry.count ? _districtAry[_districtIndex] : nil ;
        self.select(pro ,city ,district);
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


-(void)showCityView:(void (^)(NSDictionary *, NSDictionary *, NSDictionary *))selectDic{
    
    self.select = selectDic;
    
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
        [self leftBTN];
    }
    
}
@end
