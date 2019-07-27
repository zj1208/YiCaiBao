//
//  ProMListTableView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/10.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ProMListTableView.h"
#import "ProMListTableCell.h"
#import "PopView.h"
@interface ProMListTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,copy) NSArray *titles;

@end
static NSString *cellIdentifier = @"cellIdentifier";
@implementation ProMListTableView
+(void)dissmiss
{
    [PopView hidenPopView];
}
+(void)show:(ProMListTableView *)popListView touchBtn:(UIView *)sender offSet:(CGPoint)offSet didSelectBlock:(DidSelectBlock)didSelectBlock
{    
    popListView.didSelectBlock = ^(NSInteger index, NSString *title) {
        if (didSelectBlock) {
            didSelectBlock(index,title);
        }
    };
    UIView *placeholderView = [[UIView alloc] init];
    placeholderView.userInteractionEnabled = NO;
    CGRect frame = sender.frame;
    CGPoint center = sender.center;

    frame.size = CGSizeMake(frame.size.width+offSet.x, frame.size.height+offSet.y*2.0);
    placeholderView.frame = frame;
    center.x = center.x+offSet.x;
    placeholderView.center = center;
    [sender.superview addSubview:placeholderView];
    
    CGPoint point = [placeholderView.superview convertPoint:CGPointMake(placeholderView.center.x, CGRectGetMaxY(placeholderView.frame)) toView:[UIApplication sharedApplication].delegate.window];
    CGFloat space = LCDH-point.y-20;
    PopViewDirection direct = space<=popListView.frame.size.height?PopViewDirection_PopUpTop:PopViewDirection_PopUpBottom;
    [PopView popUpContentView:popListView direct:direct onView:placeholderView];
  
    [placeholderView removeFromSuperview];
    
}
- (instancetype)initWithTitles:(NSArray *)titles
{
    CGRect frame = CGRectMake(0, 0, 102, titles.count*42);
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;        
        [self addSubview:self.tableView];
        self.backgroundColor = [WYUISTYLE colorWithHexString:@"#535353"];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ProMListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.midLabel.text = [self.titles objectAtIndex:indexPath.row];
    if (indexPath.row == self.titles.count-1) {
        cell.line.hidden = YES;
    }else{
        cell.line.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [PopView hidenPopView];
    if (self.didSelectBlock) {
        self.didSelectBlock(indexPath.row,self.titles[indexPath.row]);
    }
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = NO;
        _tableView.rowHeight = 42;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ProMListTableCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

@end
