//
//  WYSelectedTableView.m
//  YiShangbao
//
//  Created by 海狮 on 17/6/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#define CELL_H LCDScale_5Equal6_To6plus(44.f)
#import "WYSelectedTableView.h"
#import "WYSelectedTableViewCell.h"
@interface WYSelectedTableView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIView *BackView;
@property(nonatomic,strong)NSArray* arrayData;
@property(nonatomic,assign)NSInteger selectInteger;

@end

@implementation WYSelectedTableView

-(instancetype)initWithFrame:(CGRect)frame WithArray:(NSArray *)array
{
    if (self = [super initWithFrame:frame]) {
        self.arrayData = [NSArray arrayWithArray:array];
        [self buildUI];

    }
    return self;
}
-(void)updateFrame:(CGRect )frame
{
    self.frame = frame;
    [self layoutIfNeeded];
    self.BackView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    
    NSInteger lineNums = self.arrayData.count;
    CGFloat H = CELL_H*lineNums ;
    H = H>self.frame.size.height?self.frame.size.height:CELL_H*lineNums;
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width,CELL_H*lineNums) ;
}
-(void)setDefaultSelectedInteger:(NSInteger)DefaultSelectedInteger
{
    _DefaultSelectedInteger = DefaultSelectedInteger;
    self.selectInteger = _DefaultSelectedInteger;
    [self.tableView reloadData];
}
-(void)setDefaultSelectedTitle:(NSString *)DefaultSelectedTitle
{
    _DefaultSelectedTitle = DefaultSelectedTitle;
    self.selectInteger =  [self.arrayData indexOfObject:_DefaultSelectedTitle];
    [self.tableView reloadData];
}
-(void)buildUI
{
    self.selectInteger = 0;//默认选择第一个cell
    self.firstCellCanSelected = YES;
    
    self.BackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    self.BackView.backgroundColor = [UIColor blackColor];
    self.BackView.alpha  = 0.35;
    [self addSubview:self.BackView];
    
    NSInteger lineNums = self.arrayData.count;
    CGFloat H = LCDScale_5Equal6_To6plus(44.f)*lineNums ;
    H = H>self.frame.size.height?self.frame.size.height:LCDScale_5Equal6_To6plus(44.f)*lineNums;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,CELL_H*lineNums) style:UITableViewStylePlain];
    _tableView.rowHeight = CELL_H;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    //分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
//    //默认选中第一个Cell
//    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self addSubview:_tableView];
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYSelectedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LEFT"];
    if (cell == nil) {
//        cell = [[WYSelectedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LEFT"];
        cell = [[NSBundle mainBundle] loadNibNamed:@"WYSelectedTableViewCell" owner:nil options:nil][0];
    }
    cell.myTitleLabel.text = self.arrayData[indexPath.row];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (self.selectInteger == indexPath.row) {
        [cell setCurrtTepe:WYSelectedTableViewCellStyleSelected];
    }else{
        [cell setCurrtTepe:WYSelectedTableViewCellStyleDefault];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.firstCellCanSelected && indexPath.row == 0) {
        return;
    }
    BOOL change = self.selectInteger != indexPath.row;
    self.selectInteger = indexPath.row;
    [self.tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_wySelectedTableView:type:didSelectWithInteget:changed:)]) {
        [self.delegate jl_wySelectedTableView:self type:self.type didSelectWithInteget:indexPath.row changed:change];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_wySelectedTableViewViewWillRemove:type:)]) {
        [self.delegate jl_wySelectedTableViewViewWillRemove:self type:self.type];
    }
    [self removeSelfAuto];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_wySelectedTableViewViewWillRemove:type:)]) {
        [self.delegate jl_wySelectedTableViewViewWillRemove:self type:self.type];
    }
    [self removeSelfAuto];

}
-(void)removeSelfAuto{
    if (self.superview) {
        [self removeFromSuperview];
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
